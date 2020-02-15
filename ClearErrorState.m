function res = ClearErrorState(handle, nodeid)
% This function clears the error state for epos4 with number nodeid
%
% Call it as,
%
% res = ClearErrorState(handle, nodeid)
%
% Where:
%
% res is a number, 0 (zero) if it works, a negative number if not
%
% handle is the handle returned by OpenCommunication
%
% nodeid is the id number for EPOS 4 controller
% 
% Copyright E. Yime, 2015.
% Colombia
%