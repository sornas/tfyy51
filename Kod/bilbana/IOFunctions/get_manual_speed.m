function [manual_speed] = get_manual_speed(track)
%GET_MANUAL_SPEED Reads input from gas handle and returns converted value.
%   Uses digital in/out functions to get and set values on the channels set
%   up by the function config_IOs.
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
%   User needs to manually clock the serial clock of the analog/digital
%   converter to read or write data.
%
%   Tobias Lindell - 2013-02-12

global mytaskh
global lib

switch nargin
    case 1
        manual_speed = [];
        
        if isempty(mytaskh)
            disp('User needs to initialize IO before getting manual car speed!')
            clearvars -global mytaskh lib
            return
        else
            if ~isfield(mytaskh,'DO_SCLK')
                disp('User needs to initialize IO before getting manual car speed!')
                return
            end
        end
        
        switch track
            case 1
                control_bit = 0;
            case 2
                control_bit = 1;
            otherwise
                disp('Wrong track number sent to get_manual_speed!')
                return
        end
        
        % Channels:
        % mytaskh.DO_SCLK
        % mytaskh.DO_CS_INV
        % mytaskh.DO_DIN
        % mytaskh.DI_SSTRB
        % mytaskh.DI_DOUT
        
        DAQmx_Val_ChanPerLine =0; %#ok<*NASGU> % One Channel For Each Line
        DAQmx_Val_ChanForAllLines =1; % One Channel For All Lines
        DAQmx_Val_GroupByChannel = 0; % Group by Channel
        DAQmx_Val_GroupByScanNumber =1; % Group by Scan Number
        
        numSampsPerChan = 1;
        timeout = 1;
        fillMode =  DAQmx_Val_GroupByChannel; % Group by Channel
        % fillMode = DAQmx_Val_GroupByScanNumber; % Group by Scan Number
        dataLayout =  DAQmx_Val_GroupByChannel; % Group by Channel
        % dataLayout = DAQmx_Val_GroupByScanNumber; % Group by Scan Number
        numchanDI = 1; % DI lines
        numsample = 1;
        

        
        % Setup outports
        DAQmxWriteDigitalLines(lib,mytaskh.DO_CS_INV,...
            numSampsPerChan,timeout,dataLayout,1);
        DAQmxWriteDigitalLines(lib,mytaskh.DO_SCLK,...
            numSampsPerChan,timeout,dataLayout,0);
        DAQmxWriteDigitalLines(lib,mytaskh.DO_DIN,...
            numSampsPerChan,timeout,dataLayout,0);
        DAQmxWriteDigitalLines(lib,mytaskh.DO_CS_INV,...
            numSampsPerChan,timeout,dataLayout,0);
        
        % Send controll byte : "100x1110", där x är kontrollbiten.
        set_ADC_bit(1);
        set_ADC_bit(0);
        set_ADC_bit(0);
        set_ADC_bit(control_bit);
        set_ADC_bit(1);
        set_ADC_bit(1);
        set_ADC_bit(1);
        set_ADC_bit(0);
        
        pause(0.005)
        
        DAQmxWriteDigitalLines(lib,mytaskh.DO_SCLK,...
            numSampsPerChan,timeout,dataLayout,1);
        
        ADC = zeros(1,12);
        for i=1:12
            ADC(13-i) = get_ADC_bit();
        end
        get_ADC_bit();
        get_ADC_bit();
        get_ADC_bit();
        get_ADC_bit();
        DAQmxWriteDigitalLines(lib,mytaskh.DO_CS_INV,...
            numSampsPerChan,timeout,dataLayout,1);
        
        x1=ADC(12)*128+ADC(11)*64+ADC(10)*32+ADC(9)*16+ADC(8)*8+ADC(7)*4+ADC(6)*2+ADC(5)*1-128;
        manual_speed = min(max(x1,0),127);
    otherwise
        disp('Wrong number of arguments sent to get_manual_speed(track)! Should be 1!');
end
end

function [] = set_ADC_bit(valueDO)
global mytaskh
global lib

DAQmx_Val_ChanPerLine =0; % One Channel For Each Line
DAQmx_Val_ChanForAllLines =1; % One Channel For All Lines
DAQmx_Val_GroupByChannel = 0; % Group by Channel
DAQmx_Val_GroupByScanNumber =1; % Group by Scan Number

numSampsPerChan = 1;
timeout = 1;
dataLayout =  DAQmx_Val_GroupByChannel; % Group by Channel
% dataLayout = DAQmx_Val_GroupByScanNumber; % Group by Scan Number

DAQmxWriteDigitalLines(lib,mytaskh.DO_DIN,...
    numSampsPerChan,timeout,dataLayout,valueDO);

DAQmxWriteDigitalLines(lib,mytaskh.DO_SCLK,...
    numSampsPerChan,timeout,dataLayout,1);
DAQmxWriteDigitalLines(lib,mytaskh.DO_SCLK,...
    numSampsPerChan,timeout,dataLayout,0);
end

function [valueDI] = get_ADC_bit()
global mytaskh
global lib

DAQmx_Val_ChanPerLine =0; % One Channel For Each Line
DAQmx_Val_ChanForAllLines =1; % One Channel For All Lines
DAQmx_Val_GroupByChannel = 0; % Group by Channel
DAQmx_Val_GroupByScanNumber =1; % Group by Scan Number

