function channels_in = get_channels_in(ch_id)

    if ch_id == 1
       channels_in = [1];
    elseif ch_id == 2
       channels_in = [1 2];
    elseif ch_id == 3
       channels_in = [1 2 3];
    elseif ch_id == 4
       channels_in = [1 2 3 4];
    elseif ch_id == 5
       channels_in = [1 2 3 4 5 6 7 8];
    end

end