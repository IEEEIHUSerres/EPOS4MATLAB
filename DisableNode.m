function res = DisableNode(handle, nodeid)
% This function disable the node, so the motor will be unpowered and 
% uncontrolled.
%
% Call it as,
%
% res = DisableNode(handle, nodeid)
%
% Where:
%
% res is a number, 0 (zero) if it works, a negative number if not
%
% handle is the handle returned by OpenCommunication
%
% nodeid is the EPOS 4 node ID
% 
% Copyright E. Yime, 2015.
% Colombia
%
