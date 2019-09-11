function [] = initialize_counters(track)
%INITIALIZE_COUNTERS Creates counter tasks by calling the new driver NIDAQmx.
%   
%   There are one task associated with each counter. The handles of these
%   tasks are stored in global struct mytaskh. The tasks are not started 
%   by this function, the user needs to call set_car_speed and/or 
%   start_race to arm any counters.
%
%   Track 1/track 2:
%   ctr_0/ctr_4 - Pulse train signal, representing car speed.
%   ctr_1/ctr_5 - Check point counter.
%   ctr_2/ctr_6 - Lap counter.
%   ctr_3/ctr_7 - Time counter, counts at 100kHz.
% 
%   Tobias Lindell - 2013-02-12

global mytaskh
global lib

switch nargin
    case 1
        lib = 'myni';	% library alias
        if ~libisloaded(lib)
            disp('Matlab: Loading nicaiu.dll. Please wait!')
            funclist = loadlibrary('c:\windows\system32\nicaiu.dll','C:\Program Files (x86)\National Instruments\Shared\ExternalCompilerSupport\C\include\nidaqmx.h','alias',lib); %#ok<NASGU>
            %if you do NOT have nicaiu.dll and nidaqmx.h
            %in your Matlab path,add full pathnames or copy the files.
            %libfunctions(lib,'-full') % use this to show the...
            %libfunctionsview(lib)     % included function
            disp('Matlab: Nicaiu.dll loaded!')
        end
        
        disp(['Initializing track ',num2str(track),' please wait!'])
        
        %%% NIconstants
        DAQmx_Val_Hz = 10373; % Hz
        
        % DAQmx_Val_High = 10192; % High
        DAQmx_Val_Low = 10214; % Low
        
        % DAQmx_Val_FiniteSamps = 10178; % Finite Samples
        DAQmx_Val_ContSamps = 10123; % Continuous Samples
        % DAQmx_Val_HWTimedSinglePoint = 12522; % Hardware Timed Single Point
        
        DAQmx_Val_Rising = 10280; % Rising
        % DAQmx_Val_Falling = 10171; % Falling
        
        DAQmx_Val_CountUp = 10128; % Count Up
        % DAQmx_Val_CountDown = 10124; % Count Down
        % DAQmx_Val_ExtControlled = 10326; % Externally Controlled
        
        
        
        % Track 1
        switch track
            case 1
                %%% Car speed counter
                mytaskh.ctr_0 = DAQmxCreateCOPulseChanFreq(lib,'Dev1/ctr0',DAQmx_Val_Hz,DAQmx_Val_Low,2.5e-08,100,0.001);
                calllib(lib,'DAQmxCfgImplicitTiming',mytaskh.ctr_0,DAQmx_Val_ContSamps,1000);
                
                %%% Sensor counters
                
                % Check points
                % Starting count edges counter, detecting rising edges
                mytaskh.ctr_1 = DAQmxCreateCICountEdgesChan(lib,'Dev1/ctr1',DAQmx_Val_Rising,DAQmx_Val_CountUp);
                % Setting up terminal and filter
                calllib(lib,'DAQmxSetCICountEdgesTerm',mytaskh.ctr_1,'Dev1/ctr1','PFI35');
                calllib(lib,'DAQmxSetCICountEdgesDigFltrEnable',mytaskh.ctr_1,'Dev1/ctr1',1);
                calllib(lib,'DAQmxSetCICountEdgesDigFltrMinPulseWidth',mytaskh.ctr_1,'Dev1/ctr1',5e-6);
                
                % Lap counter
                mytaskh.ctr_2 = DAQmxCreateCICountEdgesChan(lib,'Dev1/ctr2',DAQmx_Val_Rising,DAQmx_Val_CountUp);
                calllib(lib,'DAQmxSetCICountEdgesTerm',mytaskh.ctr_2,'Dev1/ctr2','PFI31');
                calllib(lib,'DAQmxSetCICountEdgesDigFltrEnable',mytaskh.ctr_2,'Dev1/ctr2',1);
                calllib(lib,'DAQmxSetCICountEdgesDigFltrMinPulseWidth',mytaskh.ctr_2,'Dev1/ctr2',5e-6);
                
                %%% Timer counter
                mytaskh.ctr_3 = DAQmxCreateCICountEdgesChan(lib,'Dev1/ctr3',DAQmx_Val_Rising,DAQmx_Val_CountUp);
                calllib(lib,'DAQmxSetCICountEdgesTerm',mytaskh.ctr_3,'Dev1/ctr3','/Dev1/100kHzTimebase');
                
            case 2
                %%% Car speed counter
                mytaskh.ctr_4 = DAQmxCreateCOPulseChanFreq(lib,'Dev1/ctr4',DAQmx_Val_Hz,DAQmx_Val_Low,2.5e-08,100,0.001);
                calllib(lib,'DAQmxCfgImplicitTiming',mytaskh.ctr_4,DAQmx_Val_ContSamps,1000);
                
                %%% Sensor counters
                % Check points
                mytaskh.ctr_5 = DAQmxCreateCICountEdgesChan(lib,'Dev1/ctr5',DAQmx_Val_Rising,DAQmx_Val_CountUp);
                calllib(lib,'DAQmxSetCICountEdgesTerm',mytaskh.ctr_5,'Dev1/ctr5','PFI19');
                calllib(lib,'DAQmxSetCICountEdgesDigFltrEnable',mytaskh.ctr_5,'Dev1/ctr5',1);
                calllib(lib,'DAQmxSetCICountEdgesDigFltrMinPulseWidth',mytaskh.ctr_5,'Dev1/ctr5',5e-6);
                
                %  Lap counter
                mytaskh.ctr_6 = DAQmxCreateCICountEdgesChan(lib,'Dev1/ctr6',DAQmx_Val_Rising,DAQmx_Val_CountUp);
                calllib(lib,'DAQmxSetCICountEdgesTerm',mytaskh.ctr_6,'Dev1/ctr6','PFI15');
                calllib(lib,'DAQmxSetCICountEdgesDigFltrEnable',mytaskh.ctr_6,'Dev1/ctr6',1);
                calllib(lib,'DAQmxSetCICountEdgesDigFltrMinPulseWidth',mytaskh.ctr_6,'Dev1/ctr6',5e-6);
                
                %%% Timer counter
                mytaskh.ctr_7 = DAQmxCreateCICountEdgesChan(lib,'Dev1/ctr7',DAQmx_Val_Rising,DAQmx_Val_CountUp);
                calllib(lib,'DAQmxSetCICountEdgesTerm',mytaskh.ctr_7,'Dev1/ctr7','/Dev1/100kHzTimebase');
                
            otherwise
                disp('Wrong track number sent to initialize_counters!')
                return
        end
        disp(['Track ',num2str(track),' initialized!'])
    otherwise
        disp('Wrong number of input arguments sent to initialize_counters(track)! Should be 1!')
