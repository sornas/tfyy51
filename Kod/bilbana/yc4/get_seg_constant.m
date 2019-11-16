function [out] = get_seg_constant(position, lap_constants, track)
%GET_SEG_CONSTANT Avgör vilken seg_constat som ska användas utifån
%nuvarande position.
%{   
position - Position i meter från start
lap_constants - De seg_constants som ska användas detta varv
track - den bana/bil som beräkningarna ska göras för
%}
track_len = [0 2.53 3.05 4.73 7.68 8.98 10.93 14.96 17.57;
             0 2.53 3.05 4.92 7.60 8.84 10.65 14.68 17.76];
for i = 1:length(track_len)
    if position > track_len(track, i)
        seg_constant_num = track_len(track, i);
    end
end
out = lap_constants(seg_constant_num);
end

