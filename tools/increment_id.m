function increment_id(handles)

    home_dir = get(handles.home_dir_box,'String');
    id_file = [home_dir '\ID.m'];
    id = get_id(handles);
    id = num2str(str2double(id) + 1);
    fid = fopen(id_file, 'w+');
    fprintf(fid, id);
    fclose(fid);
    set(handles.ID,'String',id);

end