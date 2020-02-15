function res = SetVelocity(handle, nodeid, velocity)
% This function set the desired velocity setpoint for a EPOS 4 node
% It is only work in Velocity Mode, which can be set with,
%
%   >> SetOperationMode(handle, nodeid, 3);
%
% Call it as,
%
% res = SetVelocity(handle, nodeid, velocity); 
%
% Where:
%
% res is a boolean value: 0 for normal operation, 1 for error 
%
% handle is the number returned by OpenCommunication
%
% nodeid is the ID for EPOS 4 controller
%
% velocity is the desired motor velocity in rpm 
%
% Copyright E. Yime, 2015.
% Colombia
%