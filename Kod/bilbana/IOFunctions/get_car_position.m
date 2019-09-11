function [add_lap,add_check_point,elapsed_time_check_point] = get_car_position(track)
%GET_CAR_POSITION Reads the current values of the lap and check point
%counters, and resets them if they are not equal to zero.
%   
%  Tobias Lindell 2013-02-13

global mytaskh
global lib

switch nargin
    case 1
        add_lap = [];
        add_check_point = [];
        elapsed_time_check_point = [];
        
        if isempty(mytaskh)
            disp(['User needs to initialize counters for track ',num2str(track),' before getting car position!'])
            clearvars -global mytaskh lib
            return
        end
        
        switch track
            case 1
                if isfield(mytaskh,'ctr_1')
                    add_check_point = DAQmxReadCounterScalarU32(lib,mytaskh.ctr_1);
                    add_lap = DAQmxReadCounterScalarU32(lib,mytaskh.ctr_2);
                    read_ticks = DAQmxReadCounterScalarU32(lib,mytaskh.ctr_3);
                else
                    disp(['User needs to initialize counters for track ',num2str(track),' before getting car position!'])
                    return
                end
            case 2
                if isfield(mytaskh,'ctr_5')
                    add_check_point = DAQmxReadCounterScalarU32(lib,mytaskh.ctr_5);
                    add_lap = DAQmxReadCounterScalarU32(lib,mytaskh.ctr_6);
                    read_ticks = DAQmxReadCounterScalarU32(lib,mytaskh.ctr_7);
                else
                    disp(['User needs to initialize counters for track ',num2str(track),' before getting car position!'])
                    return
                end
                
            otherwise
                disp('Wrong track number sent to get_car_position!')
                return
        end
        
        if add_check_point || add_lap
            elapsed_time_check_point = read_ticks / 100;
            start_race(track);
            clear read_ticks
        end
    otherwise
        disp('Wrong number of input arguments sent to get_car_position(track)! Should be 1!')
end
end

function Data = DAQmxReadCounterScalarU32(lib,taskh)
% function taskh = DAQmxReadCounterScalarU32(lib,taskh)
% 
% this function reads a counter value from previously setup task
% 
% inputs:
%	lib - .dll or alias (ex. 'myni')
%	taskh - taskhandle of analog inputs
% 
% 
% written by Tobias Lindell
% inspired by Nathan Tomlin (nathan.a.tomlin@gmail.com)
% v0 - 1302

DAQmx_Val_WaitInfinitely = -1.0;

reserved = []; 
reserved_ptr = libpointer('uint32Ptr',reserved);
Data = 1; 
data_ptr = libpointer('uint32Ptr',Data);
calllib(lib,'DAQmxReadCounterScalarU32',taskh,DAQmx_Val_WaitInfinitely,data_ptr,reserved_ptr);
counter = get(data_ptr);
Data = counter.Value;
end

