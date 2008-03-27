function id = get_id(handles)

    home_dir = get(handles.home_dir_box,'String');
    id_file = [home_dir '\ID.m'];
    if exist(id_file) == 0
        id = '1';
    elseif exist(id_file) == 2
        fid = fopen(id_file, 'r');
        id = fgetl(fid);
        fclose(fid); 
    end

end