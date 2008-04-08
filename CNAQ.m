function varargout = CNAQ(varargin)
%  CNAQ M-file for CNAQ.fig
%
%  Copyright (c) 2007-2008 Guillaume Pellerin <guillaume.pellerin@cnam.fr>
%  All rights reserved.

%  This software is governed by the CeCILL license under French law and
%  abiding by the rules of distribution of free software.  You can  use, 
%  modify and/ or redistribute the software under the terms of the CeCILL
%  license as circulated by CEA, CNRS and INRIA at the following URL
%  "http://www.cecill.info". 
%  
%  As a counterpart to the access to the source code and  rights to copy,
%  modify and redistribute granted by the license, users are provided only
%  with a limited warranty  and the software's author,  the holder of the
%  economic rights,  and the successive licensors  have only  limited
%  liability. 
%  
%  In this respect, the user's attention is drawn to the risks associated
%  with loading,  using,  modifying and/or developing or reproducing the
%  software by the user in light of its specific status of free software,
%  that may mean  that it is complicated to manipulate,  and  that  also
%  therefore means  that it is reserved for developers  and  experienced
%  professionals having in-depth computer knowledge. Users are therefore
%  encouraged to load and test the software's suitability as regards their
%  requirements in conditions enabling the security of their systems and/or 
%  data to be ensured and,  more generally, to use and operate it in the 
%  same conditions as regards security. 
%  
%  The fact that you are presently reading this means that you have had
%  knowledge of the CeCILL license given in the file COPYING and
%  that you accept its terms. The terms are also available at
%  http://svn.parisson.org/cnaq/wiki/CnaqLicense.

%  Author: Guillaume Pellerin <guillaume.pellerin@cnam.fr>

% Last Modified by GUIDE v2.5 08-Apr-2008 18:19:43

%      CNAQ, by itself, creates a new CNAQ or raises the existing
%      singleton*.
%
%      H = CNAQ returns the handle to a new CNAQ or the handle to
%      the existing singleton*.
%
%      CNAQ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CNAQ.M with the given input arguments.
%
%      CNAQ('Property','Value',...) creates a new CNAQ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CNAQ_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CNAQ_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%  See also: GUIDE, GUIDATA, GUIHANDLES


% Global variables

% ==============================================================
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CNAQ_OpeningFcn, ...
                   'gui_OutputFcn',  @CNAQ_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


%global out_button_value in_button_value gen_button_value mes_button_value f_s n_bits;

% --- Executes just before CNAQ is made visible.
function CNAQ_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CNAQ (see VARARGIN)

% Choose default command line output for CNAQ
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = CNAQ_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% UIWAIT makes CNAQ wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% ==============================================================

% ==============================================================
% INIT
% ==============================================================

root_dir = pwd; % The directory where CNAQ is installed
cnaq_path = root_dir;
config_path = [cnaq_path filesep 'config' filesep];
tools_path = [cnaq_path filesep 'tools' filesep];
pa_path = [cnaq_path filesep 'lib' filesep 'pa_wavplay' filesep];
path(path, cnaq_path);
path(path, tools_path);
path(path, pa_path);
path(path, config_path);
cnaq_version = get_version();

% Get audio device parameters
[device, latency] = asio();

% Get home directory
home_dir = uigetdir(root_dir, 'Choose your workspace');

% Get/Set ID
set(handles.home_dir_box,'String',home_dir);
id = get_id(handles);
set(handles.ID,'String',id);
set(handles.info1_text,'String',['CNAQ v' cnaq_version ' - Copyright (C) 2007-2008']);
set(handles.info2_text,'String','Guillaume Pellerin, Manuel Melon  CNAM Paris   http://svn.parisson.org/cnaq/');

% Set default values
set(handles.f_gen_min,'String','20');
set(handles.f_gen_max,'String','20000');
set(handles.f_gen,'Value',1000);
set(handles.f_gen,'Min',20);
set(handles.f_gen,'Max',20000);
set(handles.freq_value,'String','1000')

set(handles.gain_in,'Value',-6.0);
set(handles.gain_in_value,'String','-6.0');
set(handles.gain_out,'Value',-6.0);
set(handles.gain_out_value,'String','-6.0');

set(handles.time_gen_min,'String','1');
set(handles.time_gen_max,'String','20');
set(handles.time_gen,'Value',5);
set(handles.time_gen,'Min',1);
set(handles.time_gen,'Max',20);
set(handles.time_value,'String','5')

set(handles.nbits,'String','16|24'); 
set(handles.f_s,'String','44100|48000|88200|96000|192000');

%set(handles.out_on_off,'Value',0);
set(handles.in_on_off,'Value',0);
set(handles.gen_on_off,'Value',0);
set(handles.sig_type,'String','Sinus|Chirp|White noise|Pink noise');
set(handles.channels_in,'String','1|1 2|1 2 3|1 2 3 4|1 2 3 4 5 6 7 8');
set(handles.channels_out,'String','1|1 2|1 2 3|1 2 3 4|1 2 3 4 5 6 7 8');

set(handles.analysis_type,'String','Default');
set(handles.analysis_method,'String','Transfert function|Deconvolution');
set(handles.analysis_domain,'String','Frequency|Time');
set(handles.in_on_off,'UserData',device);
set(handles.save_button,'UserData',latency);

    
%============================================
% DATA
%============================================

function username_Callback(hObject, eventdata, handles)
% hObject    handle to username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of username as text
%        str2double(get(hObject,'String')) returns contents of username as a double

