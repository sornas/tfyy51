function [] = config_IOs()
%cCONFIG_IOS Configurates the input and output digital channels
%   
%   Starts tasks for 5 digital channels, 3 output and 2 input channels.
%   There is one channel per task.
%
%   These channels corresponds to:
%    
%   Output channels:
%   SCLK - Serial Clock Input.
%   CS_INV - Active-Low Chip Select. Data will not be clocked into DIN
%            unless CS is low. When CS is high, DOUT is high impedance.
%   DIN - Digital Serial Input. Data is clocked in at the rising edge of
%         SCLK.
%
%   Input channels:
%   SSTRB - Serial Strobe Output. In internal clock mode, SSTRB goes low
%           when the MAX186/MAX188 begin the A/D conversion and goes high
%           when the conversion is done. In external clock mode, SSTRB
%           pulses high for one clock period before the MSB decision. High
%           impedance when CS is high (external mode).
%   DOUT - Serial Data Output. Data is clocked out at the falling edge of
%          SCLK. High impedance when CS is high.
% 
%   These channels corresponds to pin 19 - 15 on the ADC MAXIM MAX186 chip.
%
%   Tobias Lindell - 2013-02-12

global mytaskh
global lib

DAQmx_Val_ChanPerLine =0; % One Channel For Each Line
DAQmx_Val_ChanForAllLines =1; %#ok<NASGU> % One Channel For All Lines

if isempty(lib)
    lib = 'myni';	% library alias
    if ~libisloaded(lib)
        disp('Matlab: Load nicaiu.dll')
        funclist = loadlibrary('c:\windows\system32\nicaiu.dll','C:\Program Files (x86)\National Instruments\Shared\ExternalCompilerSupport\C\include\nidaqmx.h','alias',lib); %#ok<NASGU>
        %if you do NOT have nicaiu.dll and nidaqmx.h
        %in your Matlab path,add full pathnames or copy the files.
        %libfunctions(lib,'-full') % use this to show the...
        %libfunctionsview(lib)     % included function
        disp('Matlab: Nicaiu.dll loaded!')
    end
end

% DOlines = {'Dev1/port0/line0','Dev1/port0/line1','Dev1/port0/line2'};
lineGrouping = DAQmx_Val_ChanPerLine; % One Channel For Each Line
mytaskh.DO_SCLK = DAQmxCreateDOChan(lib,'Dev1/port0/line0',lineGrouping);
mytaskh.DO_CS_INV = DAQmxCreateDOChan(lib,'Dev1/port0/line1',lineGrouping);
mytaskh.DO_DIN = DAQmxCreateDOChan(lib,'Dev1/port0/line2',lineGrouping);

% DIlines = {'Dev1/port0/line3','Dev1/port0/line4'};
mytaskh.DI_SSTRB = DAQmxCreateDIChan(lib,'Dev1/port0/line3',lineGrouping);
mytaskh.DI_DOUT = DAQmxCreateDIChan(lib,'Dev1/port0/line4',lineGrouping);

end

function taskh = DAQmxCreateDIChan(lib,lines,lineGrouping)
% function taskh = DAQmxCreateDIChan(lib,lines,lineGrouping)
% 
% this function creates a task and adds digital output line(s) to the task
% 
% inputs:
%	lib - .dll or alias (ex. 'myni')
%	lines - line(s) to add to task
%		1 line example: 'Dev1/port0/line0'
%		2 lines example: {'Dev1/port0/line0','Dev1/port0/line1'}
%			passing as .../line0-1 probably also works, but I didn't test
%	lineGrouping - either DAQmx_Val_ChanPerLine or DAQmx_Val_ChanForAllLines
% 
% 
% C functions used:
%	int32 DAQmxCreateTask (const char taskName[],TaskHandle *taskHandle);
%	int32 DAQmxCreateDIChan (TaskHandle taskHandle,const char lines[],const char nameToAssignToLines[],int32 lineGrouping);
%	int32 DAQmxTaskControl (TaskHandle taskHandle,int32 action);
% 
% written by Tobias Lindell
% inspired by Nathan Tomlin (nathan.a.tomlin@gmail.com)
% v0 - 1302


% create task
taskh = [];
name_task = '';	% recommended to avoid problems
[err,~,taskh] = calllib(lib,'DAQmxCreateTask',name_task,uint32(taskh));
DAQmxCheckError(lib,err);

% 	% check whether done
% 	[err,b,istaskdone] = calllib(lib,'DAQmxIsTaskDone',(taskh),0);
%  	DAQmxCheckError(lib,err);

% create DI channel(s) and add to task
% numchan = numel(lines);
name_line = '';	% recommended to avoid problems
if ~iscell(lines)	% just 1 channel
	[err,~,~,~] = calllib(lib,'DAQmxCreateDIChan',taskh,lines,name_line,lineGrouping);
	DAQmxCheckError(lib,err);
else % more than 1 channel to add to task
	for m = 1:numel(lines)	% loop to add channels
		[err,~,~,~] = calllib(lib,'DAQmxCreateDIChan',taskh,lines{m},name_line,lineGrouping);
		DAQmxCheckError(lib,err);
	end
end

% verify everything OK
DAQmx_Val_Task_Verify =2; % Verify
[err,~] = calllib(lib,'DAQmxTaskControl',taskh,DAQmx_Val_Task_Verify);
DAQmxCheckError(lib,err);
end

function taskh = DAQmxCreateDOChan(lib,lines,lineGrouping)
% function taskh = DAQmxCreateDOChan(lib,lines,lineGrouping)
% 
% this function creates a task and adds digital output line(s) to the task
% 
% inputs:
%	lib - .dll or alias (ex. 'myni')
%	lines - line(s) to add to task
%		1 line example: 'Dev1/port0/line0'
%		2 lines example: {'Dev1/port0/line0','Dev1/port0/line1'}
%			passing as .../line0-1 probably also works, but I didn't test
%	lineGrouping - either DAQmx_Val_ChanPerLine or DAQmx_Val_ChanForAllLines
% 
% 
% C functions used:
%	int32 DAQmxCreateTask (const char taskName[],TaskHandle *taskHandle);
%	int32 DAQmxCreateDOChan (TaskHandle taskHandle,const char lines[],const char nameToAssignToLines[],int32 lineGrouping);
%	int32 DAQmxTaskControl (TaskHandle taskHandle,int32 action);
% 
% written by Tobias Lindell
% inspired by Nathan Tomlin (nathan.a.tomlin@gmail.com)
% v0 - 1302


% create task
taskh = [];
name_task = '';	% recommended to avoid problems
[err,~,taskh] = calllib(lib,'DAQmxCreateTask',name_task,uint32(taskh));
DAQmxCheckError(lib,err);

% 	% check whether done
% 	[err,b,istaskdone] = calllib(lib,'DAQmxIsTaskDone',(taskh),0);
%  	DAQmxCheckError(lib,err);

% create DO channel(s) and add to task
name_line = '';	% recommended to avoid problems
if ~iscell(lines)
	[err,~,~,~] = calllib(lib,'DAQmxCreateDOChan',taskh,lines,name_line,lineGrouping);
	DAQmxCheckError(lib,err);
else % more than 1 channel to add to task
	for m = 1:numel(lines)
		[err,~,~,~] = calllib(lib,'DAQmxCreateDOChan',taskh,lines{m},name_line,lineGrouping);
		DAQmxCheckError(lib,err);
	end
end

% verify everything OK
DAQmx_Val_Task_Verify = 2; % Verify
[err,~] = calllib(lib,'DAQmxTaskControl',taskh,DAQmx_Val_Task_Verify);
DAQmxCheckError(lib,err);
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