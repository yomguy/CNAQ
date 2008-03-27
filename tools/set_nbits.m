function set_nbits(handles, nbits)

    if nbits == 16
        nb_ind = 1;
    elseif nbits == 24
        nb_ind = 2;
    end
    set(handles.nbits,'Value', nb_ind);

end