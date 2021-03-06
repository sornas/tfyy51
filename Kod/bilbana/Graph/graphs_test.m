%{
%% Data needed
A = [3.9,1.1,2.2,1.8,1.4,3.9,1.5,3.4,1.4;
     4.2,1.1,2.2,1.8,1.4,3.4,1.5,3.4,1.4;
     3.2,1.1,2.2,1.8,1.4,3.2,1.5,3.4,1.4;
     4.0,1.1,2.2,1.8,1.4,3.6,1.5,3.4,1.4;
     4.1,1.1,2.2,1.8,1.4,3.8,  0,  0,  0];
B = [3.9,1.1,2.2,1.8,1.4,3.9,  0,  0,  0];
C = [3.9,1.1,2.2,1.8,1.4,3.9,1.5,3.1,1.0;
     4.1,1.1,2.2,1.8,1.4,3.4,  0,  0,  0];
car1.seg_times = C;
car1.lap_times = [14.1,13.8,14.15,13.9,14.1,14];
ref_lap_time = 14;
%% Actual test
graphs(car1.lap_times,ref_lap_time,car1.seg_times,5)
%}
ref_time = input('Vilken referenstid ska anv�ndas? [13] ', 's');
ref_time = str2double(ref_time);
if isnan(ref_time)
    ref_time = 13;
elseif not(isreal(ref_time))
    ref_time = 13;
end
disp(ref_time)
disp(ref_time*2)
