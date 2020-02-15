#define S_FUNCTION_NAME  sfun_maxon
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"

#include "mex.h"
#include "Definitions.h"

#ifdef _LINUX_
#include "Win2Linux.h"
#endif

/* Global data for all instance of this S-function */
static volatile int mylock = 0;
static volatile int NumberOfInstances = 0;
static HANDLE mHandle = NULL;
static BYTE OpModes[5];

_inline void EnterLock(void) {
    while (mylock);
    mylock++;
}

_inline void LeaveLock(void) { mylock--; }


/* Check Size and Parameters */

static void mdlInitializeSizes(SimStruct *S) {
    double ThisSampleTime;
    int NodeID, OperationMode;

    /* Set OpModes */
    if (NumberOfInstances == 0) {
        EnterLock();
        OpModes[0] = OMD_CURRENT_MODE;
        OpModes[1] = OMD_VELOCITY_MODE;
        OpModes[2] = OMD_POSITION_MODE;
        LeaveLock();
    };

    /* Number of expected parameters */
    ssSetNumSFcnParams(S, 3);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        /* Return if number of expected != number of actual parameters */
        ssSetErrorStatus(S, "Expected three parameters: SampleTime, NodeID and OperationMode");
        return;
    }
    /* Obtain Sample Time */
    ThisSampleTime = (double) mxGetScalar(ssGetSFcnParam(S, 0));
    if (ThisSampleTime < 0.0) {
        ssSetErrorStatus(S, "Parameter 1 must be > 0.0 and < 1.0");
        return;
    }
    if (ThisSampleTime > 1.0) {
        ssSetErrorStatus(S, "Parameter 1 must be > 0.0 and < 1.0");
        return;
    }
    /* Obtain Node ID */
    NodeID = (int) mxGetScalar(ssGetSFcnParam(S, 1));
    if (NodeID < 0) {
        ssSetErrorStatus(S, "Parameter 2 must be a possitive number");
        return;
    }
    if (NodeID > 16) {
        ssSetErrorStatus(S, "Parameter 2 must be lower than 16");
        return;
    }
    /* Obtain Operation Mode */
    OperationMode = (int) mxGetScalar(ssGetSFcnParam(S, 2));
    if (OperationMode < 1) {
        ssSetErrorStatus(S, "Parameter 3 must be > 1 and < = 3");
        return;
    }
    if (OperationMode > 3) {
        ssSetErrorStatus(S, "Parameter 3 must be > 1 and < = 3");
        return;
    }

    /* continous and discretes states */
    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);

    /* one input port with size one */
    if (!ssSetNumInputPorts(S, 1)) return;
    ssSetInputPortWidth(S, 0, 1);
    /* one output port with size one */
    if (!ssSetNumOutputPorts(S, 1)) return;
    ssSetOutputPortWidth(S, 0, 1);
    /* direct input signal access */
    ssSetInputPortRequiredContiguous(S, 0, true);

    /* Port based sample time */
    ssSetNumSampleTimes(S, PORT_BASED_SAMPLE_TIMES);
    ssSetInputPortSampleTime(S, 0, ThisSampleTime);
    ssSetInputPortOffsetTime(S, 0, 0);
    ssSetOutputPortSampleTime(S, 0, ThisSampleTime / 2.0);
    ssSetOutputPortOffsetTime(S, 0, 0);

    /* two Integers data to store Node ID and OperationMode */
    ssSetNumIWork(S, 2);

    /* No pointers, real works variables */
    ssSetNumPWork(S, 0);
    ssSetNumRWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);

    /* Specify the sim state compliance to be same as a built-in block */
    ssSetSimStateCompliance(S, USE_DEFAULT_SIM_STATE);
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
}

static void mdlInitializeSampleTimes(SimStruct *S) {
    /*
    ssSetSampleTime(S, 0, 0.1);
    ssSetOffsetTime(S, 0, 0.0);
    ssSetModelReferenceSampleTimeDefaultInherance(S);
    */
}

#define MDL_START  /* Change to #undef to remove function */
#if defined(MDL_START)

/* Function: mdlStart =======================================================
 * Abstract:
 *    This function is called once at start of model execution. If you
 *    have states that should be initialized once, this is the place
 *    to do it.
 */
