function varargout = Tarea2(varargin)
% TAREA2 MATLAB code for Tarea2.fig
%      TAREA2, by itself, creates ca new TAREA2 or raises the existing
%      singleton*.
%
%      H = TAREA2 returns the handle to ca new TAREA2 or the handle to
%      the existing singleton*.
%
%      TAREA2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TAREA2.M with the given input arguments.
%
%      TAREA2('Property','Value',...) creates ca new TAREA2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Tarea2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Tarea2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Tarea2

% Last Modified by GUIDE v2.5 14-May-2019 19:13:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Tarea2_OpeningFcn, ...
                   'gui_OutputFcn',  @Tarea2_OutputFcn, ...
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


% --- Executes just before Tarea2 is made visible.
function Tarea2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Tarea2 (see VARARGIN)

% Choose default command line output for Tarea2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Reset DAQ connection
daqreset

% UIWAIT makes Tarea2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Tarea2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in FLP.
function FLP_Callback(hObject, eventdata, handles)
% hObject    handle to FLP (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FLP
if get(handles.FLP,'Value') == 1
    buttons_list = [handles.FBP, handles.FHP];
    set(buttons_list, 'Value', 0);
    set(handles.FCI,'Enable','on')
    set(handles.FCS,'Enable','off')
end

% --- Executes on button press in FBP.
function FBP_Callback(hObject, eventdata, handles)
% hObject    handle to FBP (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FBP
if get(handles.FBP,'Value') == 1
    buttons_list = [handles.FLP, handles.FHP];
    set(buttons_list, 'Value', 0);
    set(handles.FCI,'Enable','on')
    set(handles.FCS,'Enable','on')
end


% --- Executes on button press in FHP.
function FHP_Callback(hObject, eventdata, handles)
% hObject    handle to FHP (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FHP
if get(handles.FHP,'Value') == 1
    buttons_list = [handles.FBP, handles.FLP];
    set(buttons_list, 'Value', 0);
    set(handles.FCI,'Enable','off')
    set(handles.FCS,'Enable','on')
end


% --- Executes on selection change in FILTERTYPE.
function FILTERTYPE_Callback(hObject, eventdata, handles)
% hObject    handle to FILTERTYPE (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FILTERTYPE contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FILTERTYPE


% --- Executes during object creation, after setting all properties.
function FILTERTYPE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FILTERTYPE (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have ca white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FCI_Callback(hObject, eventdata, handles)
% hObject    handle to FCI (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FCI as text
%        str2double(get(hObject,'String')) returns contents of FCI as ca double


% --- Executes during object creation, after setting all properties.
function FCI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FCI (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have ca white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FCS_Callback(hObject, eventdata, handles)
% hObject    handle to FCS (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FCS as text
%        str2double(get(hObject,'String')) returns contents of FCS as ca double


% --- Executes during object creation, after setting all properties.
function FCS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FCS (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have ca white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ONFW.
function ONFW_Callback(hObject, eventdata, handles)
% hObject    handle to ONFW (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ONFW


% --- Executes on selection change in FWSignal.
function FWSignal_Callback(hObject, eventdata, handles)
% hObject    handle to FWSignal (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FWSignal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FWSignal


% --- Executes during object creation, after setting all properties.
function FWSignal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FWSignal (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have ca white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu19.
function popupmenu19_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu19 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu19


% --- Executes during object creation, after setting all properties.
function popupmenu19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have ca white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ONED.
function ONED_Callback(hObject, eventdata, handles)
% hObject    handle to ONED (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ONED



function CA_Callback(hObject, eventdata, handles)
% hObject    handle to CA (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CA as text
%        str2double(get(hObject,'String')) returns contents of CA as ca double


% --- Executes during object creation, after setting all properties.
function CA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CA (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have ca white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CB_Callback(hObject, eventdata, handles)
% hObject    handle to CB (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CB as text
%        str2double(get(hObject,'String')) returns contents of CB as ca double


% --- Executes during object creation, after setting all properties.
function CB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CB (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have ca white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CCi_Callback(hObject, eventdata, handles)
% hObject    handle to CCi (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CCi as text
%        str2double(get(hObject,'String')) returns contents of CCi as ca double


% --- Executes during object creation, after setting all properties.
function CCi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CCi (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have ca white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in EDSignal.
function EDSignal_Callback(hObject, eventdata, handles)
% hObject    handle to EDSignal (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns EDSignal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EDSignal


% --- Executes during object creation, after setting all properties.
function EDSignal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDSignal (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have ca white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have ca white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function duration_Callback(hObject, eventdata, handles)
% hObject    handle to duration (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration as text
%        str2double(get(hObject,'String')) returns contents of duration as ca double


% --- Executes during object creation, after setting all properties.
function duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have ca white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fsample_Callback(hObject, eventdata, handles)
% hObject    handle to fsample (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fsample as text
%        str2double(get(hObject,'String')) returns contents of fsample as ca double


% --- Executes during object creation, after setting all properties.
function fsample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fsample (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have ca white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in ca future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fs = str2num(get(handles.fsample, 'string'));
dur = str2num(get(handles.duration, 'string'));
Nlength = round(dur*fs);

%% initialization of the DAQ-session
Session = daq.createSession('ni');
set(Session, 'Rate', fs);
set(Session, 'DurationInSeconds', dur);

% preparation of the analog input
ai1 = addAnalogInputChannel(Session, 'Dev1', 'ai1', 'Voltage');
ai2 = addAnalogInputChannel(Session, 'Dev1', 'ai2', 'Voltage');
set(ai1, 'Range', [-5, 5]);
set(ai2, 'Range', [-5, 5]);

%% acquisition
[Sf, t] = startForeground(Session);
Sf = Sf';

%% Filtro por ecuaci�n de diferencias
if handles.ONED.Value == 1
    
    EDSignal = get(handles.EDSignal,'Value');    
    A1 = str2num(get(handles.CA, 'string'));
    B = str2num(get(handles.CB, 'string'));
    Ci = str2num(get(handles.CCi, 'string'));
    N = length(A1) - 1;
    M = length(B) - 1;
    
    figure,
    freqz(B,A1)
    
    if EDSignal == 1 % Canal 1
        X = horzcat(zeros(1,M),Sf(1,:));
        Y = horzcat(fliplr(Ci(1:N)), zeros(1,length(X) - M));
        A = A1./A1(1);
        A = A(2:end);
        B = B./A1(1);
        j = M + 1;
        for i = N + 1:length(Y)
            aux = fliplr(Y(i - N:i-1));
            aux2 = fliplr(X(1,j - M:j));
            Y(i) = -sum(aux.*A) + sum(aux2.*B);
            j = j + 1;
        end
        [Y_n,~] = mapminmax(Y);
    end  
    
    if EDSignal == 2 %Canal 2
        X = horzcat(zeros(1,M),Sf(2,:));
        Y = horzcat(fliplr(Ci(1:N)), zeros(1,length(X) - M));
        A = A1./A1(1);
        A = A(2:end);
        B = B./A1(1);
        j = M + 1;
        for i = N + 1:length(Y)
            aux = fliplr(Y(i - N:i-1));
            aux2 = fliplr(X(1,j - M:j));
            Y(i) = -sum(aux.*A) + sum(aux2.*B);
            j = j + 1;
        end
        [Y_n,~] = mapminmax(Y);
    end    
    
    if EDSignal == 3 %Ambos canales
        X = horzcat(zeros(1,M),Sf(1,:));
        Y = horzcat(fliplr(Ci(1:N)), zeros(1,length(X) - M));
        A = A1./A1(1);
        A = A(2:end);
        B = B./A1(1);
        j = M + 1;
        for i = N + 1:length(Y)
            aux = fliplr(Y(i - N:i-1));
            aux2 = fliplr(X(1,j - M:j));
            Y(i) = -sum(aux.*A) + sum(aux2.*B);
            j = j + 1;
        end
        [Y_n1,~] = mapminmax(Y);
               
        X = horzcat(zeros(1,M),Sf(2,:));
        Y = horzcat(fliplr(Ci(1:N)), zeros(1,length(X) - M));
        A = A1./A1(1);
        A = A(2:end);
        B = B./A1(1);
        j = M + 1;
        for i = N + 1:length(Y)
            aux = fliplr(Y(i - N:i-1));
            aux2 = fliplr(X(1,j - M:j));
            Y(i) = -sum(aux.*A) + sum(aux2.*B);
            j = j + 1;
        end
        [Y_n2,~] = mapminmax(Y);
        Y_n = vertcat(Y_n1, Y_n2);
    end           
    Y_n = Y_n(:,N:end);
end

%% Filtro por domino frecuencial
if handles.ONFW.Value == 1
    
    FCI = str2num(get(handles.FCI, 'string'));
    FCS = str2num(get(handles.FCS, 'string'));
    FilterSignal = get(handles.FWSignal, 'Value');
    TipoFil = get(handles.FILTERTYPE,'Value');
    
    if FilterSignal == 1 % Canal 1
        
        if get(handles.FLP,'Value') == 1 %Tipo LP
            %----------------------------------TIPO DE FILTRO----------------------
            switch TipoFil
                case 1 %FIR
                    a = 1;
                    lpFilt = designfilt('lowpassfir','PassbandFrequency',FCI/(fs/2), ...
                        'StopbandFrequency',(FCI/(fs/2))+0.1,'PassbandRipple',0.5, ...
                        'StopbandAttenuation',65,'DesignMethod','kaiserwin');
                case 2 %Butter
                    a = 0;
                    [num,den] = butter(6,FCI/(fs/2), 'low');
                case 3 %Chevy
                    a = 0;
                    [num,den] = cheby2(6,40,FCI/(fs/2), 'low');
            end
            %---------------------------APLICACION EN LA SE�AL---------------------
            if a == 0
                filterSignal = filter(num,den,Sf(1,:));
            else
                filterSignal = filter(lpFilt,Sf(1,:));
            end
            
        end
        
        if get(handles.FBP,'Value') == 1 %Tipo BP
            %----------------------------------TIPO DE FILTRO----------------------
            switch TipoFil
                case 1 %FIR
                    a = 1;
                    bpFilt = designfilt('bandpassfir','FilterOrder',20, ...
                         'CutoffFrequency1',FCI,'CutoffFrequency2',FCS, ...
                         'SampleRate',fs);
                case 2 %Butter
                    a = 0;
                    [num,den] = butter(6,[FCI FCS]/(fs/2), 'bandpass');
                case 3 %Chevy
                    a = 0;
                    [num,den] = cheby2(6,40,[FCI FCS]/(fs/2), 'bandpass');
            end
            %---------------------------APLICACION EN LA SE�AL---------------------
            if a == 0
                filterSignal = filter(num,den,Sf(1,:));
            else
                filterSignal = filter(bpFilt,Sf(1,:));
            end
        end
        
        if get(handles.FHP,'Value') == 1 %Tipo HP
            %----------------------------------TIPO DE FILTRO----------------------
            switch TipoFil
                case 1 %FIR
                    a = 1;
                    hpFilt = designfilt('highpassfir','StopbandFrequency',FCS/(fs/2), ...
                         'PassbandFrequency',(FCS/(fs/2))+0.1,'PassbandRipple',0.5, ...
                         'StopbandAttenuation',65,'DesignMethod','kaiserwin');
                case 2 %Butter
                    a = 0;
                    [num,den] = butter(6,FCS/(fs/2), 'high');
                case 3 %Chevy
                    a = 0;
                    [num,den] = cheby2(6,40,FCI/(fs/2), 'high');
            end
            %---------------------------APLICACION EN LA SE�AL---------------------
            if a == 0
                filterSignal = filter(num,den,Sf(1,:));
            else
                filterSignal = filter(hpFilt,Sf(1,:));
            end
            
        end
    end
    
    if FilterSignal == 2 % Canal 1
        
        if get(handles.FLP,'Value') == 1 %Tipo LP
            %----------------------------------TIPO DE FILTRO----------------------
            switch TipoFil
                case 1 %FIR
                    a = 1;
                    lpFilt = designfilt('lowpassfir','PassbandFrequency',FCI/(fs/2), ...
                        'StopbandFrequency',(FCI/(fs/2))+0.1,'PassbandRipple',0.5, ...
                        'StopbandAttenuation',65,'DesignMethod','kaiserwin');
                case 2 %Butter
                    a = 0;
                    [num,den] = butter(6,FCI/(fs/2), 'low');
                case 3 %Chevy
                    a = 0;
                    [num,den] = cheby2(6,40,FCI/(fs/2), 'low');
            end
            %---------------------------APLICACION EN LA SE�AL---------------------
            if a == 0
                filterSignal = filter(num,den,Sf(2,:));
            else
                filterSignal = filter(lpFilt,Sf(2,:));
            end
            
        end
        
        if get(handles.FBP,'Value') == 1 %Tipo BP
            %----------------------------------TIPO DE FILTRO----------------------
            switch TipoFil
                case 1 %FIR
                    a = 1;
                    bpFilt = designfilt('bandpassfir','FilterOrder',20, ...
                         'CutoffFrequency1',FCI,'CutoffFrequency2',FCS, ...
                         'SampleRate',fs);
                case 2 %Butter
                    a = 0;
                    [num,den] = butter(6,[FCI FCS]/(fs/2), 'bandpass');
                case 3 %Chevy
                    a = 0;
                    [num,den] = cheby2(6,40,[FCI FCS]/(fs/2), 'bandpass');
            end
            %---------------------------APLICACION EN LA SE�AL---------------------
            if a == 0
                filterSignal = filter(num,den,Sf(2,:));
            else
                filterSignal = filter(bpFilt,Sf(2,:));
            end
        end
        
        if get(handles.FHP,'Value') == 1 %Tipo HP
            %----------------------------------TIPO DE FILTRO----------------------
            switch TipoFil
                case 1 %FIR
                    a = 1;
                    hpFilt = designfilt('highpassfir','StopbandFrequency',FCS/(fs/2), ...
                         'PassbandFrequency',(FCS/(fs/2))+0.1,'PassbandRipple',0.5, ...
                         'StopbandAttenuation',65,'DesignMethod','kaiserwin');
                case 2 %Butter
                    a = 0;
                    [num,den] = butter(6,FCS/(fs/2), 'high');
                case 3 %Chevy
                    a = 0;
                    [num,den] = cheby2(6,40,FCI/(fs/2), 'high');
            end
            %---------------------------APLICACION EN LA SE�AL---------------------
            if a == 0
                filterSignal = filter(num,den,Sf(2,:));
            else
                filterSignal = filter(hpFilt,Sf(2,:));
            end
            
        end
    end        
    
end

%% Filtro por convoluci�n
if handles.ONCONV.Value == 1

    ConvSignal = get(handles.ConvSignal, 'Value');
    AConv = str2num(get(handles.AConv, 'string'));
    
    convSignal = conv(Sf(ConvSignal,:),AConv);
    convSignal = convSignal(1:length(Sf(ConvSignal,:)));
 
end

%% Graficacion
iteration = 25;
trama = Nlength/iteration;
axes(handles.axes1);
for i = 1 : iteration
    plot(Sf(1,1:round(i*trama)),'Color','r','LineWidth',2, 'DisplayName','Signal 1');
    hold on
    plot(Sf(2,1:round(i*trama)),'Color','g','LineWidth',2, 'DisplayName','Signal 2');
    if handles.ONED.Value == 1 && EDSignal ~= 3
        plot(Y_n(1:round(i*trama)),'Color','b','LineWidth',2, 'DisplayName','ED - Signal 1');
    end
    if handles.ONED.Value == 1 && EDSignal == 3
        plot(Y_n(1,1:round(i*trama)),'Color','b','LineWidth',2, 'DisplayName','ED - Signal 1');
        plot(Y_n(2,1:round(i*trama)),'Color','y','LineWidth',2, 'DisplayName','ED - Signal 2');
    end
    if handles.ONFW.Value == 1 
        plot(filterSignal(1:round(i*trama)),'Color','c','LineWidth',2, 'DisplayName','Fourier filter');
    end
    if handles.ONCONV.Value == 1
        plot(convSignal(1:round(i*trama)),'Color','m','LineWidth',2, 'DisplayName','Convolution filter');
    end    
    hold off    
    axis([0 Nlength -10 10]);
    xlabel('Sample number');
    ylabel('Amplitude');        
    grid on;
    pause(0.05)
end 
    lgd = legend;
%%  Liberar DAQ
release(Session)


% --- Executes on button press in ONCONV.
function ONCONV_Callback(hObject, eventdata, handles)
% hObject    handle to ONCONV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ONCONV



function AConv_Callback(hObject, eventdata, handles)
% hObject    handle to AConv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AConv as text
%        str2double(get(hObject,'String')) returns contents of AConv as a double


% --- Executes during object creation, after setting all properties.
function AConv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AConv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ConvSignal.
function ConvSignal_Callback(hObject, eventdata, handles)
% hObject    handle to ConvSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ConvSignal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ConvSignal


% --- Executes during object creation, after setting all properties.
function ConvSignal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ConvSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
