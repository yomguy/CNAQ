function nbits = get_nbits(handles)

    nb_ind = get(handles.nbits,'Value');
    if nb_ind == 1
        nbits = 16;
    elseif nb_ind == 2
        nbits = 24;
    end

end