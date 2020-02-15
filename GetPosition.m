function res = GetPosition(handle, nodeid)
% This function get the actual position in quadrature encoder pulses for a EPOS 2 node
%
% Call it as,
%
% res = GetPosition(handle, nodeid); 
%
% Where:
%
% res is the actual position in quadrature encoder pulses
%
% handle is the number returned by OpenCommunication
%
% nodeid is the ID for EPOS 2 controller
%
% Copyright E. Yime, 2015.
% Colombia
%