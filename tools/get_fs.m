function f_s = get_fs(handles)

    fs_ind = get(handles.f_s,'Value');
    if fs_ind == 1
        f_s = 44100;
    elseif fs_ind == 2
        f_s = 48000;
    elseif fs_ind == 3
        f_s = 96000;
    end

end