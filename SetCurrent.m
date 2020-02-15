function res = SetCurrent(handle, nodeid, value)
% This function set the desired current setpoint for a EPOS 4 node
% It is only work in Currrent Mode, which can be set with,
%
%   >> SetOperationMode(handle, nodeid, 2);
%
% Call it as,
%
% res = SetCurrent(handle, nodeid, value); 
%
% Where:
%
% res is a boolean value: 0 for normal operation, 1 for error 
%
% handle is the number returned by OpenCommunication
%
% nodeid is the ID for EPOS 4 controller
%
% value is the desired current in mA, with a maximun number of 2000
%
% Copyright E. Yime, 2015.
% Colombia
%