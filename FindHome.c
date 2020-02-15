/* This a library for communication with Maxon Motors EPOS2 motor controllers
 * using MATLAB.
 *
 * Copyright, Eugenio Yime Rodr�guez, 2015
 *  
 */

#include "mex.h"
#include "Definitions.h"

#ifdef _LINUX_
#include "Win2Linux.h"
#endif

void
mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    DWORD  ErrCode  = 0;
    BOOL   Fault = FALSE;
    HANDLE mHandle;
    WORD   NodeID;
    long   lHandle;
    BYTE   modes[6];
    int    type;
    char   ErrorInfo[255];
    
    modes[0] = HM_ACTUAL_POSITION;
    modes[1] = HM_HOME_SWITCH_NEGATIVE_SPEED;
    modes[2] = HM_HOME_SWITCH_NEGATIVE_SPEED_AND_INDEX;
    modes[3] = HM_HOME_SWITCH_POSITIVE_SPEED;
    modes[4] = HM_HOME_SWITCH_POSITIVE_SPEED_AND_INDEX;
    modes[5] = HM_CURRENT_THRESHOLD_NEGATIVE_SPEED;
    modes[6] = HM_CURRENT_THRESHOLD_NEGATIVE_SPEED_AND_INDEX;
    modes[7] = HM_CURRENT_THRESHOLD_POSITIVE_SPEED;
    modes[8] = HM_CURRENT_THRESHOLD_POSITIVE_SPEED_AND_INDEX;

    /* Examine input (right-hand-side) arguments. */
    if (nrhs != 3) {
        mexPrintf("Error: this function should be use with three input arguments\n");
        return;
    }
    /* Check first input, handle */
    if (mxGetM(prhs[0]) != 1 || mxGetM(prhs[0]) != 1 ) {
       mexPrintf("Error: this function requires three input scalar\n");
       return;
    }
    /* Check second input, nodeID */
    if (mxGetM(prhs[1]) != 1 || mxGetM(prhs[1]) != 1 ) {
       mexPrintf("Error: this function requires three input scalar\n");
       return;
    }
    /* Check third input, home method */
    if (mxGetM(prhs[2]) != 1 || mxGetM(prhs[2]) != 1 ) {
       mexPrintf("Error: this function requires three input scalar\n");
       return;
    }

    /* Examine output (left-hand-side) arguments. */
    if (nlhs > 1) {
        mexPrintf("Error: this function should be use with only one output argument\n");
        return;
    }
    
    /* create output matrix */
    plhs[0] = mxCreateDoubleScalar(0.0);

    /* first input */
    lHandle = (long) *mxGetPr(prhs[0]);
    mHandle = LongToHandle(lHandle);
    /* second input */
    NodeID = (WORD) *mxGetPr(prhs[1]);
    /* third input */
    type = (BYTE) *mxGetPr(prhs[2]);
    
    /* Check for a valid home method */
    if ( (type < 1) || (type > 9) ) {
       mexPrintf("Error: this function requires a home method between 1 and 9 \n");
       return;
    }
    
    /* decrement type */
    type--;
    
    /* Do a Home Method */
    if (!VCS_FindHome(mHandle, NodeID, modes[type], &ErrCode)) {
        VCS_GetErrorInfo(ErrCode, ErrorInfo, 255);
        mexPrintf("Error: %s \n", ErrorInfo);
        *mxGetPr(plhs[0]) = 1;
    }
}
