function [] = start_race(track)
%START_RACE Stops, resets and starts all counters associated with specified
%track.
%   All counters, except the pulse train speed counters, associated with a
%   specified track are stopped and restarted. This resets the current
%   values of the counters to the initial value (0 for all counters).
%
%   At first call the counters just starts, the extra stopping of counters
%   that are not running does nothing.
%   
%   Tobias Lindell - 2013-02-12

global mytaskh
global lib

switch nargin
    case 1
        % Check if _any_ counters been initilized, stop program if not
        if isempty(mytaskh)
            disp(['User needs to initialize counters for track ',num2str(track),' before setting car speed!'])
            clearvars -global mytaskh lib
            return
        end
        
        switch track
            case 1
                if ~isfield(mytaskh,'ctr_1')
                    disp(['User needs to initialize counters for track ',num2str(track),' before setting car speed!'])
                    return
                end
                calllib(lib,'DAQmxStopTask',mytaskh.ctr_1);
                calllib(lib,'DAQmxStopTask',mytaskh.ctr_2);
                calllib(lib,'DAQmxStopTask',mytaskh.ctr_3);
                calllib(lib,'DAQmxStartTask',mytaskh.ctr_1);
                calllib(lib,'DAQmxStartTask',mytaskh.ctr_2);
                calllib(lib,'DAQmxStartTask',mytaskh.ctr_3);
            case 2
                if ~isfield(mytaskh,'ctr_5')
                    disp(['User needs to initialize counters for track ',num2str(track),' before setting car speed!'])
                    return
                end
                calllib(lib,'DAQmxStopTask',mytaskh.ctr_5);
                calllib(lib,'DAQmxStopTask',mytaskh.ctr_6);
                calllib(lib,'DAQmxStopTask',mytaskh.ctr_7);
                calllib(lib,'DAQmxStartTask',mytaskh.ctr_5);
                calllib(lib,'DAQmxStartTask',mytaskh.ctr_6);
                calllib(lib,'DAQmxStartTask',mytaskh.ctr_7);
            otherwise
                disp('Wrong track number sent to start_race!')
                return
        end
    otherwise
        disp('Wrong number of arguments sent to start_race(track)! Should be 1!')
end
end

