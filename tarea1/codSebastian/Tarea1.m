function varargout = Tarea1(varargin)
% TAREA1 MATLAB code for Tarea1.fig
%      TAREA1, by itself, creates a new TAREA1 or raises the existing
%      singleton*.
%
%      H = TAREA1 returns the handle to a new TAREA1 or the handle to
%      the existing singleton*.
%
%      TAREA1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TAREA1.M with the given input arguments.
%
%      TAREA1('Property','Value',...) creates a new TAREA1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Tarea1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Tarea1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Tarea1

% Last Modified by GUIDE v2.5 10-Mar-2019 10:28:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Tarea1_OpeningFcn, ...
                   'gui_OutputFcn',  @Tarea1_OutputFcn, ...
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


% --- Executes just before Tarea1 is made visible.
function Tarea1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Tarea1 (see VARARGIN)

% Choose default command line output for Tarea1
handles.output = hObject;

%Logo Univalle
axes(handles.axes15);
imshow('logo.png');

%Desplegar dispositivos de grabación 
global dispDim;
info = audiodevinfo;
dispDim = length(info.input);
set(handles.DispositivoSenal1,'string',info.input(dispDim).Name);
set(handles.DispositivoSenal2,'string',info.input(dispDim).Name);
set(handles.DispositivoSenal3,'string',info.input(dispDim).Name);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Tarea1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = Tarea1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in ComenzarGrabarSenal1.
function ComenzarGrabarSenal1_Callback(hObject, eventdata, handles)
% hObject    handle to ComenzarGrabarSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Capturas parametros de grabación
global Fs1
global CH1
global recorder1
global stereo1;
Fs1 = get(handles.FMSenal1,'Value');
nBits = 8;
CH1 = get(handles.NCanalSenal1,'Value');
switch Fs1
    case 1
        Fs1 = 8000;
    case 2
        Fs1 = 11025;
    case 3
        Fs1 = 22050;
    case 4
        Fs1 = 44100;
    case 5
        Fs1 = 48000;
    case 6
        Fs1 = 96000;
end
switch CH1
    case 1
        CH1 = 1;
        stereo1 = 0;
    case 2
        CH1 = 2;
        stereo1 = 0;
    case 3
        CH1 = 1;
        stereo1 = 1;
end

recorder1 = audiorecorder(Fs1,nBits,1);
record(recorder1);

% --- Executes on button press in PararGrabarSenal1.
function PararGrabarSenal1_Callback(hObject, eventdata, handles)
% hObject    handle to PararGrabarSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global recorder1
global CH1
global Fs1
global y1
global stereo1

stop(recorder1);
y1 = getaudiodata(recorder1)';
if CH1 == 1 && stereo1 == 0
    y1 = vertcat(y1, zeros(1, length(y1)));
elseif CH1 == 2 && stereo1 == 0
    y1 = vertcat(zeros(1, length(y1)), y1);
elseif CH1 == 1 && stereo1 == 1
    y1 = vertcat(y1, y1);
end



%Graficar audio de entrada
RecordTime1 = length(y1)/Fs1;
iteration = Fs1*RecordTime1;
trama = Fs1/16;

%Graficar
axes(handles.senal1);
if CH1 == 1 && stereo1 == 0
    for i = 1 : iteration/trama
        plot(y1(1,1:i*trama),'Color','Red','LineWidth',2);
        hold on
        plot(y1(2,1:i*trama),'Color','Blue','LineWidth',2);
        hold off
        axis([0 iteration -1 1]);
        xlabel('Sample number');
        ylabel('Amplitude');
        grid on;
        pause(0.05)
    end
   
elseif CH1 == 2 && stereo1 == 0 
    for i = 1 : iteration/trama
        plot(y1(2,1:i*trama),'Color','Blue','LineWidth',2);
        hold on
        plot(y1(1,1:i*trama),'Color','Red','LineWidth',2);
        hold off
        axis([0 iteration -1 1]);
        xlabel('Sample number');
        ylabel('Amplitude');
        grid on;
        pause(0.05)
    end
