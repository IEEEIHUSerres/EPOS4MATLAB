function res = MoveToPosition(handle, nodeid, position, type)
% This function move the motor attached to a EPOS 4 which is in
% Profile Position Mode.
%
% Profile Position Mode is set with,
%
%  >> SetProfilePosition(handle, nodeid, 6)
%
% And configured with,
% 
% >> SetProfilePositionData(handle, nodeid, velocity, acceleration)
%
% Call this function in the following way,
%
% res = MoveToPosition(handle, nodeid, qc, type); 
%
% Where:
%
% res is a boolean: 0 for no error, 1 for error
%
% handle is the number returned by OpenCommunication
%
% nodeid is the ID for EPOS 4 controller
%
% qc is the desired position in quadrature encoder pulses
%
% type is the desired position in absolute or relative coordinates
%      1  -> absolute position or motion from absolute home position
%      0  -> relative position or motion from actual position
%
% Copyright E. Yime, 2015.
% Colombia
%