function f_s = get_fs(fs_id)

    if fs_id == 1
        f_s = 44100;
    elseif fs_id == 2
        f_s = 48000;
    elseif fs_id == 3
        f_s = 88200;
    elseif fs_id == 4
        f_s = 96000;
    elseif fs_id == 5
        f_s = 192000;
    end

end