elseif CH1 == 1 && stereo1 == 1
    for i = 1 : iteration/trama
        plot(y1(1,1:i*trama),'Color','Red','LineWidth',2);
        hold on
        plot(y1(2,1:i*trama),'Color','Blue','LineWidth',2);
        hold on
        axis([0 iteration -1 1]);
        xlabel('Sample number');
        ylabel('Amplitude');
        grid on;
        pause(0.05)
    end       
end

% --- Executes on button press in ReproducirSenal1.
function ReproducirSenal1_Callback(hObject, eventdata, handles)
% hObject    handle to ReproducirSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y1
global Fs1

inv = get(handles.InvertirSenal1, 'Value');
mono = get(handles.EstereoSenal1, 'Value');

if mono == 0
    if inv == 0
        recObjPO = audioplayer(y1*get(handles.VolumenSenal1,'Value'),Fs1,8);
        playblocking(recObjPO)
    else
        recObjPO = audioplayer(fliplr(y1)*get(handles.VolumenSenal1,'Value'),Fs1,8);
        playblocking(recObjPO)
    end
else
    %Pasar a mono y normalizar suma
    [l,~] = size(y1);
    if l > 1
        y1_raw = y1(1,:)+y1(2,:);
        maxy1 = max(y1_raw);
        miny1 = min(y1_raw);
        if maxy1 > miny1
            y1_m = y1_raw./maxy1;
        else 
            y1_m = y1_raw./miny1;
        end
    end
        
    if inv == 0
        recObjPO = audioplayer(y1_m*get(handles.VolumenSenal1,'Value'),Fs1,8);
        playblocking(recObjPO)
    else
        recObjPO = audioplayer(fliplr(y1_m)*get(handles.VolumenSenal1,'Value'),Fs1,8);
        playblocking(recObjPO)
    end
end

% --- Executes on button press in ImportarSenal1.
function ImportarSenal1_Callback(hObject, eventdata, handles)
% hObject    handle to ImportarSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in radiobutton3.
global y1;
global Fs1;

file = uigetfile('*.mp3');


[yIn,Fs1] = audioread(file);
y1 = yIn';

%Graficar audio de entrada
RecordTime1 = length(y1)/Fs1;
iteration = Fs1*RecordTime1;
trama = Fs1/16;

%Graficar
axes(handles.senal1);
for i = 1 : iteration/trama
    plot(y1(1,1:i*trama),'Color','Red','LineWidth',2);
    hold on
    plot(y1(2,1:i*trama),'Color','Blue','LineWidth',2);
    hold on
    axis([0 iteration -1 1]);
    xlabel('Sample number');
    ylabel('Amplitude');
    grid on;
    pause(0.05)
end   

% --- Executes on button press in ComenzarGrabarSenal2.
function ComenzarGrabarSenal2_Callback(hObject, eventdata, handles)
% hObject    handle to ComenzarGrabarSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Capturas parametros de grabación
global Fs2
global CH2
global recorder2
global stereo2;
Fs2 = get(handles.FMSenal2,'Value');
nBits = 8;
CH2 = get(handles.NCanalSenal2,'Value');
switch Fs2
    case 1
        Fs2 = 8000;
    case 2
        Fs2 = 11025;
    case 3
        Fs2 = 22050;
    case 4
        Fs2 = 44100;
    case 5
        Fs2 = 48000;
    case 6
        Fs2 = 96000;
end
switch CH2
    case 1
        CH2 = 1;
        stereo2 = 0;
    case 2
        CH2 = 2;
        stereo2 = 0;
    case 3
        CH2 = 1;
        stereo2 = 1;
end

recorder2 = audiorecorder(Fs2,nBits,1);
record(recorder2);

% --- Executes on button press in PararGrabarSenal2.
function PararGrabarSenal2_Callback(hObject, eventdata, handles)
% hObject    handle to PararGrabarSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global recorder2
global CH2
global Fs2
global y2
global stereo2

stop(recorder2);
y2 = getaudiodata(recorder2)';
if CH2 == 1 && stereo2 == 0
    y2 = vertcat(y2, zeros(1, length(y2)));
