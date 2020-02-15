clc
clear

Motor1 = Epos4(0,0);

Motor1.EnableNode;
Motor1.ClearErrorState;

Motor1.MotionInPosition(0,2,20,1);
Motor1.WaitUntilDone(10000);

Motor1.MotionInPosition(30000,2,20,1);
Motor1.WaitUntilDone(10000);

Motor1.MotionInPosition(-30000,2,20,1);
Motor1.WaitUntilDone(10000);

Motor1.MotionInPosition(0,2,20,1);
Motor1.WaitUntilDone(10000);

delete(Motor1);