function waitfortreal(tsim)
% This function is intended to synchronize the Simulink clock with real time.  
% When called with t = 0, the beginning time is established.  Subsequent calls, with 
% tsim > 0, enter a busy wait state until the real-time clock catches up to tsim.
% It is assumed that the Simulink clock, tsim, is faster than real time.  

%
%	Stan Quinn December 1996
%   Copyright (c) 1995-97 by The MathWorks, Inc.
% $Revision: 1.1 $
%

global waitfortrealTstart
time = clock;
if (tsim == 0)
   waitfortrealTstart = time;
else
   while etime(clock, waitfortrealTstart) < tsim
   end
end

