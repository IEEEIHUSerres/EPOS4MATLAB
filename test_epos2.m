% test of EPOS2 class

% create motor
Motor1 = Epos2(1);

% Check error
if (Motor1.IsInErrorState)
    Motor1.ClearErrorState;
end

% enable motor
Motor1.EnableNode;

% Change to Home Mode
Motor1.SetOperationMode( OperationModes.HommingMode );

% Home to actual position
Motor1.SetHommingMethod( HommingMethods.ActualPosition );

% Perform Home
Motor1.DoHomming;

% Change to Profile Position
Motor1.SetOperationMode( OperationModes.ProfilePositionMode );

% Move to 132000 pulses, with 3000 rpm in velocity and 4000 rpm/s in acc
Motor1.MotionInPosition( 132000, 3000, 4000 );

% Wait a maximum of 10 seconds until motion done
Motor1.WaitUntilDone( 10000 );

% Display actual position
msg = sprintf('Actual Motor Position is: %i', Motor1.ActualPosition );
disp( msg );

% Ok
disp('All done ... bye');

% destroy motor
delete(Motor1)

% clear variable
clear Motor1
