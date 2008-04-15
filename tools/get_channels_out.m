function channels_out = get_channels_out(ch_id)

    if ch_id == 1
       channels_out  = [1];
    elseif ch_id == 2
       channels_out = [1 2];
    elseif ch_id == 3
       channels_out = [1 2 3];
    elseif ch_id == 4
       channels_out = [1 2 3 4];
    elseif ch_id == 5
       channels_out = [1 2 3 4 5 6 7 8];
    end

end