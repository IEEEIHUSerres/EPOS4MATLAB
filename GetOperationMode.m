function res = GetOperationMode(handle, nodeid)
% This function get the actual op mode for a EPOS 2 node
%
% Call it as,
%
% res = GetOperationMode(handle, nodeid); 
%
% Where:
%
% res is the actual operational mode for EPOS  2 controller
%     it is 1 if opmode is set to Homming
%     it is 2 if opmode is set to Current
%     it is 3 if opmode is set to Velocity
%     it is 4 if opmode is set to Position
%     it is 5 if opmode is set to Profile Velocity
%     it is 6 if opmode is set to Profile Position
%
% handle is the number returned by OpenCommunication
%
% nodeid is the ID for EPOS 2 controller
%
% Copyright E. Yime, 2015.
% Colombia
%