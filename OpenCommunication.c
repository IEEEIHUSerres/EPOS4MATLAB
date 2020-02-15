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
    HANDLE mHandle;
    DWORD  ErrCode  = 0;
    long   lHandle;
    char   ErrorInfo[255];
    
    /* Examine input (right-hand-side) arguments. */
    if (nrhs > 0) {
        mexPrintf("Error: this function should be use with no input arguments\n");
        return;
    }
    
    /* Examine output (left-hand-side) arguments. */
    if (nlhs > 1) {
        mexPrintf("Error: this function should be use with only one output argument\n");
        return;
    }
    
    /* Opening Device */
    mHandle = VCS_OpenDevice("EPOS2", "MAXON SERIAL V2", "USB", "USB0", &ErrCode);
    if (ErrCode) {
        VCS_GetErrorInfo(ErrCode, ErrorInfo, 255);
        mexPrintf("Error: %s \n", ErrorInfo);
        /* create output matrix */
        plhs[0] = mxCreateDoubleScalar((double) -1);
    } else {
        lHandle = HandleToLong( mHandle );
        /* create output matrix */
        plhs[0] = mxCreateDoubleScalar((double) lHandle);
    }
}
