function varargout = CNAQ(varargin)
%  CNAQ M-file for CNAQ.fig
%
%  Copyright (c) 2007 Guillaume Pellerin <guillaume.pellerin@cnam.fr>
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

% Last Modified by GUIDE v2.5 07-Nov-2007 18:26:57

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

cnaq_version = '0.1';
        
% ==============================================================
% PARAMETERS
% ==============================================================
        
% The ASIO device number in the audio sytem
device = 0;  

% The number of samples in the buffer of the sound card
% (delay * f_s = latency time)
% It IS necessary that you compute this value BEFORE any measurement
% executing ./tests/get_latency.m in MATLAB like this :
% >> get_latency(DEVICE, N)
% where DEVICE is the device number (see above) and N the number of 
% successive measurements
% If this value is wrong, the phasis results might be also wrong...
delay = 587;


% ==============================================================
% INIT
% ==============================================================

root_dir = pwd; % The directory where CNAQ is installed
%cnaq_path = pwd;
cnaq_path = root_dir;
tools_path = [cnaq_path '\tools\'];
pa_path = [cnaq_path '\pa_wavplay\'];
path(path, cnaq_path);
path(path, tools_path);
path(path, pa_path);
home_dir = uigetdir(root_dir, 'Choisissez votre dossier de travail');

% Get/Set ID
id = get_id(handles);
set(handles.ID,'String',id);
set(handles.home_dir_box,'String',home_dir);
set(handles.info1_text,'String',['CNAQ v' cnaq_version ' - Copyright (C) 2007']);
set(handles.info2_text,'String','Guillaume Pellerin, Manuel Melon (CNAM Paris)  http://svn.parisson.org/cnaq/');

%set(handles.home_dir_box,'C:\CNAQ\');

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
set(handles.f_s,'String','44100|48000|96000');

%set(handles.out_on_off,'Value',0);
set(handles.in_on_off,'Value',0);
set(handles.gen_on_off,'Value',0);
set(handles.sig_type,'String','Sinus|Chirp');
set(handles.voices_in,'String','1|1 2|1 2 3|1 2 3 4');
set(handles.voices_out,'String','1|1 2|1 2 3|1 2 3 4');

set(handles.in_on_off,'UserData',device);
set(handles.save_button,'UserData',delay);

% ==============================================================
% TOOLS
% ==============================================================

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

function increment_id(handles)
    home_dir = get(handles.home_dir_box,'String');
    id_file = [home_dir '\ID.m'];
    id = get_id(handles);
    id = num2str(str2double(id) + 1);
    fid = fopen(id_file, 'w+');
    fprintf(fid, id);
    fclose(fid);
    set(handles.ID,'String',id);
    
function f_s = get_fs(handles)
    fs_ind = get(handles.f_s,'Value');
    if fs_ind == 1
        f_s = 44100;
    elseif fs_ind == 2
        f_s = 48000;
    elseif fs_ind == 3
        f_s = 96000;
    end

function voices_out = get_voices_out(handles)
    vo_ind = get(handles.voices_out,'Value');
    if vo_ind == 1
       voices_out  = [1];
    elseif vo_ind == 2
       voices_out = [1,2];
    elseif vo_ind == 3
       voices_out = [1,2,3];
    elseif vo_ind == 4
       voices_out = [1,2,3,4];
    end
    
function voices_in = get_voices_in(handles)
    vi_ind = get(handles.voices_in,'Value');
    if vi_ind == 1
       voices_in = [1];
    elseif vi_ind == 2
       voices_in = [1 2];
    elseif vi_ind == 3
       voices_in = [1 2 3];
    elseif vi_ind == 4
       voices_in = [1 2 3 4];
    end

function nbits = get_nbits(handles)
    nb_ind = get(handles.nbits,'Value');
    if nb_ind == 1
        nbits = 16;
    elseif nb_ind == 2
        nbits = 24;
    end


%============================================
% DONNEES
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
    device = get(handles.in_on_off,'UserData');
    buffer = 4096;
    window = hanning(buffer);
    f_s = get_fs(handles);
    time = buffer/f_s;
    t = [0:1/f_s:time-1/f_s];
    
    f_min = str2double(get(handles.f_gen_min,'String'));
    f_max = str2double(get(handles.f_gen_max,'String'));
    freq = 2*(f_max-f_min)/buffer;
    f = [f_min:freq:f_max-freq];
    voices_in = get_voices_in(handles);
    voice_first = voices_in(1);
    voice_last =  voices_in(length(voices_in));
        
    while get(handles.in_on_off,'Value') == 1
        % TIME_GEN
        %sig_in = wavrecord(buffer,f_s,2);
        sig_in = pa_wavrecord(voice_first, voice_last, buffer, f_s, device, 'asio');
        sig_in = sig_in(:,1);
        axes(handles.plot_in_temp);
        cla;
        %sig = sin(2*pi*10*t);
        plot(t,sig_in);
        grid on;
        
        % FREQ
        axes(handles.plot_in_freq);
        cla;
        fft_in = fft(sig_in.*window,buffer);
        log_abs_fft_in = 20*log10(2*abs(fft_in(1:round(buffer/2)))/buffer);
        semilogx(f,log_abs_fft_in);
        %axis([f_min f_max min(log_abs_fft_in) max(log_abs_fft_in)]);
        axis([f_min f_max -120 0]);
        grid on;
        drawnow;
        pause(0.01);
    end

    
%============================================
% VOIES
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

function voices_in_Callback(hObject, eventdata, handles)

function voices_in_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function voices_out_Callback(hObject, eventdata, handles)

function voices_out_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
%============================================
% GENERATEUR
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
    
    f_min = str2double(get(handles.f_gen_min,'String'));
    f_max = str2double(get(handles.f_gen_max,'String'));
    sig_type = get(handles.sig_type,'Value');
    sin_freq = get(handles.f_gen,'Value');
    f_s = get_fs(handles);
    time = get(handles.time_gen,'Value');
    voices_out = get_voices_out(handles);
    %voice_first = voices_out(1);
    %voice_last = voices_out(length(voices_out));
    gain_out = get(handles.gain_out,'Value');
    gain_out = 10^(gain_out/20);
    t = [0:1/f_s:time];
    
    if sig_type == 1
        % SINUS
        sig = gain_out*sin(2*pi*sin_freq*t);
    elseif sig_type == 2
        % CHIRP
        sig = gain_out*chirp(t,f_min,time,f_max,'logarithmic');
    end
  
    sig_out = [];
    for i=1:length(voices_out)
        sig_out(:,i) = sig';
    end
    
    % Matlab way (needs Data Acquisition Toolbox)
%      ao = analogoutput('winsound', 0);
%      addchannel(ao, voices_out);
%      set(ao, 'StandardSampleRates', 'Off');
%      set(ao, 'SampleRate', f_s);
%      
%      if get(handles.gen_on_off,'Value') == 1
%          putdata(ao, sig_out);
%          start(ao);
%          set(handles.gen_on_off,'Value',0);
%      end
%      %delete(ao);

    % PA way but can't work with monitor !...
    % pa_wavplay(sig_out',f_s,0,'asio');

    % Winsoud way...
    sound(sig_out',f_s);


%============================================
% MESURE
%============================================

function mes_type_Callback(hObject, eventdata, handles)

function mes_type_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function mes_on_Callback(hObject, eventdata, handles, device)
    device = get(handles.in_on_off,'UserData');
    delay = get(handles.save_button,'UserData');
    nfft = 16384;
    f_min = str2double(get(handles.f_gen_min,'String'));
    f_max = str2double(get(handles.f_gen_max,'String'));
    f_s = get_fs(handles);
    time = get(handles.time_gen,'Value');
    voices_in = get_voices_in(handles);
    voice_first = voices_in(1);
    voice_last =  voices_in(length(voices_in));
    gain_out = get(handles.gain_out,'Value');
    gain_out = 10^(gain_out/20);
    
    % Avoid Gibbs like phenomenon
    f0 = 1;
    f1 = f_min;
    f2 = f_max;
    f3 = f_s/2;
    fade_in_time = time/((log(f2/f0)/log(f1/f0))-1);
    fade_out_time = time*((log(f3/f1)/log(f2/f1))-1);  
    total_time = fade_in_time + time + fade_out_time;
    t = [0:1/f_s:total_time];
    
    % Remove clicks durring emission and oscillations in the spectral response
    len_win_in = fade_in_time * f_s;
    window = blackman(len_win_in);
    len_win_in = round(len_win_in/2);
    window_in = window(1:len_win_in);
    
    len_win_out = fade_out_time * f_s;
    window = blackman   (len_win_out);
    len_win_out = round(len_win_out/2);
    window_out = flipud(window(1:len_win_out));
    
    sig_exc = gain_out*chirp_farina(t,total_time,f0,f3);
    l_t = length(t);
    one(1:l_t-len_win_in-len_win_out) = 1;
    mask = [window_in' one window_out'];
    sig_exc = sig_exc.*mask;
    
    % Synchronizing
    zero = zeros(1,delay);
    % Zeros are added before and removed after
    sig_exc_z = [sig_exc zero];
    len_sig_exc = length(sig_exc);
    
    % Make all voices
    sig_out = [];
    for i=1:length(voices_in)
        sig_out(:,i) = sig_exc_z';
    end
    
    % Measure
    sig_mes = pa_wavplayrecord(sig_out, device, f_s, 0, voice_first, voice_last, device, 'asio');
    %    Usage:
    %      inputbuffer = pa_wavplayrecord(playbuffer,[playdevice],[samplerate],
    %                       [recnsamples], [recfirstchannel], [reclastchannel],
    %                       [recdevice], [devicetype])
    
    % Resynchro
    len_sig_mes = length(sig_mes);
    size_sig_mes = size(sig_mes);
    n_col_sig_mes = size_sig_mes(2);
    sig_mes = sig_mes(delay+1:len_sig_mes,:);
    len_sig_mes = length(sig_mes);
    sig_exc = sig_exc';
    f = logspace(log10(f0), log10(f3), len_sig_mes)';
    
    % Save data
    set(handles.ID,'UserData',sig_mes);
    set(handles.id_title,'UserData',sig_exc);
    set(handles.mes_on,'UserData',f);
    
    % Get infos
    username = get(handles.username,'String');
    comment = get(handles.comment,'String');
    id = get(handles.ID,'String');
    
    % Compute excitation spectrum
    [rep_imp_exc, spec_exc] = fonc_trans(f, sig_exc, sig_exc);
    len_spec_exc = length(spec_exc);
    spec_exc = spec_exc(1:len_spec_exc/2);
    
    % Compute all Ris and specs
    for i=1:n_col_sig_mes
        voice = num2str(i);
        [rep_imp_mes, spec_mes] = fonc_trans(f, sig_exc, sig_mes(:,i));
        len_spec_mes = length(spec_mes);    
        spec_mes = spec_mes(1:len_spec_mes/2);
        % Plot results
        f_lin = [0:f_s/len_spec_mes:f_s/2];
        f_lin = f_lin(1:length(f_lin)-1);
        plot_mes(t, f_lin, f_s, f_min, f_max, sig_exc, sig_mes(:,i), rep_imp_mes, spec_mes, spec_exc, id, voice, username, comment, i);
    end
    
    set(handles.close_button,'UserData',f_lin');
    set(handles.plot,'UserData',t);

    
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
    
    % Get data
    sig_mes = get(handles.ID,'UserData');
    sig_exc = get(handles.id_title,'UserData');
    f = get(handles.mes_on,'UserData');
    t = get(handles.plot,'UserData');
    f_min = str2double(get(handles.f_gen_min,'String'));
    f_max = str2double(get(handles.f_gen_max,'String'));
    f_s = get_fs(handles);
    
    % Get infos
    username = get(handles.username,'String');
    comment = get(handles.comment,'String');
    id = get(handles.ID,'String');
    
    % Compute excitation spectrum
    [rep_imp_exc, spec_exc] = fonc_trans(f, sig_exc, sig_exc);
    len_spec_exc = length(spec_exc);
    spec_exc = spec_exc(1:len_spec_exc/2);
    
    size_sig_mes = size(sig_mes);
    n_col_sig_mes = size_sig_mes(2);
    
    % Compute all Ris and specs
    for i=1:n_col_sig_mes
        voice = num2str(i);
        [rep_imp_mes, spec_mes] = fonc_trans(f, sig_exc, sig_mes(:,i));
        len_spec_mes = length(spec_mes);    
        spec_mes = spec_mes(1:len_spec_mes/2);
        % Plot results
        f_lin = [0:f_s/len_spec_mes:f_s/2];
        f_lin = f_lin(1:length(f_lin)-1);
        plot_mes(t, f_lin, f_s, f_min, f_max, sig_exc, sig_mes(:,i), rep_imp_mes, spec_mes, spec_exc, id, voice, username, comment, i);
    end

    
% SAVE all data in a mat file 
function save_button_Callback(hObject, eventdata, handles)  
    % Get data
    id = get(handles.ID,'String');
    username = get(handles.username,'String');
    home_dir = get(handles.home_dir_box,'String');
    comment = get(handles.comment,'String');
    sig_exc = get(handles.id_title,'UserData');
    sig_mes = get(handles.ID,'UserData');
    f_log = get(handles.mes_on,'UserData');
    f_lin = get(handles.close_button,'UserData');
    f_s = get_fs(handles);
    nbits = get_nbits(handles);
    f_min = str2double(get(handles.f_gen_min,'String'));
    f_max = str2double(get(handles.f_gen_max,'String'));
    time = get(handles.time_gen,'Value');
    voices_in = get_voices_in(handles);
    gain_in = get(handles.gain_in,'Value');
    voices_out = get_voices_out(handles);
    gain_out = get(handles.gain_out,'Value');
    
    % Save it
    file = [home_dir '\' username '_' id '.mat'];
    save(file);
    
    % Clear big data
    set(handles.ID,'UserData',[]);
    set(handles.id_title,'UserData',[]);
    set(handles.mes_on,'UserData',[]);
    
    % Increment ID
    increment_id(handles);
    
   