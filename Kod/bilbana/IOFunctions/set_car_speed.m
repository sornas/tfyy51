function [] = set_car_speed(track,speed)
%SET_CAR_SPEED Sets the specified car (track) to a specified speed.
%   Changes the duty cycle of counter 0 and 4 to change speed of car on
%   track 1 and track 2 respectively. Valid values of the duty cycle are
%   between 0 and 1, the input speed of the cars are defined as percent.
%
%   Tobias Lindell 2013-02-12.

global mytaskh
global lib

switch nargin
    case 2
        % Check if _any_ counters been initilized, stop program if not
        if isempty(mytaskh)
            disp(['User needs to initialize counters for track ',num2str(track),' before setting car speed!'])
            clearvars -global mytaskh lib
            return
        end
        
        % Setting duty cycle, with limits
        speed = min(99, speed);
        speed = max(0.1,speed);
        duty_cycle = speed / 100;
        
        switch track
            case 1
                % Check if track 1 counter has been initialized, stop program if not
                if isfield(mytaskh,'ctr_0')
                    % Stop task (necessary to change duty cycle)
                    calllib(lib,'DAQmxStopTask',mytaskh.ctr_0);
                    % Set new duty cycle
                    calllib(lib,'DAQmxSetCOPulseDutyCyc',mytaskh.ctr_0,'Dev1/ctr0',duty_cycle);
                    % Restart task
                    calllib(lib,'DAQmxStartTask',mytaskh.ctr_0);
                else
                    disp(['User needs to initialize counters for track ',num2str(track),' before setting car speed!'])
                    return
                end
            case 2
                if isfield(mytaskh,'ctr_4')
                    calllib(lib,'DAQmxStopTask',mytaskh.ctr_4);
                    calllib(lib,'DAQmxSetCOPulseDutyCyc',mytaskh.ctr_4,'Dev1/ctr4',duty_cycle);
                    calllib(lib,'DAQmxStartTask',mytaskh.ctr_4);
                else
                    disp(['User needs to initialize counters for track ',num2str(track),' before setting car speed!'])
                    return
                end
            otherwise
                disp('Wrong track number sent to set_car_speed!')
                return
        end
    otherwise
        disp('Wrong number of arguments sent to set_car_speed(track,speed)! Should be 2!')
end
end
