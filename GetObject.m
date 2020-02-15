function res = GetObject(handle, nodeID, Index, SubIndex, BytesToRead)
% This function change the value of a object in the Epos4 object dictionary
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
% nodeid is the ID for EPOS 4 controller
%
% Index is the object index in the epos4 dictionary
%
% SubIndex is the is object subindex in the epos4 dictionary
%
% BytesToRead is the size of the object to read
%
% Copyright E. Yime, 2015.
% Colombia
%