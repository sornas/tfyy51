function [out] = get_seg_constant(position, lap_constants, track, track_len)
%GET_SEG_CONSTANT Avgör vilken seg_constat som ska användas utifån
%nuvarande position.
%{   
position - Position i meter från start
lap_constants - De seg_constants som ska användas detta varv
track - den bana/bil som beräkningarna ska göras för
%}
for i = 1:length(track_len)
    if position >= track_len(i)
        seg_constant_num = i;
    end
end
out = lap_constants(seg_constant_num);
end

