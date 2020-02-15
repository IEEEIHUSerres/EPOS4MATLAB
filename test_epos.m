clc
close all
clear al

% test of epos
a = OpenCommunication;

% Check Error
if ( GetErrorState(a, 2) )
    ClearErrorState(a, 2);
end

% Enable Motor
EnableNode(a, 2);

% Change to Home Mode
SetOperationMode(a, 2, 1);

% Home to actual position
FindHome(a, 2, 1);

% Change to Profile Position
SetOperationMode(a, 2, 6);

% Move to 132000 pulses, with 3000 rpm in velocity and 4000 rpm/s in acc
SetProfilePositionData(a, 2, 3000, 4000 );
MoveToPosition(a, 2, 132000, 1);

% Wait a maximum of 10 seconds until motion done
WaitForTargetReached( a, 2, 20000 );

% Display actual position
msg = sprintf('Actual Motor Position is: %i', GetPosition(a, 2) );
disp( msg );

% Ok
disp('All done ... bye');

% Exit
DisableNode(a, 2);
CloseCommunication(a);
