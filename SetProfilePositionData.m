function res = SetProfilePositionData(handle, nodeid, vel, acc)
% This function set the desired velocity setpoint for a EPOS 2 node
% It is only work in Profile Position Mode, which can be set with,
%
%   >> SetOperationMode(handle, nodeid, 6);
%
% Call it as,
%
% res = SetProfilePositionData(handle, nodeid, vel, acc); 
%
% Where:
%
% res is a boolean value: 0 for normal operation, 1 for error 
%
% handle is the number returned by OpenCommunication
%
% nodeid is the ID for EPOS 2 controller
%
% vel is the profile position maximun velocity in rpm 
%
% acc is the profile position maximun acceleration and desacceleration in
%     rpm / s
%
% Copyright E. Yime, 2015.
% Colombia
%