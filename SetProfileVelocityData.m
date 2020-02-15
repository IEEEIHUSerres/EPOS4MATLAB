function res = SetProfileVelocityData(handle, nodeid, acc)
% This function set the desired velocity setpoint for a EPOS 2 node
% It is only work in Profile Velocity Mode, which can be set with,
%
%   >> SetOperationMode(handle, nodeid, 5);
%
% Call it as,
%
% res = SetProfileVelocityData(handle, nodeid, acc); 
%
% Where:
%
% res is a boolean value: 0 for normal operation, 1 for error 
%
% handle is the number returned by OpenCommunication
%
% nodeid is the ID for EPOS 2 controller
%
% acc is the profile position acceleration and desacceleration in rpm / s
%
% Copyright E. Yime, 2015.
% Colombia
%