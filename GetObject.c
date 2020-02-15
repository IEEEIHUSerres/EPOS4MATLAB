/* This a library for communication with Maxon Motors EPOS2 motor controllers
 * using MATLAB.
 *
 * Copyright, Eugenio Yime Rodríguez, 2015
 *  
 */

#include "mex.h"
#include "Definitions.h"

void
mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    DWORD  ErrCode  = 0;
    BOOL   Fault = FALSE;
    HANDLE mHandle;
    WORD   NodeID;
    WORD   Index;
    BYTE   SubIndex;
    long   Data = 0;
    DWORD  BytesToRead;
    DWORD  BytesRead;
    long   lHandle;
    int    i;
    char   ErrorInfo[255];
    
    /* Examine input (right-hand-side) arguments. */
    if (nrhs != 5) {
        mexPrintf("Error: this function should be use with five input arguments\n");
        return;
    }

    /* Check all five input */
    for ( i = 0; i < 5; i++) {
        if ( (mxGetM(prhs[i]) != 1) || (mxGetM(prhs[i]) != 1 ) ) {
            mexPrintf("Error: this function requires five input scalar\n");
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
    NodeID = (WORD) *mxGetPr(prhs[1]);
    /* third input */
    Index = (WORD) *mxGetPr(prhs[2]);
    /* fourth input */
    SubIndex = (BYTE) *mxGetPr(prhs[3]);
    /* sixth input */
    BytesToRead = (DWORD) *mxGetPr(prhs[4]);
    
    /* check byte to write */
    if ( (BytesToRead < 1) || (BytesToRead > 8) ) {
        mexPrintf("Invalid bytes to read\n");
        *mxGetPr(plhs[0]) = 1;
        return;
    };
            
    /* Get Object value */
    if (!VCS_GetObject(mHandle, NodeID, Index, SubIndex, (void*) &Data, BytesToRead, &BytesRead, &ErrCode)) {
        VCS_GetErrorInfo(ErrCode, ErrorInfo, 255);
        mexPrintf("Error: %s \n", ErrorInfo);
        *mxGetPr(plhs[0]) = 1;
    } else {
        if (BytesToRead != BytesRead) {
            mexPrintf("SetObject: communication error\n");
            *mxGetPr(plhs[0]) = 1;        
        } else {
            *mxGetPr(plhs[0]) = Data;
        };
    };
}
