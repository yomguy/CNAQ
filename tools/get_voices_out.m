function voices_out = get_voices_out(handles)

    vo_ind = get(handles.voices_out,'Value');
    if vo_ind == 1
       voices_out  = [1];
    elseif vo_ind == 2
       voices_out = [1,2];
    elseif vo_ind == 3
       voices_out = [1,2,3];
    elseif vo_ind == 4
       voices_out = [1,2,3,4];
    end

end