static void mdlStart(SimStruct *S) {
    WORD NodeID;
    DWORD ErrCode = 0;
    BOOL Fault = FALSE;
    LONG actualpos;
    int opmode;

    /* Get Node ID from first parameters */
    NodeID = (WORD) mxGetScalar(ssGetSFcnParam(S, 1));
    /* Get operation mode */
    opmode = (int) mxGetScalar(ssGetSFcnParam(S, 2));
    opmode--;

    /* Store NodeID */
    ssSetIWorkValue(S, 0, (int) NodeID);
    ssSetIWorkValue(S, 1, opmode);

    /* Lock */
    EnterLock();

    /* Store handle */
    if (mHandle == NULL) {
        mHandle = VCS_OpenDevice("EPOS4", "MAXON SERIAL V2", "USB", "USB0", &ErrCode);
        if (ErrCode) {
            mexPrintf("Error opening USB, ErrCode is %i\n", (int) ErrCode);
            ssSetErrorStatus(S, "Error opening Device");
            /* release lock */
            LeaveLock();
            return;
        };
    };

    /* Reseting Error if in error state */
    if (!VCS_GetFaultState(mHandle, NodeID, &Fault, &ErrCode)) {
        mexPrintf("Error Checking Fault, ErrCode is %i\n", (int) ErrCode);
        ssSetErrorStatus(S, "Error Checking Fault State");
        /* release lock */
        LeaveLock();
        return;
    }
    if (Fault) {
        if (!VCS_ClearFault(mHandle, NodeID, &ErrCode)) {
            mexPrintf("Error clearing fault state, ErrCode is %i\n", (int) ErrCode);
            ssSetErrorStatus(S, "Error Clearing Fault State");
            /* release lock */
            LeaveLock();
            return;
        }
    }

    /* Enabling device */
    if (!VCS_SetEnableState(mHandle, NodeID, &ErrCode)) {
        mexPrintf("Error Enabling Node, ErrCode is %i\n", (int) ErrCode);
        ssSetErrorStatus(S, "Error Enabling Device");
        /* release lock */
        LeaveLock();
        return;
    }

    /* Set Encoder to Zero for Actual Position */
    if (!VCS_ActivateHomingMode(mHandle, NodeID, &ErrCode)) {
        mexPrintf("Error activating homming, ErrCode is %i\n", (int) ErrCode);
        ssSetErrorStatus(S, "Error activating homming");
        /* release lock */
        LeaveLock();
        return;
    };
    if (!VCS_DefinePosition(mHandle, NodeID, 0, &ErrCode)) {
        mexPrintf("Error setting position to zero for node %i, ErrCode is %i\n", (int) NodeID, (int) ErrCode);
        ssSetErrorStatus(S, "Error setting zero");
        /* release lock */
        LeaveLock();
        return;
    };

    /* Changing to Op Mode */
    if (!VCS_SetOperationMode(mHandle, NodeID, OpModes[opmode], &ErrCode)) {
        mexPrintf("Error Setting Operation Mode, ErrCode is %i\n", (int) ErrCode);
        ssSetErrorStatus(S, "Error Setting Operation Mode");
        /* release lock */
        LeaveLock();
        return;
    }

    /* Update Instance */
    NumberOfInstances++;

    /* release lock */
    LeaveLock();
}

#endif /*  MDL_START */

#define MDL_UPDATE
#if defined(MDL_UPDATE)

static void mdlUpdate(SimStruct *S, int_T tid) {
    /* Read Encoder Position */
    WORD NodeID;
    DWORD ErrCode;
    short current;
    LONG posvel;

    /* Accesing inputs and outputs */
    const real_T *u = (const real_T *) ssGetInputPortSignal(S, 0);

    /* Get Node ID */
    NodeID = (WORD) ssGetIWorkValue(S, 0);

    EnterLock();
    switch (ssGetIWorkValue(S, 1)) {
        case 0:
            current = (short) u[0];
            if (current > 2000) current = 2000;
            if (current < -2000) current = -2000;
            VCS_SetCurrentMust(mHandle, NodeID, current, &ErrCode);
            break;

        case 1:
            posvel = (long) u[0];
            VCS_SetVelocityMust(mHandle, NodeID, posvel, &ErrCode);
            break;

        case 2:
            posvel = (long) u[0];
            VCS_SetPositionMust(mHandle, NodeID, posvel, &ErrCode);
            break;
    }
    LeaveLock();
}

#endif /* MDL_UPDATE */

/* Function: mdlOutputs =======================================================
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block.
 */
static void mdlOutputs(SimStruct *S, int_T tid) {
    /* Read Encoder Position */
    WORD NodeID;
    DWORD ErrCode;
    LONG Position;
    /* Accesing inputs and outputs */
    real_T *y = ssGetOutputPortSignal(S, 0);

    /* Get Node ID */
    NodeID = (WORD) ssGetIWorkValue(S, 0);

    /* Obtaining actual position */
    EnterLock();
    VCS_GetPositionIs(mHandle, NodeID, &Position, &ErrCode);
    LeaveLock();

    /* output */
    y[0] = (real_T) Position;
}

/* Function: mdlTerminate =====================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.  For example, if memory was
 *    allocated in mdlStart, this is the place to free it.
 */
static void mdlTerminate(SimStruct *S) {
    WORD NodeID;
    DWORD ErrCode;

    /* Get Data */
    NodeID = (WORD) ssGetIWorkValue(S, 0);

    EnterLock();

    /* Disable device */
    VCS_SetDisableState(mHandle, NodeID, &ErrCode);

    /* update instances */
    if (--NumberOfInstances <= 0) {
        /* Close Device */
        VCS_CloseDevice(mHandle, &ErrCode);
        mHandle = NULL;
    }

    LeaveLock();
}

/*======================================================*
 * See sfuntmpl_doc.c for the optional S-function methods *
 *======================================================*/

/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else

#include "cg_sfun.h"       /* Code generation registration function */

#endif
