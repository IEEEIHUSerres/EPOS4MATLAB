function res = SetObject(handle, nodeID, Index, SubIndex, Data, BytesToWrite)
% This function change the value of a object in the Epos4 object dictionary
%
% Call it as,
%
% >> res = SetObject(Handle, NodeID, Index, SubIndex, Data, BytesToWrite);
%
% Where:
%
% res is a boolean value: 0 for normal operation, 1 for error 
%
% handle is the number returned by OpenCommunication
%
% nodeid is the ID for EPOS 4 controller
%
% Index is the object index in the epos4 dictionary
%
% SubIndex is the is object subindex in the epos4 dictionary
%
% Data is the value to write
%
% BytesToWrite is the size of the Data variable
%
% Copyright E. Yime, 2015.
% Colombia
%