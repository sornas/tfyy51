function [out] = get_seg_constant(position, lap_constants, track, track_len)
%GET_SEG_CONSTANT Avg�r vilken seg_constat som ska anv�ndas utif�n
%nuvarande position.
%{   
position - Position i meter fr�n start
lap_constants - De seg_constants som ska anv�ndas detta varv
track - den bana/bil som ber�kningarna ska g�ras f�r
%}
for i = 1:length(track_len)
    if position >= track_len(i)
        seg_constant_num = i;
    end
end
out = lap_constants(seg_constant_num);
end

