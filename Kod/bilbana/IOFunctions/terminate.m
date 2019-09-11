function [] = terminate(track)
%TERMINATE Stops all counters associated with specified track.
%   Stops all counters associated with a specified track, and clears the
%   resources. 
%
%   If both tracks are terminated as a result of a call on terminate() all
%   resources, including the global variables, will be cleared and the
%   PCI6602 card will be reset to original state.
%
%  Tobias Lindell 2013-02-12

global mytaskh
global lib

switch nargin
    case 1
        if isempty(mytaskh)
            disp('User needs to initialize counters before terminating!')
            clearvars -global mytaskh lib
            return
        end
        
        
        switch track
            case 1
                % Check if track 1 counter has been initialized, stop program if not
                if isfield(mytaskh,'ctr_0')
                    % Clear counters of selcted track
                    calllib(lib,'DAQmxClearTask',mytaskh.ctr_0);
                    calllib(lib,'DAQmxClearTask',mytaskh.ctr_1);
                    calllib(lib,'DAQmxClearTask',mytaskh.ctr_2);
                    calllib(lib,'DAQmxClearTask',mytaskh.ctr_3);
                    clear mytaskh.ctr_0
                    clear mytaskh.ctr_1
                    clear mytaskh.ctr_2
                    clear mytaskh.ctr_3
                    mytaskh = rmfield(mytaskh,'ctr_0');
                    mytaskh = rmfield(mytaskh,'ctr_1');
                    mytaskh = rmfield(mytaskh,'ctr_2');
                    mytaskh = rmfield(mytaskh,'ctr_3');
                    % Check to see if counters of other track are cleared, if so
                    % reset card to original state and clear global variables
                    if ~isfield(mytaskh,'ctr_4')
                        disp('Everything terminated. Device will reset!')
                        calllib(lib,'DAQmxResetDevice','Dev1');
                        clearvars -global mytaskh lib
                    end
                    
                else
                    disp(['User needs to initialize counters for track ',num2str(track),' before terminating!'])
                    return
                end
            case 2
                if isfield(mytaskh,'ctr_4')
                    calllib(lib,'DAQmxClearTask',mytaskh.ctr_4);
                    calllib(lib,'DAQmxClearTask',mytaskh.ctr_5);
                    calllib(lib,'DAQmxClearTask',mytaskh.ctr_6);
                    calllib(lib,'DAQmxClearTask',mytaskh.ctr_7);
                    clear mytaskh.ctr_4
                    clear mytaskh.ctr_5
                    clear mytaskh.ctr_6
                    clear mytaskh.ctr_7
                    mytaskh = rmfield(mytaskh,'ctr_4');
                    mytaskh = rmfield(mytaskh,'ctr_5');
                    mytaskh = rmfield(mytaskh,'ctr_6');
                    mytaskh = rmfield(mytaskh,'ctr_7');
                    if ~isfield(mytaskh,'ctr_0')
                        disp('Everything terminated. Device will reset!')
                        calllib(lib,'DAQmxResetDevice','Dev1');
                        clearvars -global mytaskh lib
                    end
                else
                    disp(['User needs to initialize counters for track ',num2str(track),' before terminating!'])
                    return
                end
            otherwise
                disp('Wrong track argument sent to terminate(track)! Should be 1 or 2!')
        end
    otherwise
        disp('Wrong number of arguments sent to terminate(track)! Should be 1!')
end
end