elseif CH2 == 2 && stereo2 == 0
    y2 = vertcat(zeros(1, length(y2)), y2);
elseif CH2 == 1 && stereo2 == 1
    y2 = vertcat(y2, y2);
end

%Graficar audio de entrada
RecordTime2 = length(y2)/Fs2;
iteration = Fs2*RecordTime2;
trama = Fs2/16;

%Graficar
axes(handles.senal2);
if CH2 == 1 && stereo2 == 0
    for i = 1 : iteration/trama
        plot(y2(1,1:i*trama),'Color','Green','LineWidth',2);
        hold on
        plot(y2(2,1:i*trama),'Color','Yellow','LineWidth',2);
        hold off
        axis([0 iteration -1 1]);
        xlabel('Sample number');
        ylabel('Amplitude');
        grid on;
        pause(0.05)
    end
   
elseif CH2 == 2 && stereo2 == 0 
    for i = 1 : iteration/trama
        plot(y2(2,1:i*trama),'Color','Yellow','LineWidth',2);
        hold on
        plot(y2(1,1:i*trama),'Color','Green','LineWidth',2);
        hold off
        axis([0 iteration -1 1]);
        xlabel('Sample number');
        ylabel('Amplitude');
        grid on;
        pause(0.05)
    end
elseif CH2 == 1 && stereo2 == 1
    for i = 1 : iteration/trama
        plot(y2(1,1:i*trama),'Color','Green','LineWidth',2);
        hold on
        plot(y2(2,1:i*trama),'Color','Yellow','LineWidth',2);
        hold on
        axis([0 iteration -1 1]);
        xlabel('Sample number');
        ylabel('Amplitude');
        grid on;
        pause(0.05)
    end       
end

% --- Executes on button press in ReproducirSenal2.
function ReproducirSenal2_Callback(hObject, eventdata, handles)
% hObject    handle to ReproducirSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y2
global Fs2

inv = get(handles.InvertirSenal2, 'Value');
mono = get(handles.EstereoSenal2, 'Value');

if mono == 0
    if inv == 0
        recObjPO = audioplayer(y2*get(handles.VolumenSenal2,'Value'),Fs2,8);
        playblocking(recObjPO)
    else
        recObjPO = audioplayer(fliplr(y2)*get(handles.VolumenSenal2,'Value'),Fs2,8);
        playblocking(recObjPO)
    end
else
    %Pasar a mono y normalizar suma
    [l,~] = size(y2);
    if l > 1
        y2_raw = y2(1,:)+y2(2,:);
        maxy2 = max(y2_raw);
        miny2 = min(y2_raw);
        if maxy2 > miny2
            y2_m = y2_raw./maxy2;
        else 
            y2_m = y2_raw./miny2;
        end
    end
        
    if inv == 0
        recObjPO = audioplayer(y2_m*get(handles.VolumenSenal2,'Value'),Fs2,8);
        playblocking(recObjPO)
    else
        recObjPO = audioplayer(fliplr(y2_m)*get(handles.VolumenSenal2,'Value'),Fs2,8);
        playblocking(recObjPO)
    end
end

% --- Executes on button press in ImportarSenal2.
function ImportarSenal2_Callback(hObject, eventdata, handles)
% hObject    handle to ImportarSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y2;
global Fs2;

file = uigetfile('*.mp3');

[yIn,Fs2] = audioread(file);
y2 = yIn';

%Graficar audio de entrada
RecordTime2 = length(y2)/Fs2;
iteration = Fs2*RecordTime2;
trama = Fs2/16;

%Graficar
axes(handles.senal2);
for i = 1 : iteration/trama
    plot(y2(1,1:i*trama),'Color','Green','LineWidth',2);
    hold on
    plot(y2(2,1:i*trama),'Color','Yellow','LineWidth',2);
    hold on
    axis([0 iteration -1 1]);
    xlabel('Sample number');
    ylabel('Amplitude');
    grid on;
    pause(0.05)
end  


