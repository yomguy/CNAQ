function channels_out = get_channels_out(ch_id)

    if ch_ind == 1
       channels_out  = [1];
    elseif ch_ind == 2
       channels_out = [1 2];
    elseif ch_ind == 3
       channels_out = [1 2 3];
    elseif ch_ind == 4
       channels_out = [1 2 3 4];
    elseif ch_ind == 5
       channels_out = [1 2 3 4 5 6 7 8];
    end

end