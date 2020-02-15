/* This a library for communication with Maxon EPOS4 motor controllers
 * using MATLAB.
 *
 * Copyright, Eugenio Yime Rodriguez, 2015
 *  
 */

#include "mex.h"
#include "Definitions.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _LINUX_
#include "Win2Linux.h"
#endif

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    HANDLE mHandle;
    DWORD ErrCode = 0;
    long lHandle;
    char ErrorInfo[255];

    char deviceName[] = "EPOS4";
    char protocolStackName[] = "MAXON SERIAL V2";
    char interfaceName[] = "USB";
    char portNamePrefix[] = "USB";

    /* Examine input (right-hand-side) arguments. */
    if (nrhs > 1) {
        mexPrintf("Error: this function should be use with only one input argument\n");
        return;
    }

    /* Examine output (left-hand-side) arguments. */
    if (nlhs > 1) {
        mexPrintf("Error: this function should be use with only one output argument\n");
        return;
    }

    /* first input */
    long portNameNumber = (long) *mxGetPr(prhs[0]);

    int portNameSuffixLength = snprintf(NULL, 0, "%ld", portNameNumber);

    char *portNameSuffix = malloc(portNameSuffixLength + 1);
    snprintf(portNameSuffix, portNameSuffixLength + 1, "%ld", portNameNumber);

    char portName[sizeof(portNamePrefix) + sizeof(portNameSuffix)];

    strcpy(portName, portNamePrefix);
    strcat(portName, portNameSuffix);

    /* Opening Device */
    mHandle = VCS_OpenDevice(deviceName, protocolStackName, interfaceName, portName, &ErrCode);
    if (ErrCode) {
        VCS_GetErrorInfo(ErrCode, ErrorInfo, 255);
        mexPrintf("Error: %s \n", ErrorInfo);
        /* create output matrix */
        plhs[0] = mxCreateDoubleScalar((double) -1);
    } else {
        lHandle = HandleToLong(mHandle);
        /* create output matrix */
        plhs[0] = mxCreateDoubleScalar((double) lHandle);
    }
}
