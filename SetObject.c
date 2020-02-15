/* This a library for communication with Maxon EPOS4 motor controllers
 * using MATLAB.
 *
 * Copyright, Eugenio Yime Rodriguez, 2015
 *  
 */

#include "mex.h"
#include "Definitions.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    DWORD ErrCode = 0;
    BOOL Fault = FALSE;
    HANDLE mHandle;
    WORD NodeID;
    WORD Index;
    BYTE SubIndex;
    long Data = 0;
    DWORD BytesToWrite;
    DWORD BytesWritten;
    long lHandle;
    int i;
    char ErrorInfo[255];

    /* Examine input (right-hand-side) arguments. */
    if (nrhs != 6) {
        mexPrintf("Error: this function should be use with six input arguments\n");
        return;
    }

    /* Check all six input */
    for (i = 0; i < 6; i++) {
        if ((mxGetM(prhs[i]) != 1) || (mxGetM(prhs[i]) != 1)) {
            mexPrintf("Error: this function requires six input scalar\n");
            return;
        }
    };

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
    NodeID = (WORD) * mxGetPr(prhs[1]);
    /* third input */
    Index = (WORD) * mxGetPr(prhs[2]);
    /* fourth input */
    SubIndex = (BYTE) * mxGetPr(prhs[3]);
    /* fifth input */
    Data = (long) *mxGetPr(prhs[4]);
    /* sixth input */
    BytesToWrite = (DWORD) * mxGetPr(prhs[5]);

    /* check byte to write */
    if ((BytesToWrite < 1) || (BytesToWrite > 8)) {
        mexPrintf("Invalid bytes to write\n");
        *mxGetPr(plhs[0]) = 1;
        return;
    };

    /* Opening Device */
    if (!VCS_SetObject(mHandle, NodeID, Index, SubIndex, (void *) &Data, BytesToWrite, &BytesWritten, &ErrCode)) {
        VCS_GetErrorInfo(ErrCode, ErrorInfo, 255);
        mexPrintf("Error: %s \n", ErrorInfo);
        *mxGetPr(plhs[0]) = 1;
    } else {
        if (BytesToWrite != BytesWritten) {
            mexPrintf("SetObject: communication error\n");
            *mxGetPr(plhs[0]) = 1;
        };
    };
}
