function f_s = get_fs(fs_ind)

    if fs_ind == 1
        f_s = 44100;
    elseif fs_ind == 2
        f_s = 48000;
    elseif fs_ind == 3
        f_s = 88200;
    elseif fs_ind == 4
        f_s = 96000;
    elseif fs_ind == 5
        f_s = 192000;
    end

end