% --- Executes on button press in ComenzarGrabarSenal3.
function ComenzarGrabarSenal3_Callback(hObject, eventdata, handles)
% hObject    handle to ComenzarGrabarSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Capturas parametros de grabación
global Fs3
global CH3
global recorder3
global stereo3
Fs3 = get(handles.FMSenal3,'Value');
nBits = 8;
CH3 = get(handles.NCanalSenal3,'Value');
switch Fs3
    case 1
        Fs3 = 8000;
    case 2
        Fs3 = 11025;
    case 3
        Fs3 = 22050;
    case 4
        Fs3 = 44100;
    case 5
        Fs3 = 48000;
    case 6
        Fs3 = 96000;
end
switch CH3
    case 1
        CH3 = 1;
        stereo3 = 0;
    case 2
        CH3 = 2;
        stereo3 = 0;
    case 3
        CH3 = 1;
        stereo3 = 1;
end

recorder3 = audiorecorder(Fs3,nBits,1);
record(recorder3);


% --- Executes on button press in PararGrabarSenal3.
function PararGrabarSenal3_Callback(hObject, eventdata, handles)
% hObject    handle to PararGrabarSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global recorder3
global CH3
global Fs3
global y3
global stereo3

stop(recorder3);
y3 = getaudiodata(recorder3)';
if CH3 == 1 && stereo3 == 0
    y3 = vertcat(y3, zeros(1, length(y3)));
elseif CH3 == 2 && stereo3 == 0
    y3 = vertcat(zeros(1, length(y3)), y3);
elseif CH3 == 1 && stereo3 == 1
    y3 = vertcat(y3, y3);
end

%Graficar audio de entrada
RecordTime3 = length(y3)/Fs3;
iteration = Fs3*RecordTime3;
trama = Fs3/16;

%Graficar
axes(handles.senal3);
if CH3 == 1 && stereo3 == 0
    for i = 1 : iteration/trama
        plot(y3(1,1:i*trama),'Color','c','LineWidth',2);
        hold on
        plot(y3(2,1:i*trama),'Color','m','LineWidth',2);
        hold off
        axis([0 iteration -1 1]);
        xlabel('Sample number');
        ylabel('Amplitude');
        grid on;
        pause(0.05)
    end
   
elseif CH3 == 2 && stereo3 == 0 
    for i = 1 : iteration/trama
        plot(y3(2,1:i*trama),'Color','m','LineWidth',2);
        hold on
        plot(y3(1,1:i*trama),'Color','c','LineWidth',2);
        hold off
        axis([0 iteration -1 1]);
        xlabel('Sample number');
        ylabel('Amplitude');
        grid on;
        pause(0.05)
    end
elseif CH3 == 1 && stereo3 == 1
    for i = 1 : iteration/trama
        plot(y3(1,1:i*trama),'Color','c','LineWidth',2);
        hold on
        plot(y3(2,1:i*trama),'Color','m','LineWidth',2);
        hold on
        axis([0 iteration -1 1]);
        xlabel('Sample number');
        ylabel('Amplitude');
        grid on;
        pause(0.05)
    end       
end

% --- Executes on button press in ReproducirSenal3.
function ReproducirSenal3_Callback(hObject, eventdata, handles)
% hObject    handle to ReproducirSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y3
global Fs3

inv = get(handles.InvertirSenal3, 'Value');
mono = get(handles.EstereoSenal3, 'Value');

if mono == 0
    if inv == 0
        recObjPO = audioplayer(y3*get(handles.VolumenSenal3,'Value'),Fs3,8);
        playblocking(recObjPO)
    else
        recObjPO = audioplayer(fliplr(y3)*get(handles.VolumenSenal3,'Value'),Fs3,8);
        playblocking(recObjPO)
    end
else
    %Pasar a mono y normalizar suma
    [l,~] = size(y3);
    if l > 1
        y3_raw = y3(1,:)+y3(2,:);
        maxy3 = max(y3_raw);
        miny3 = min(y3_raw);
        if maxy3 > miny3
            y3_m = y3_raw./maxy3;
        else 
            y3_m = y3_raw./miny3;
        end
    end
        
    if inv == 0
        recObjPO = audioplayer(y3_m*get(handles.VolumenSenal3,'Value'),Fs3,8);
        playblocking(recObjPO)
    else
        recObjPO = audioplayer(fliplr(y3_m)*get(handles.VolumenSenal3,'Value'),Fs3,8);
        playblocking(recObjPO)
    end