numSampsPerChan = 1;
timeout = 1;
fillMode =  DAQmx_Val_GroupByChannel; % Group by Channel
% fillMode = DAQmx_Val_GroupByScanNumber; % Group by Scan Number
dataLayout =  DAQmx_Val_GroupByChannel; % Group by Channel
% dataLayout = DAQmx_Val_GroupByScanNumber; % Group by Scan Number
numchanDI = 1; % DI lines
numsample = 1;

DAQmxWriteDigitalLines(lib,mytaskh.DO_SCLK,...
    numSampsPerChan,timeout,dataLayout,0);
DAQmxWriteDigitalLines(lib,mytaskh.DO_SCLK,...
    numSampsPerChan,timeout,dataLayout,1);
valueDI = DAQmxReadDigitalLines(lib,mytaskh.DI_DOUT,numSampsPerChan,timeout,fillMode,numchanDI,numsample);
end

function sampsPerChanWritten = DAQmxWriteDigitalLines(lib,taskh,numSampsPerChan,timeout,dataLayout,DOvalue)
% function sampsPerChanWritten = DAQmxWriteDigitalLines(lib,taskh,numSampsPerChan,timeout,dataLayout,DOvalue)
% 
% this function writes digital outputs from previously setup task
% 
% inputs:
%	lib - .dll or alias (ex. 'myni')
%	taskh - taskhandle of analog inputs
%	numSampsPerChan = ?
%	timeout - in seconds
%	dataLayout - DAQmx_Val_GroupByChannel or DAQmx_Val_GroupByScanNumber
%	DOvalue - value to write (0 or 1)
%		1 channel example: 0
%		2 channel example: [0,0]
% 
% C functions:
% int32 DAQmxReadDigitalLines (
%		TaskHandle taskHandle,int32 numSampsPerChan,float64 timeout,bool32 fillMode,
%		uInt8 readArray[],uInt32 arraySizeInBytes,int32 *sampsPerChanRead,int32 *numBytesPerSamp,bool32 *reserved);
% int32 DAQmxStopTask (TaskHandle taskHandle);
% int32 DAQmxWriteDigitalLines (
%		TaskHandle taskHandle,int32 numSampsPerChan,bool32 autoStart,float64 timeout,bool32 dataLayout,
%		uInt8 writeArray[],int32 *sampsPerChanWritten,bool32 *reserved);
% int32 DAQmxStopTask (TaskHandle taskHandle);
% 
% 
% written by Tobias Lindell
% inspired by Nathan Tomlin (nathan.a.tomlin@gmail.com)
% v0 - 1302

autoStart = 1;


[err,sampsPerChanWritten,empty] = calllib(lib,'DAQmxWriteDigitalLines',...
	taskh,numSampsPerChan,autoStart,timeout,dataLayout,...
	DOvalue,0,[]);
DAQmxCheckError(lib,err);
end

function data = DAQmxReadDigitalLines(lib,taskh,numSampsPerChan,timeout,fillMode,numchan,numsample)
% function data = DAQmxReadDigitalLines(lib,taskh,numSampsPerChan,timeout,fillMode,numchan,numsample)
% 
% this function reads digital inputs from previously setup task
% 
% inputs:
%	lib - .dll or alias (ex. 'myni')
%	taskh - taskhandle of analog inputs
%	numSampsPerChan = ?
%	timeout - in seconds
%	fillMode - DAQmx_Val_GroupByChannel or DAQmx_Val_GroupByScanNumber
%	numchan - number of digital channels to read
%	numsample - number of samples to read
% 
% C functions:
% int32 DAQmxReadDigitalLines (
%		TaskHandle taskHandle,int32 numSampsPerChan,float64 timeout,bool32 fillMode,
%		uInt8 readArray[],uInt32 arraySizeInBytes,int32 *sampsPerChanRead,int32 *numBytesPerSamp,bool32 *reserved);
% int32 DAQmxStopTask (TaskHandle taskHandle);
% 
% written by Tobias Lindell
% inspired by Nathan Tomlin (nathan.a.tomlin@gmail.com)
% v0 - 1302


% make some pointers
% readarray1=ones(numchan,numsample); readarray1_ptr=libpointer('doublePtr',readarray1);
readarray1=ones(numchan,numsample); readarray1_ptr=libpointer('uint8Ptr',readarray1);
sampread=1; sampread_ptr=libpointer('int32Ptr',sampread);
bytespersamp=1; bytespersamp_ptr=libpointer('int32Ptr',bytespersamp);
empty=[]; empty_ptr=libpointer('uint32Ptr',empty);

arraylength=numsample*numchan; % more like 'buffersize'

[err,~,sampread,~,empty]=calllib(lib,'DAQmxReadDigitalLines',...
		taskh,numSampsPerChan,timeout,fillMode,...
		readarray1_ptr,arraylength,sampread_ptr,bytespersamp_ptr,empty_ptr);
DAQmxCheckError(lib,err);

% err = calllib(lib,'DAQmxStopTask',taskh);
% DAQmxCheckError(lib,err);

data = sampread;
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