function res = FindHome(handle, nodeID, type)
% This function perfom the homming procedure for a Epos2 Node
%
% Call it as,
%
% >> res = FindHome(handle, nodeID, type);
%
% Where:
%
% res is the value of the object 
%
% handle is the number returned by OpenCommunication
%
% nodeid is the ID for EPOS 2 controller
%
% type is the home method, it should has one of the following values
%
% 1 -> for actual position
%
% 2 -> for home switch with negative speed
%
% 3 -> for home switch with negative speed and index
%
% 4 -> for home switch with positive speed
%
% 5 -> for home switch with positive speed and index
%
% 6 -> for home with current and negative speed
%
% 7 -> for home with current and negative speed and index
%
% 8 -> for home with current and positive speed
%
% 9 -> for home with current and positive speed and index
%
% Copyright E. Yime, 2015.
% Colombia
%