classdef Epos2 < handle
    % EPOS2 class, use this class for communication with Maxon Motors EPOS2
    %   motor controller
    %   
    % This class has the methods
    %
    % EPOS2 (nodeID), Constructor
    %
    % use it as: Motor1 = Epos2(1);
    % for creating a new object Motor1 wich will deal with EPOS2 Node 1.
    %
    % delete, Destructor: 
    %
    % use it as: delete(Motor1);
    % when you finish with EPOS2 node.
    %
    % ActualPosition
    % return actual encoder position. 
    % Example: 
    % qc = Motor1.ActualPosition;
    %
    % ActualVelocity
    % return actual motor velocity.
    % Example:
    % rpm = Motor1.ActualVelocity;
    %
    % ActualCurrent
    % return actual current throght motor 
    % Example:
    % i = Motor1.ActualCurrent;
    %
    % IsInErrorState
    % return 0 if not error, or 1 if error
    % Example:
    % errorstate = Motor1.IsInErrorState;
    %
    % ClearErrorState
    % clear actual error in EPOS2
    % Example:
    % if (Motor1.IsInErrorState)
    %     Motor1.ClearErrorState;
    % end
    %
    % EnableNode
    % power the motor
    % Example:
    % Motor1.EnableNode;
    %
    % DisableNode
    % Unpower the motor
    % Example:
    % Motor1.DisableNode;
    %
    % SetOperationMode
    % Change the operation mode for epos2
    % Example:
    % Motor1.SetOperationMode(OperationModes.CurrentMode);
    %  tip: use the tab key for the list of operation modes in class.
    %       >> OperationModes.<tab>
    % for further help type:
    %       >> help Epos2.SetOperationMode
    %
    % GetOperationModes
    % return the actual Operation Mode in Epos2
    % Example
    % OpMode = Motor1.GetOperationMode;
    %
    % SetHommingMethod
    % for changing the way as the motor home
    % Example
    % Motor1.SetHommingMethod( HommingMethods.ActualPosition )
    % for further help type:
    %       >> help Epos2.SetHommingMethod
    %
    % GetHommingMethod
    % for returning the actual home method
    % Example
    % Motor1.GetHommingMethod
    %
    % DoHomming
    % for performing the home procedure
    % Example
    % Motor1.DoHomming
    %    
    % MotionInPosition
    % for moving the motor in Position or Profile Position Mode
    % Example:
    % Motor1.MotionInPosition( 132000 )
    % for further help type:
    %       >> help Epos2.MotionInPosition
    %
    % MotionInVelocity
    % for moving the motor in Velocity or Profile Velocity Mode
    % Example:
    % Motor1.MotionInVelocity( 2000 )
    % for further help type:
    %       >> help Epos2.MotionInVelocity
    %
    % MotionWithCurrent
    % for moving the motor in Current Mode
    % Example:
    % Motor1.MotionWithCurrent( 2000 )
    %
    % Stop
    % for stopping the motor
    % Example:
    % Motor1.Stop
    %    
    % E. Yime, 2015
    %
    
    properties (SetAccess = immutable )
        NodeID = 0;
        Handle = 0;
    end
    
    properties (SetAccess = private )
        OpMode = 0;
        Enable = 0;
        HomeMethod = 0;
    end
    
    methods
        function res = Epos2(node)
            % constructor
            % use it as: Motor1 = Epos2(1);
            %
            % E. Yime, 2015
            %
            
            res.NodeID = node;
            res.Handle = OpenCommunication;
            res.OpMode = res.GetOperationMode;
            res.Enable = res.IsEnable;
            res.GetHommingMethod;
        end
        
        function delete(obj)
            % destructor
            % use it as: delete(Motor1)
            %
            % E. Yime, 2015
            %
            
            obj.ClearErrorState;
            obj.DisableNode;
            CloseCommunication(obj.Handle);
        end
        
        function res = GetHandle(obj)
            % This function is only for debugging purpose
            % use it as: Motor1.GetHandle
            %
            % E. Yime, 2015
            %
            
            res = obj.Handle;
        end
        
        function res = IsInErrorState(obj)
            % This function is for obtaining the error state in a Epos2
            % node
            %
            % use it as: 
            % if (Motor1.IsInErrorState) 
            %    Motor1.ClearErrorState
            %    .... 
            % end
            %
            % E. Yime, 2015
            %
            
            res = (bitand(obj.GetStatusWord, 8) == 8);
        end
        
        function res = ExplainErrors(obj)
            % This function is for listing the actual errors in a Epos2
            % node
            %
            % use it as: 
            % >> Motor1.ExplainErrors;
            %
            % E. Yime, 2015
            %
            
            Errors = {
                0, 'No Error'; ...
                4096, 'Generic Error'; ...
                8976, 'Overcurrent Error';
                12816, 'Overvoltage Error'; ...
                12832, 'Undervoltage Error'; ...
                16912, 'Overtemperature Error'; ...
                20755, 'Logic Supply Voltage Too Low Error'; ...
                20756, 'Supply Voltage Output Stage Too Low Error'; ...
                24832, 'Internal Software Error'; ...
                25376, 'Software Parameter Error'; ...
                29472, 'Position Sensor Error'; ...
                33040, 'CAN Overrun Error (Objects lost)'; ...
                33041, 'CAN Overrun Error'; ...
                33056, 'CAN Passive Mode Error'; ...
                33072, 'CAN Life Guarding Error or Heartbeat Error'; ...
                33104, 'CAN Transmit COB-ID Collision Error'; ...
                33277, 'CAN Bus Off Error'; ...
                33278, 'CAN Rx Queue Overflow Error'; ...
                33279, 'CAN Tx Queue Overflow Error'; ...
                33296, 'CAN PDO Length Error'; ...
                34321, 'Following Error'; ...
                65281, 'Hall Sensor Error'; ...
                65282, 'Index Processing Error'; ...
                68283, 'Encoder Resolution Error'; ...
                65284, 'Hall Sensor not found Error'; ...
                65285, 'Negative Limit Switch Error'; ...
                65287, 'Positive Limit Switch Error'; ...
                65288, 'Hall Angle Detection Error'; ...
                65289, 'Software Position Limit Error'; ...
                65290, 'Position Sensor Breach Error'; ...
                65291, 'System Overloaded Error'; ...
                65292, 'Interpolated Position Mode Error'; ...
                65293, 'Auto Tuning Identification Error'; ...
                65295, 'Gear Scaling Factor Error'; ...
                65296, 'Controller Gain Error'; ...
                65297, 'Main Sensor Direction Error'; ...
                65298, 'Auxiliary Sensor Direction Error' };
            
            Index = 4099;
            number = GetObject(obj.Handle, obj.NodeID, Index, 0, 1);

            for i = 1:number
                res = GetObject(obj.Handle, obj.NodeID, Index, number, 4);
                for j = 1:size( Errors, 1)
                    if ( res == cell2mat(Errors(j,1)) )
                        disp( Errors(j, 2) );
                    end
                end
            end
            
        end
        
        function res = ClearErrorState(obj)
            % This function is for clearing the error in a node
            %
            % use it as: 
            % if (Motor1.IsInErrorState) 
            %    Motor1.ClearErrorState
            %    .... 
            % end
            %
            % E. Yime, 2015
            %
            
            res = ClearErrorState(obj.Handle, obj.NodeID);
        end
        
        function res = ShowOperationMode(obj)
            % This function is for detecting actual Operation Mode in
            % Epos2 class
            %
            % use it as:
            % >> Motor1.ShowOperationMode
            %
            % E. Yime, 2015
            %
            
            res = obj.OpMode;
        end
        
        function res = GetOperationMode(obj)
            % This function is for receiving actual Operation Mode in a
            % physical Epos2 Motor controller
            %
            % use it as:
            % >> Motor1.GetOperationMode
            %
            % E. Yime, 2015
            %
            
            a = GetObject(obj.Handle, obj.NodeID, 24672, 0, 1);
            switch a
                case 6
                    res = OperationModes.HommingMode;
                case 3
                    res = OperationModes.ProfileVelocityMode;
                case 1
                    res = OperationModes.ProfilePositionMode;
                case 255
                    res = OperationModes.PositionMode;
                case 254
                    res = OperationModes.VelocityMode;
                case 253
                    res = OperationModes.CurrentMode;
                otherwise
                    res = OperationModes.UnimplementedMode;
            end
        end
            
        function res = SetOperationMode(obj, mode, varargin)
            % This function is for setting the actual Operation Mode in a Epos2 Motor controller
            % you can use it in the following ways,
            %
            % >> Motor1.SetOperationMode( OperationModes.HommingMode )
            %
            % >> Motor1.SetOperationMode( OperationModes.ProfileVelocityMode )
            %
            % >> Motor1.SetOperationMode( OperationModes.ProfilePositionMode )
            %
            % >> Motor1.SetOperationMode( OperationModes.PositionMode )
            %
            % >> Motor1.SetOperationMode( OperationModes.VelocityMode )
            %
            % >> Motor1.SetOperationMode( OperationModes.CurrentMode )
            %
            % E. Yime, 2015
            %
            
            % Object to write
            Index = 24672;
            SubIndex = 0;
            bytes = 1;
            
            switch mode
                case OperationModes.HommingMode
                    Values = 6;
                    
                case OperationModes.ProfileVelocityMode
                    Values = 3; 
                    
                case OperationModes.ProfilePositionMode
                    Values = 1;
                    
                case OperationModes.PositionMode
                    Values = -1;
                    
                case OperationModes.VelocityMode
                    Values = -2;
                    
                case OperationModes.CurrentMode
                    Values = -3;
                    
                otherwise
                    error('invalid mode');

            end
            res = SetObject(obj.Handle, obj.NodeID, Index, SubIndex, Values, bytes);
            obj.OpMode = mode;
            
        end
        
        function res = SetHommingMethod(obj, homming, varargin)
            % This function if for performing a homming in a EPOS2 node
            % you can use it in the following ways,
            %
            % >> Motor1.SetHommingMethod( HommingMethods.ActualPosition )
            % The EPOS2 will set the actual position as the default zero
            %
            % >> Motor1.SetHommingMethod( HommingMethods.HomeSwitchNegSpeed )
            % or
            % >> Motor1.SetHommingMethod( HommingMethods.HomeSwitchNegSpeed, SpeedForZeroSearch, AccelerationForZeroSearch )
            %
            % >> Motor1.SetHommingMethod( HommingMethods.HomeSwitchNegSpeedIndex )
            % or
            % >> Motor1.SetHommingMethod( HommingMethods.HomeSwitchNegSpeedIndex, SpeedForZeroSearch, SpeedForIndexSearch, AccelerationForZeroSearch )
            %
            % >> Motor1.SetHommingMethod( HommingMethods.HomeSwitchPosSpeed )
            % or
            % >> Motor1.SetHommingMethod( HommingMethods.HomeSwitchPosSpeed, SpeedForZeroSearch, AccelerationForZeroSearch )
            %
            % >> Motor1.SetHommingMethod( HommingMethods.HomeSwitchPosSpeedIndex )
            % or
            % >> Motor1.SetHommingMethod( HommingMethods.HomeSwitchPosSpeedIndex, SpeedForZeroSearch, SpeedForIndexSearch, AccelerationForZeroSearch )
            %
            % >> Motor1.SetHommingMethod( HommingMethods.CurrentNegSpeed )
            % or
            % >> Motor1.SetHommingMethod( HommingMethods.CurrentNegSpeed, CurrentToZeroSearch )
            %
            % >> Motor1.SetHommingMethod( HommingMethods.CurrentNegSpeedIndex )
            % or
            % >> Motor1.SetHommingMethod( HommingMethods.CurrentNegSpeedIndex, CurrentToZeroSearch, SpeedForIndexSearch )            
            %
            % >> Motor1.SetHommingMethod( HommingMethods.CurrentPosSpeed )
            % or
            % >> Motor1.SetHommingMethod( HommingMethods.CurrentPosSpeed, CurrentToZeroSearch )
            %
            % >> Motor1.SetHommingMethod( HommingMethods.CurrentPosSpeedIndex )
            % or
            % >> Motor1.SetHommingMethod( HommingMethods.CurrentPosSpeedIndex, CurrentToZeroSearch, SpeedForIndexSearch )     
            %
            % E. Yime, 2015
            %
            
            % Initial values
            Index = zeros(4);
            SubIndex = zeros(4);
            Bytes = zeros(4);
            Values = zeros(4);
            
            % First object
            number = 1;
            Index(1) = 24728;
            SubIndex(1) = 0;
            Bytes(1) = 1;
            
            if (nargin > 5)
                error('No more of 4 arguments allowed ')
            end

            switch (homming)
                case HommingMethods.ActualPosition
                    Values(1) = 35;
                    if (nargin > 2)
                        error('No additional arguments allowed when homming to actual Position')
                    end
                    obj.HomeMethod = 1;
                    
                case HommingMethods.HomeSwitchNegSpeed
                    Values(1) = 27;
                    if (nargin > 4)
                        error('Only two aditional parameters allowed')
                    end
                    if (nargin > 2)
                        % Speed Zero
                        number = 2;
                        Index(2) = 24729;
                        SubIndex(2) = 1;
                        Values(2) = cell2mat(varargin(1));
                        Bytes(2) = 4;                        
                    end
                    if (nargin > 3)
                        % Accel
                        number = 3;
                        Index(3) = 24730;
                        SubIndex(3) = 0;
                        Values(3) = cell2mat(varargin(2));
                        Bytes(3) = 4;                        
                    end
                    obj.HomeMethod = 2;    
                
                case HommingMethods.HomeSwitchNegSpeedIndex
                    Values(1) = 11;
                    if (nargin > 2)
                        % Speed to Home
                        number = 2;
                        Index(2) = 24729;
                        SubIndex(2) = 1;
                        Values(2) = cell2mat(varargin(1));
                        Bytes(2) = 4;                        
                    end
                    if (nargin > 3)
                        % Speed to Index
                        number = 3;
                        Index(3) = 24729;
                        SubIndex(3) = 2;
                        Values(3) = cell2mat(varargin(2));
                        Bytes(3) = 4;                        
                    end
                    if (nargin > 4)
                        % Accel
                        number = 4;
                        Index(4) = 24730;
                        SubIndex(4) = 0;
                        Values(4) = cell2mat(varargin(3));
                        Bytes(4) = 4;                        
                    end
                    obj.HomeMethod = 3;    

                case HommingMethods.HomeSwitchPosSpeed
                    Values(1) = 23;
                    if (nargin > 4)
                        error('Only two aditional parameters allowed')
                    end
                    if (nargin > 2)
                        % Speed Zero
                        number = 2;
                        Index(2) = 24729;
                        SubIndex(2) = 1;
                        Values(2) = cell2mat(varargin(1));
                        Bytes(2) = 4;                        
                    end
                    if (nargin > 3)
                        % Accel
                        number = 3;
                        Index(3) = 24730;
                        SubIndex(3) = 0;
                        Values(3) = cell2mat(varargin(2));
                        Bytes(3) = 4;                        
                    end
                    obj.HomeMethod = 4; 
                    
                case HommingMethods.HomeSwitchPosSpeedIndex
                    Values(1) = 7;
                    if (nargin > 2)
                        % Speed to Home
                        number = 2;
                        Index(2) = 24729;
                        SubIndex(2) = 1;
                        Values(2) = cell2mat(varargin(1));
                        Bytes(2) = 4;                        
                    end
                    if (nargin > 3)
                        % Speed to Index
                        number = 3;
                        Index(3) = 24729;
                        SubIndex(3) = 2;
                        Values(3) = cell2mat(varargin(2));
                        Bytes(3) = 4;                        
                    end
                    if (nargin > 4)
                        % Accel
                        number = 4;
                        Index(4) = 24730;
                        SubIndex(4) = 0;
                        Values(4) = cell2mat(varargin(3));
                        Bytes(4) = 4;                        
                    end
                    obj.HomeMethod = 5;
                    
                case HommingMethods.CurrentNegSpeed
                    Values(1) = -4;
                    if (nargin > 3)
                        error('Only Current Threshold allowed in Current Negative Speed')
                    end
                    if (nargin > 2)
                        % current threshold 
                        number = 2;
                        Index(2) = 8320;
                        SubIndex(2) = 0;
                        Values(2) = cell2mat(varargin(1));
                        Bytes(2) = 2;
                    end                  
                    obj.HomeMethod = 6;
                    
                case HommingMethods.CurrentNegSpeedIndex
                    Values(1) = -2;
                    if (nargin > 4)
                        error('Only two additional values allowed')
                    end
                    if (nargin > 2)
                        % current threshold 
                        number = 2;
                        Index(2) = 8320;
                        SubIndex(2) = 0;
                        Values(2) = cell2mat(varargin(1));
                        Bytes(2) = 2;
                    end
                    if (nargin > 3)
                        % Speed to Index
                        number = 3;
                        Index(3) = 24729;
                        SubIndex(3) = 2;
                        Values(3) = cell2mat(varargin(2));
                        Bytes(3) = 4;                        
                    end                      
                    obj.HomeMethod = 7;
                    
                case HommingMethods.CurrentPosSpeed
                    Values(1) = -3;
                    if (nargin > 3)
                        error('Only Current Threshold allowed in Current Positive Speed')
                    end
                    if (nargin > 2)
                        % current threshold 
                        number = 2;
                        Index(2) = 8320;
                        SubIndex(2) = 0;
                        Values(2) = cell2mat(varargin(1));
                        Bytes(2) = 2;
                    end
                    obj.HomeMethod = 8; 
                    
                case HommingMethods.CurrentPosSpeedIndex
                    Values(1) = -1;
                    if (nargin > 4)
                        error('Only two additional values allowed')
                    end
                    if (nargin > 2)
                        % current threshold 
                        number = 2;
                        Index(2) = 8320;
                        SubIndex(2) = 0;
                        Values(2) = cell2mat(varargin(1));
                        Bytes(2) = 2;
                    end
                    if (nargin > 3)
                        % Speed to Index
                        number = 3;
                        Index(3) = 24729;
                        SubIndex(3) = 2;
                        Values(3) = cell2mat(varargin(2));
                        Bytes(3) = 4;                        
                    end                            
                    obj.HomeMethod = 9; 
                    
                otherwise
                    error('Not Implemente Homming Method')
                    
            end
            
            for i = 1:number
                res = SetObject(obj.Handle, obj.NodeID, Index(i), SubIndex(i), Values(i), Bytes(i));
            end
        end
        
        function res = GetHommingMethod(obj)
            % This function is for getting the actual value of the homming method in a EPOS2
            % controller 
            %
            % use it as:
            %
            % >> Motor1.GetHommingMethod
            %
            % E. Yime, 2015
            %
            
            Index = 24728;
            SubIndex = 0;
            Size = 1;
            a = GetObject(obj.Handle, obj.NodeID, Index, SubIndex, Size);
            
            switch (a)
                case 35
                    res = HommingMethods.ActualPosition;
                    obj.HomeMethod = 1;
                case 27
                    res = HommingMethods.HomeSwitchNegSpeed;
                    obj.HomeMethod = 2;
                case 23
                    res = HommingMethods.HomeSwitchPosSpeed;
                    obj.HomeMethod = 4;
                case 11
                    res = HommingMethods.HomeSwitchNegSpeedIndex;
                    obj.HomeMethod = 3;
                case 7
                    res = HommingMethods.HomeSwitchPosSpeedIndex;
                    obj.HomeMethod = 5;
                case 255
                    res = HommingMethods.CurrentPosSpeedIndex;
                    obj.HomeMethod = 7;
                case 254
                    res = HommingMethods.CurrentNegSpeedIndex;
                    obj.HomeMethod = 9;
                case 253
                    res = HommingMethods.CurrentPosSpeed;
                    obj.HomeMethod = 6;
                case 252
                    res = HommingMethods.CurrentNegSpeed;
                    obj.HomeMethod = 8;
                otherwise
                    res = HommingMethods.NotImplemented;
                    obj.HomeMethod = 0;                    
            end
        end
        
        function res = DoHomming(obj)
            % This function is for Homming a motor connected to a EPOS2
            % controller when the EPOS2 is in Homming
            %
            % use it as:
            %
            % >> Motor1.DoHomming
            %
            % E. Yime, 2015
            %
            
            if (obj.IsInErrorState)
                obj.Enable = 0;
                error('you can not do a Homming when the motors is in error state');
            end
            if ( obj.Enable == 0)
                error('you can not do a Homming with a disabled motor');
            end
            if ( obj.OpMode ~= OperationModes.HommingMode  )
                error('you can not do a Homming when the motor is not in Homming Mode');
            end
            if (obj.HomeMethod == 0)
                error('you must specify a valid Homming Method before performing a homming');
            end
            % change controlword to home the motor
            res = FindHome(obj.Handle, obj.NodeID, obj.HomeMethod);
        end
             
        function res = IsEnable(obj)
            % This function is for detecting if EPOS2 is enabled
            %
            % use it as:
            % >> Motor1.IsEnable
            %
            % E. Yime, 2015
            %
            
            res = (bitand(obj.GetStatusWord, 4) == 4);
        end
        
        function res = EnableNode(obj)
            % This function is for enabling a physical EPOS2 Motor Controller
            %
            % use it as:
            % >> Motor1.EnableNode
            %
            % E. Yime, 2015
            %
            
            if (obj.IsInErrorState)
                obj.Enable = 0;
                error('you can not Enable a Motore when it is in error state');
            end
            obj.Enable = 1;
            res = EnableNode(obj.Handle, obj.NodeID);
        end
        
        function res = DisableNode(obj)
            % This function is for disabling a physical EPOS2 Motor Controller
            %
            % use it as:
            % >> Motor1.DisableNode
            %
            % E. Yime, 2015
            %
            
            obj.Enable = 0;
            res = DisableNode(obj.Handle, obj.NodeID);
        end
        
        function res = GetStatusWord(obj)
            % This function is for getting the actual status word in a EPOS2
            % object dictionary  
            %
            % use it as:
            % >> Motor1.GetStatusWord
            %
            % E. Yime, 2015
            %
            
            res = GetObject(obj.Handle, obj.NodeID, 24641, 0, 2);
        end
        
        function res = ExplainStatusWord(obj)
            % This function is for obtaining an interpretation of the object
            % status word in the object dictionary
            %
            % use it as:
            % >> Motor1.ExplainStatusWord
            %
            % E. Yime, 2015
            %
            
            res = obj.GetStatusWord;
            if (bitand(res,1) == 1)
                disp('Node is Ready to Swith On');
            end
            if (bitand(res,2) == 2)
                disp('Node is Swithed On');
            end
            if (bitand(res,4) == 4)
                disp('Node is Operation Enable');
            end
            if (bitand(res,8) == 8)
                disp('Node is Fault State');
            end
            if (bitand(res,16) == 16)
                disp('Node is Voltage Enabled');
            end
            if (bitand(res,32) == 32)
                disp('Node is QuickStop');
            end
            if (bitand(res,64) == 64)
                disp('Node is Swtich On Disable');
            end
            if (bitand(res,128) == 128)
                disp('Node is Warning State');
            end
            if (bitand(res,1024) == 1024)
                disp('Node has reached target');
            end
        end
        
        function res = ActualPosition(obj)
            % This function is for obtaining the actual position of the EPOS2
            % node
            %
            % use it as:
            % >> Motor1.ActualPosition
            %
            % E. Yime, 2015
            %
            
            res = GetPosition(obj.Handle, obj.NodeID);
        end
        
        function res = WaitUntilDone( obj, TimeOut )
            % This function will wait until the motor reachs the target
            %
            % use it as:
            % >> Motor1.WaitUntilDone( TimeOutIn_ms );
            %
            % E. Yime, 2015
            %
            
            res = WaitForTargetReached( obj.Handle, obj.NodeID, TimeOut );
        end
        
        function res = MotionInPosition(obj, varargin)
            % This function is for moving a motor connected to a EPOS2 controller
            % when the motor is in Position or Profile Position Mode.
            %
            % use it as:
            %
            % In Position Mode or Profile Position mode 
            % >> Motor1.MotionInPosition( DesiredPosition ) 
            %
            % In Profile Position mode 
            % >> Motor1.MotionInPosition( DesiredPosition, ProfileVelocity, ProfileAcceleration, AbsoluteOrRelativePosition  ) 
            %
            % E. Yime, 2015
            %
            
            if (nargin < 2 || nargin > 5)
                error('you should call this function with four arguments');
            end
            if (obj.IsInErrorState)
                obj.Enable = 0;
                error('you can not move a motor when it is in error state');
            end
            if ( obj.Enable == 0)
                error('you can not move a disabled motor');
            end
            if ( (obj.OpMode ~= OperationModes.PositionMode) && (obj.OpMode ~= OperationModes.ProfilePositionMode) )
                error('you can not move a motor when it is not in position related mode');
            end
            
            Position = cell2mat(varargin(1));
            if (nargin > 2)
                velocity = cell2mat(varargin(2));
            else
                velocity = 8000;
            end
            if (nargin > 3)
                acceleration = cell2mat(varargin(3));
            else
                acceleration = velocity/2;
            end
            if (nargin > 4)
                Abs = cell2mat(varargin(4));
            else 
                Abs = 0;
            end
            
            if (obj.GetOperationMode == OperationModes.PositionMode)
                res = SetPosition(obj.Handle, obj.NodeID, Position);
            elseif (obj.GetOperationMode == OperationModes.ProfilePositionMode)
                if ( nargin > 2) 
                    SetProfilePositionData(obj.Handle, obj.NodeID, velocity, acceleration);
                end
                res = MoveToPosition(obj.Handle, obj.NodeID, Position, Abs);
            end
            
        end
        
        function res = ActualVelocity(obj)
            % This function is for obtaining the actual velocity of the EPOS2
            % node
            %
            % use it as:
            % >> Motor1.ActualVelocity
            %
            % E. Yime, 2015
            %
            
            res = GetVelocity(obj.Handle, obj.NodeID);
        end
        
        function res = MotionInVelocity(obj, varargin)
            % This function is for moving a motor connected to a EPOS2 controller
            % when the motor is in Velocity or Profile Velocity Mode.
            %
            % use it as:
            %
            % In Velocity Mode or Profile Velocity mode 
            % >> Motor1.MotionInVelocity( DesiredVelocity ) 
            %
            % In Profile Velocity mode 
            % >> Motor1.MotionInPosition( DesiredVelocity, ProfileAcceleration ) 
            %
            % E. Yime, 2015
            %
            
            if (nargin < 2 || nargin > 3)
                error('you should call this function with four arguments');
            end
            if (obj.IsInErrorState)
                obj.Enable = 0;
                error('you can not move a motor when it is in error state');
            end
            if ( obj.Enable == 0)
                error('you can not move a disabled motor');
            end
            if ( (obj.OpMode ~= OperationModes.VelocityMode) && (obj.OpMode ~= OperationModes.ProfileVelocityMode) )
                error('you can not move a motor when it is not in velocity related mode');
            end

            Velocity = cell2mat(varargin(1));
            if (nargin > 2)
                Acceleration = cell2mat(varargin(2));
            else
                Acceleration = 4000;
            end
            
            if (obj.GetOperationMode == OperationModes.VelocityMode)
                res = SetVelocity(obj.Handle, obj.NodeID, Velocity);
            elseif (obj.GetOperationMode == OperationModes.ProfileVelocityMode)
                if (nargin > 2) 
                    SetProfileVelocityData(obj.Handle, obj.NodeID, Acceleration);
                end
                res = MoveWithVelocity(obj.Handle, obj.NodeID, Velocity);
            end
            
        end
        
        function res = ActualCurrent(obj)
            % This function is for obtaining the actual current of the EPOS2
            % node
            %
            % use it as:
            % >> Motor1.ActualCurrent
            %
            % E. Yime, 2015
            %
            
            res = GetCurrent(obj.Handle, obj.NodeID);
        end
        
        function res = MotionWithCurrent(obj, current)
            % This function is for moving a motor connected to a EPOS2 controller
            % when the motor is in Current Mode
            %
            % use it as:
            %
            % >> Motor1.MotionWithCurrent( DesiredCurrent ) 
            %
            % E. Yime, 2015
            %
            
            if (obj.IsInErrorState)
                obj.Enable = 0;
                error('you can not move a motor when it is in error state');
            end
            if ( obj.Enable == 0)
                error('you can not move a disabled motor');
            end
            if ( obj.OpMode ~= OperationModes.CurrentMode) 
                error('you can not move the motor when it is not in current mode');
            end
            res = SetCurrent( obj.Handle, obj.NodeID, current);
        end
        
        function res = Stop(obj)
            % This function is for stopping a motor connected to a EPOS2 controller
            %
            % use it as:
            %
            % >> Motor1.Stop
            %
            % E. Yime, 2015
            %
            
            res = QuickStop(obj.Handle, obj.NodeID);
        end
               
    end
    
end