% --- Executes during object creation, after setting all properties.
function username_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function comment_Callback(hObject, eventdata, handles)

function comment_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function f_s_Callback(hObject, eventdata, handles)

function f_s_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function nbits_Callback(hObject, eventdata, handles)

function nbits_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function get_home_dir_Callback(hObject, eventdata, handles)
    home_dir = uigetdir;
    set(handles.home_dir_box,'String',home_dir);
    id = get_id(handles);
    set(handles.ID,'String',id);
 
    
%============================================
% MONITOR
%============================================
    
function in_on_off_Callback(hObject, eventdata, handles)
    monitor(handles)

    
%============================================
% VOICES
%============================================

function gain_in_Callback(hObject, eventdata, handles)
    set(handles.gain_in_value,'String',num2str(get(handles.gain_in,'Value')));

function gain_in_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

function gain_out_Callback(hObject, eventdata, handles)
    set(handles.gain_out_value,'String',num2str(get(handles.gain_out,'Value')))

function gain_out_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

function channels_in_Callback(hObject, eventdata, handles)

function channels_in_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function channels_out_Callback(hObject, eventdata, handles)

function channels_out_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
  
    
%============================================
% GENERATOR
%============================================

function sig_type_Callback(hObject, eventdata, handles)

function sig_type_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    
% TIME

function time_gen_min_Callback(hObject, eventdata, handles)
    tg_min = str2double(get(handles.time_gen_min,'String'));
    tg_value = get(handles.time_gen,'Value');
    if tg_min > tg_value
        set(handles.time_gen,'String',num2str(tg_min));
    end
    set(handles.time_gen,'Min',tg_min);

function time_gen_min_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function time_gen_max_Callback(hObject, eventdata, handles)
    tg_max = str2double(get(handles.time_gen_max,'String'));
    tg_value = get(handles.time_gen,'Value');
    if tg_max < tg_value
        set(handles.time_gen,'String',num2str(tg_max));
    end
    set(handles.time_gen,'Max',tg_max);

function time_gen_max_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function time_gen_Callback(hObject, eventdata, handles)
    set(handles.time_value,'String',num2str(get(handles.time_gen,'Value')))

function time_gen_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end


% FREQ

function f_gen_max_Callback(hObject, eventdata, handles)
    fg_max = str2double(get(handles.f_gen_max,'String'));
    fg_value = get(handles.f_gen,'Value');
    if fg_max < fg_value
        set(handles.f_gen,'String',num2str(fg_max));
    end
    set(handles.f_gen,'Max',fg_max);    

function f_gen_max_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function f_gen_min_Callback(hObject, eventdata, handles)
    fg_min = str2double(get(handles.f_gen_min,'String'));
    fg_value = get(handles.f_gen,'Value');
    if fg_min > fg_value
        set(handles.f_gen,'String',num2str(fg_min));
    end
    set(handles.f_gen,'Min',fg_min);

function f_gen_min_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function f_gen_Callback(hObject, eventdata, handles)
    set(handles.freq_value,'String',num2str(get(handles.f_gen,'Value')));
    
function f_gen_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

function gen_on_off_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of gen_on_off
    generator(handles)


%============================================
% MEASUREMENT
%============================================

function analysis_method_Callback(hObject, eventdata, handles)

function analysis_method_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function mes_on_Callback(hObject, eventdata, handles, device)
    measurement(handles)
    plot_main(handles)
    
% Close all figures
% --- Executes on button press in close_button.
function close_button_Callback(hObject, eventdata, handles)
% hObject    handle to close_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close all;
        
% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    plot_main(handles)
     
% SAVE all data in a mat file 
function save_button_Callback(hObject, eventdata, handles)  
    save_mes(handles)
    

% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handless)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    [filename, pathname, filterindex] = uigetfile('*.mat', 'Pick a saved MAT file');
    load([pathname filename]);
    
    % Set data
    set(handless.username,'String',username);
    set(handless.home_dir_box,'String',home_dir);
    set(handless.comment,'String',comment);
    set(handless.id_title,'UserData',sig_exc);
    set(handless.ID,'UserData',sig_mes);
    set(handless.mes_on,'UserData',f_log);
    set(handless.close_button,'UserData',f_lin);
    set(handless.mes_on,'UserData', f);
    set(handless.plot,'UserData', t);
%      set(handles.f_gen_min,'String', num2str(f_min));
%      set(handles.f_gen_max,'String', num2str(f_max));
%      set(handles.f_gen,'Value', f);
%      set(handles.freq_value,'String',num2str(f));
%      set(handles.time_gen,'Value', time);
%      set(handles.time_value,'String',num2str(time));
%      set(handles.gain_in,'Value', gain_in);
%      set(handles.gain_out,'Value', gain_out);
%      set(handles.gain_in_value,'String',num2str(gain_in));
%      set(handles.gain_out_value,'String',num2str(gain_out));
%      set(handles.freq_value,'String',num2str(f));
%      set(handles.time_value,'String',num2str(time));




% --- Executes on selection change in analysis_type.
function analysis_type_Callback(hObject, eventdata, handles)
% hObject    handle to analysis_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns analysis_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from analysis_type


% --- Executes during object creation, after setting all properties.
function analysis_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analysis_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in analysis_domain.
function analysis_domain_Callback(hObject, eventdata, handles)
% hObject    handle to analysis_domain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns analysis_domain contents as cell array
%        contents{get(hObject,'Value')} returns selected item from analysis_domain


% --- Executes during object creation, after setting all properties.
function analysis_domain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analysis_domain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