end

% --- Executes on button press in ImportarSenal3.
function ImportarSenal3_Callback(hObject, eventdata, handles)
% hObject    handle to ImportarSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y3;
global Fs3;

file = uigetfile('*.mp3');

[yIn,Fs3] = audioread(file);
y3 = yIn';

%Graficar audio de entrada
RecordTime3 = length(y3)/Fs3;
iteration = Fs3*RecordTime3;
trama = Fs3/16;

%Graficar
axes(handles.senal3);
for i = 1 : iteration/trama
    plot(y3(1,1:i*trama),'Color','c','LineWidth',2);
    hold on
    plot(y3(2,1:i*trama),'Color','m','LineWidth',2);
    hold on
    axis([0 iteration -1 1]);
    xlabel('Sample number');
    ylabel('Amplitude');
    grid on;
    pause(0.05)
end  





















function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in FMSenal1.
function FMSenal1_Callback(hObject, eventdata, handles)
% hObject    handle to FMSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FMSenal1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FMSenal1


% --- Executes during object creation, after setting all properties.
function FMSenal1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FMSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in NCanalSenal1.
function NCanalSenal1_Callback(hObject, eventdata, handles)
% hObject    handle to NCanalSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NCanalSenal1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NCanalSenal1


% --- Executes during object creation, after setting all properties.
function NCanalSenal1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NCanalSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9


% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10


% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu12.
function popupmenu12_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu12


% --- Executes during object creation, after setting all properties.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11


% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton11


