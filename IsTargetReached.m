function res = IsTargetReached(handle, nodeid)
% This function return a boolean if the EPOS has finished the actual task
%
% Call it as,
%
% res = IsTargetReached(handle, nodeid); 
%
% Where:
%
% res is a boolean: 1 for motion performed, 0 for still in motion
%
% handle is the number returned by OpenCommunication
%
% nodeid is the ID for EPOS 4 controller
%
% Copyright E. Yime, 2015.
% Colombia
%