end
end

function DAQmxCheckError(lib,err)
% function DAQmxCheckError(lib,err)
% 
% read error code 
%	zero means no error - does nothing
%	nonzero - find out error string and generate error
% 
% inputs:
%	lib = .dll or alias (ex. 'myni')
%	err = DAQmx error
% 
% written by Tobias Lindell
% inspired by Nathan Tomlin (nathan.a.tomlin@gmail.com)
% v0 - 1302

if err ~= 0 
	% find out how long the error string is
	[numerr,~] = calllib(lib,'DAQmxGetErrorString',err,'',0);

	% get error string	
	errstr = char(1:numerr);	% have to pass dummy string of correct length
	[~,errstr] = calllib(lib,'DAQmxGetErrorString',err,errstr,numerr);

	% matlab error
	error(['DAQmx error - ',errstr])
end
end

function taskh = DAQmxCreateCICountEdgesChan(lib,ctrs,edge,direction)
% function taskh = DAQmxCreateCICountEdgesChan(lib,ctrs,edge,direction)
% 
% this function creates a task and adds counter input channel(s) to the task
% 
% inputs:
%	lib - .dll or alias (ex. 'myni')
%	ctrs - channel(s) to add to task
%		1 channel example: 'Dev1/ctr0'
%		2 channels example: {'Dev1/ctr0','Dev1/ctr1'}
%			passing as .../ctr0-1 probably also works, but I didn't test
%	edge - which edge that is detected/counted ('rising' or 'falling')
%	direction - direction to count ('increment' or 'decrement')
% 
% 
% written by Tobias Lindell
% inspired by Nathan Tomlin (nathan.a.tomlin@gmail.com)
% v0 - 1302

taskh = [];
name_task = '';	% recommended to avoid problems
[err,~,taskh] = calllib(lib,'DAQmxCreateTask',name_task,uint32(taskh));
DAQmxCheckError(lib,err);

name_line = '';	% recommended to avoid problems
[err,~,~,~] = calllib(lib,'DAQmxCreateCICountEdgesChan',taskh,ctrs,name_line,edge,0,direction);
DAQmxCheckError(lib,err);

% verify everything OK
DAQmx_Val_Task_Verify = 2; % Verify
[err,~] = calllib(lib,'DAQmxTaskControl',taskh,DAQmx_Val_Task_Verify);
DAQmxCheckError(lib,err);

end

function taskh = DAQmxCreateCOPulseChanFreq(lib,ctrs,units,idleState,initialDelay,freq,dutyCycle)
% function taskh = DAQmxCreateCOPulseChanFreq(lib,ctrs,units,idleState,initialDelay,freq,dutyCycle)
% 
% this function creates a task and adds counter input channel(s) to the task
% 
% inputs:
%	lib - .dll or alias (ex. 'myni')
%	ctrs - channel(s) to add to task
%		1 channel example: 'Dev1/ctr0'
%		2 channels example: {'Dev1/ctr0','Dev1/ctr1'}
%			passing as .../ctr0-1 probably also works, but I didn't test
%	units - The units in which to specify freq. (DAQmx_Val_Hz = hertz)
%	idleState - The resting state of the output terminal. 
%               DAQmx_Val_High - High state.
%               DAQmx_Val_Low  - Low state.
%	initialDelay - The amount of time in seconds to wait before generating the first pulse.
%	freq - The frequency at which to generate pulses.
%	dutyCycle - The width of the pulse divided by the pulse period.
% 
% 
% written by Tobias Lindell
% inspired by Nathan Tomlin (nathan.a.tomlin@gmail.com)
% v0 - 1302


taskh = [];
name_task = '';	% recommended to avoid problems
[err,~,taskh] = calllib(lib,'DAQmxCreateTask',name_task,uint32(taskh));
DAQmxCheckError(lib,err);

name_line = '';	% recommended to avoid problems
[err,~,~,~] = calllib(lib,'DAQmxCreateCOPulseChanFreq',taskh,ctrs,name_line,units,idleState,initialDelay,freq,dutyCycle);
DAQmxCheckError(lib,err);

% verify everything OK
DAQmx_Val_Task_Verify = 2; % Verify
[err,~] = calllib(lib,'DAQmxTaskControl',taskh,DAQmx_Val_Task_Verify);
DAQmxCheckError(lib,err);

end