% --- Executes on slider movement.
function slider11_Callback(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu22.
function popupmenu22_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu22 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu22


% --- Executes during object creation, after setting all properties.
function popupmenu22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu21.
function popupmenu21_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu21 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu21


% --- Executes during object creation, after setting all properties.
function popupmenu21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton40.
function pushbutton40_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton39.
function pushbutton39_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton38.
function pushbutton38_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu23.
function popupmenu23_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu23 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu23


% --- Executes during object creation, after setting all properties.
function popupmenu23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu17.
function popupmenu17_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu17 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu17


% --- Executes during object creation, after setting all properties.
function popupmenu17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function VolumenSenal1_Callback(hObject, eventdata, handles)
% hObject    handle to VolumenSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function VolumenSenal1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VolumenSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in InvertirSenal1.
function InvertirSenal1_Callback(hObject, eventdata, handles)
% hObject    handle to InvertirSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of InvertirSenal1
    


% --- Executes on selection change in DispositivoSenal1.
function DispositivoSenal1_Callback(hObject, eventdata, handles)
% hObject    handle to DispositivoSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DispositivoSenal1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DispositivoSenal1


% --- Executes during object creation, after setting all properties.
function DispositivoSenal1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DispositivoSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in FMSenal3.
function FMSenal3_Callback(hObject, eventdata, handles)
% hObject    handle to FMSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FMSenal3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FMSenal3


% --- Executes during object creation, after setting all properties.
function FMSenal3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FMSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in NCanalSenal3.
function NCanalSenal3_Callback(hObject, eventdata, handles)
% hObject    handle to NCanalSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NCanalSenal3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NCanalSenal3


% --- Executes during object creation, after setting all properties.
function NCanalSenal3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NCanalSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function VolumenSenal3_Callback(hObject, eventdata, handles)
% hObject    handle to VolumenSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function VolumenSenal3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VolumenSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton13


% --- Executes on selection change in DispositivoSenal3.
function DispositivoSenal3_Callback(hObject, eventdata, handles)
% hObject    handle to DispositivoSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DispositivoSenal3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DispositivoSenal3


% --- Executes during object creation, after setting all properties.
function DispositivoSenal3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DispositivoSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in DispositivoSenal2.
function DispositivoSenal2_Callback(hObject, eventdata, handles)
% hObject    handle to DispositivoSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DispositivoSenal2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DispositivoSenal2


% --- Executes during object creation, after setting all properties.
function DispositivoSenal2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DispositivoSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton12


% --- Executes on slider movement.
function VolumenSenal2_Callback(hObject, eventdata, handles)
% hObject    handle to VolumenSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function VolumenSenal2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VolumenSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in NCanalSenal2.
function NCanalSenal2_Callback(hObject, eventdata, handles)
% hObject    handle to NCanalSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NCanalSenal2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NCanalSenal2


% --- Executes during object creation, after setting all properties.
function NCanalSenal2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NCanalSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in FMSenal2.
function FMSenal2_Callback(hObject, eventdata, handles)
% hObject    handle to FMSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FMSenal2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FMSenal2


% --- Executes during object creation, after setting all properties.
function FMSenal2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FMSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in popupmenu34.
function popupmenu34_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu34 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu34


% --- Executes during object creation, after setting all properties.
function popupmenu34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton14


% --- Executes on slider movement.
function VolumenSenalP_Callback(hObject, eventdata, handles)
% hObject    handle to VolumenSenalP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function VolumenSenalP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VolumenSenalP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu33.
function popupmenu33_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu33 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu33


% --- Executes during object creation, after setting all properties.
function popupmenu33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu32.
function popupmenu32_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu32 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu32


% --- Executes during object creation, after setting all properties.
function popupmenu32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton53.
function pushbutton53_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ReproducirSenalP.
function ReproducirSenalP_Callback(hObject, eventdata, handles)
% hObject    handle to ReproducirSenalP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton51.
function pushbutton51_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton50.
function pushbutton50_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in EDSenal.
function EDSenal_Callback(hObject, eventdata, handles)
% hObject    handle to EDSenal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns EDSenal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EDSenal


% --- Executes during object creation, after setting all properties.
function EDSenal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDSenal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A_Callback(hObject, eventdata, handles)
% hObject    handle to A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A as text
%        str2double(get(hObject,'String')) returns contents of A as a double


% --- Executes during object creation, after setting all properties.
function A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function B_Callback(hObject, eventdata, handles)
% hObject    handle to B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of B as text
%        str2double(get(hObject,'String')) returns contents of B as a double


% --- Executes during object creation, after setting all properties.
function B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ci_Callback(hObject, eventdata, handles)
% hObject    handle to Ci (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ci as text
%        str2double(get(hObject,'String')) returns contents of Ci as a double


% --- Executes during object creation, after setting all properties.
function Ci_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ci (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in EDRealizar.
function EDRealizar_Callback(hObject, eventdata, handles)
% hObject    handle to EDRealizar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in SumaSenal1.
function SumaSenal1_Callback(hObject, eventdata, handles)
% hObject    handle to SumaSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SumaSenal1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SumaSenal1


% --- Executes during object creation, after setting all properties.
function SumaSenal1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SumaSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SumaSenal2.
function SumaSenal2_Callback(hObject, eventdata, handles)
% hObject    handle to SumaSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SumaSenal2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SumaSenal2


% --- Executes during object creation, after setting all properties.
function SumaSenal2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SumaSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SumaRealizar.
function SumaRealizar_Callback(hObject, eventdata, handles)
% hObject    handle to SumaRealizar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in EDCanal.
function EDCanal_Callback(hObject, eventdata, handles)
% hObject    handle to EDCanal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns EDCanal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EDCanal


% --- Executes during object creation, after setting all properties.
function EDCanal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDCanal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SumaCanales.
function SumaCanales_Callback(hObject, eventdata, handles)
% hObject    handle to SumaCanales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SumaCanales contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SumaCanales


% --- Executes during object creation, after setting all properties.
function SumaCanales_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SumaCanales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in MultiplicarSenal1.
function MultiplicarSenal1_Callback(hObject, eventdata, handles)
% hObject    handle to MultiplicarSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MultiplicarSenal1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MultiplicarSenal1


% --- Executes during object creation, after setting all properties.
function MultiplicarSenal1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MultiplicarSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in MultiplicarSenal2.
function MultiplicarSenal2_Callback(hObject, eventdata, handles)
% hObject    handle to MultiplicarSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MultiplicarSenal2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MultiplicarSenal2


% --- Executes during object creation, after setting all properties.
function MultiplicarSenal2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MultiplicarSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MultiplicarRealizar.
function MultiplicarRealizar_Callback(hObject, eventdata, handles)
% hObject    handle to MultiplicarRealizar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in PalabraCorrelacion.
function PalabraCorrelacion_Callback(hObject, eventdata, handles)
% hObject    handle to PalabraCorrelacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PalabraCorrelacion contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PalabraCorrelacion


% --- Executes during object creation, after setting all properties.
function PalabraCorrelacion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PalabraCorrelacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ModulacionSenal.
function ModulacionSenal_Callback(hObject, eventdata, handles)
% hObject    handle to ModulacionSenal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ModulacionSenal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ModulacionSenal


% --- Executes during object creation, after setting all properties.
function ModulacionSenal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ModulacionSenal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ModulacionCanal.
function ModulacionCanal_Callback(hObject, eventdata, handles)
% hObject    handle to ModulacionCanal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ModulacionCanal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ModulacionCanal


% --- Executes during object creation, after setting all properties.
function ModulacionCanal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ModulacionCanal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ModulacionFrecuencia_Callback(hObject, eventdata, handles)
% hObject    handle to ModulacionFrecuencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ModulacionFrecuencia as text
%        str2double(get(hObject,'String')) returns contents of ModulacionFrecuencia as a double


% --- Executes during object creation, after setting all properties.
function ModulacionFrecuencia_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ModulacionFrecuencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton22.
function radiobutton22_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton22


% --- Executes on button press in radiobutton23.
function radiobutton23_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton23


% --- Executes on button press in ModulacionRealizar.
function ModulacionRealizar_Callback(hObject, eventdata, handles)
% hObject    handle to ModulacionRealizar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in InvertirSenalP.
function InvertirSenalP_Callback(hObject, eventdata, handles)
% hObject    handle to InvertirSenalP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of InvertirSenalP


% --- Executes on button press in EstereoSenalP.
function EstereoSenalP_Callback(hObject, eventdata, handles)
% hObject    handle to EstereoSenalP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of EstereoSenalP


% --- Executes on button press in InvertirSenal3.
function InvertirSenal3_Callback(hObject, eventdata, handles)
% hObject    handle to InvertirSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of InvertirSenal3


% --- Executes on button press in EstereoSenal3.
function EstereoSenal3_Callback(hObject, eventdata, handles)
% hObject    handle to EstereoSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of EstereoSenal3


% --- Executes on button press in InvertirSenal2.
function InvertirSenal2_Callback(hObject, eventdata, handles)
% hObject    handle to InvertirSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of InvertirSenal2


% --- Executes on button press in EstereoSenal2.
function EstereoSenal2_Callback(hObject, eventdata, handles)
% hObject    handle to EstereoSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of EstereoSenal2


% --- Executes on button press in EstereoSenal1.
function EstereoSenal1_Callback(hObject, eventdata, handles)
% hObject    handle to EstereoSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of EstereoSenal1


% --- Executes on selection change in ModulacionTipo.
function ModulacionTipo_Callback(hObject, eventdata, handles)
% hObject    handle to ModulacionTipo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ModulacionTipo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ModulacionTipo


% --- Executes during object creation, after setting all properties.
function ModulacionTipo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ModulacionTipo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SenalCorrelacion.
function SenalCorrelacion_Callback(hObject, eventdata, handles)
% hObject    handle to SenalCorrelacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SenalCorrelacion contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SenalCorrelacion


% --- Executes during object creation, after setting all properties.
function SenalCorrelacion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SenalCorrelacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in CanalCorrelacion.
function CanalCorrelacion_Callback(hObject, eventdata, handles)
% hObject    handle to CanalCorrelacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CanalCorrelacion contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CanalCorrelacion


% --- Executes during object creation, after setting all properties.
function CanalCorrelacion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CanalCorrelacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RealizarCorrelacion.
function RealizarCorrelacion_Callback(hObject, eventdata, handles)
% hObject    handle to RealizarCorrelacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
