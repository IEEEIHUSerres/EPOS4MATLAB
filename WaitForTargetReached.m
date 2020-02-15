function res = WaitForTargetReached(handle, nodeid, timeout)
% This function will pause the program until the motion in performed and 
% it should be only called in Profile Position Mode.
%
% Call it as,
%
% res = WaitForTargetReached(handle, nodeid, timeout); 
%
% Where:
%
% res is a boolean value: 0 for normal operation, 1 for error 
%
% handle is the number returned by OpenCommunication
%
% nodeid is the ID for EPOS 2 controller
%
% timeout is the maximun time for waiting a task to finish
%
% Copyright E. Yime, 2015.
% Colombia
%
