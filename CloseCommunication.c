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
    BOOL   Output = FALSE;
    HANDLE mHandle;
    WORD   NodeID;
    long   lHandle;
    char   ErrorInfo[255];

    /* Examine input (right-hand-side) arguments. */
    if (nrhs != 1) {
        mexPrintf("Error: this function should be use with one input arguments\n");
        return;
    }
    /* Check first input */
    if (mxGetM(prhs[0]) != 1 || mxGetM(prhs[0]) != 1 ) {
       mexPrintf("Error: this function requires one input scalar\n");
       return;
    }

    /* create output matrix */
    plhs[0] = mxCreateDoubleScalar(0.0);

    /* first input */
    lHandle = (long) *mxGetPr(prhs[0]);
    mHandle = LongToHandle(lHandle);
    
    /* Close Device */
    Output = VCS_CloseDevice(mHandle, &ErrCode);
    if (ErrCode) {
        VCS_GetErrorInfo(ErrCode, ErrorInfo, 255);
        mexPrintf("Error: %s \n", ErrorInfo);
        *mxGetPr(plhs[0]) = 1;
    }
}
