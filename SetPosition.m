function res = SetPosition(handle, nodeid, pulses)
% This function set the desired position setpoint for a EPOS 2 node
% It is only work in Position Mode, which can be set with,
%
%   >> SetOperationMode(handle, nodeid, 4);
%
% Call it as,
%
% res = SetPosition(handle, nodeid, pulses); 
%
% Where:
%
% res is a boolean value: 0 for normal operation, 1 for error 
%
% handle is the number returned by OpenCommunication
%
% nodeid is the ID for EPOS 2 controller
%
% pulses is the desired motor position in quadrature encoder pulses
%
% Copyright E. Yime, 2015.
% Colombia
%