function res = MoveWithVelocity(handle, nodeid, vel)
% This function move the motor attached to a EPOS 4 which is in
% Profile Velocity Mode.
%
% Profile Velocity Mode is set with,
%
%  >> SetOperationMode(handle, nodeid, 5)
%
% And configured with,
% 
% >> SetProfileVelocityData(handle, nodeid, acceleration)
%
% Call this function in the following way,
%
% res = MoveWithVelocity(handle, nodeid, rpm); 
%
% Where:
%
% res is a boolean: 0 for no error, 1 for error
%
% handle is the number returned by OpenCommunication
%
% nodeid is the ID for EPOS 4 controller
%
% rpm is the desired velocity in revolutions per seconds
%
% Copyright E. Yime, 2015.
% Colombia
%