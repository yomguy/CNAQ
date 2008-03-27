function set_fs(handles, f_s)

    if f_s == 44100
        fs_ind = 1;
    elseif f_s == 48000
        fs_ind = 2;
    elseif f_s == 88200
        fs_ind = 3;
    elseif f_s == 96000
        fs_ind = 4;
    elseif f_s == 192000
        fs_ind = 5;
    end

    set(handles.f_s,'Value',fs_ind);

end