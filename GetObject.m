function res = GetObject(handle, nodeID, Index, SubIndex, BytesToRead)
% This function change the value of a object in the Epos2 object dictionary
%
% Call it as,
%
% >> res = GetObject(handle, nodeID, Index, SubIndex, BytesToRead);
%
% Where:
%
% res is the value of the object 
%
% handle is the number returned by OpenCommunication
%
% nodeid is the ID for EPOS 2 controller
%
% Index is the object index in the epos2 dictionary
%
% SubIndex is the is object subindex in the epos2 dictionary
%
% BytesToRead is the size of the object to read
%
% Copyright E. Yime, 2015.
% Colombia
%