function res = EnableNode(handle, nodeid)
% This function enable a EPOS 2 node, so the motor will be powered and 
% controlled.
%
% Call it as,
%
% res = EnableNode(handle, nodeid)
%
% Where:
%
% res is a number, 0 (zero) if it works, a negative number if not
%
% handle is the handle returned by OpenCommunication
% 
% nodeid is the EPOS 2 ID
%
% Copyright E. Yime, 2015.
% Colombia
%
