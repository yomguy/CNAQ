function voices_in = get_voices_in(handles)

    vi_ind = get(handles.voices_in,'Value');
    if vi_ind == 1
       voices_in = [1];
    elseif vi_ind == 2
       voices_in = [1 2];
    elseif vi_ind == 3
       voices_in = [1 2 3];
    elseif vi_ind == 4
       voices_in = [1 2 3 4];
    end

end