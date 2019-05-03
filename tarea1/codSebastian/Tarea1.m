function varargout = Tarea1(varargin)
% TAREA1 MATLAB code for Tarea1.fig
%      TAREA1, by itself, creates a new TAREA1 or raises the existing
%      singleton*.
%
%      H = TAREA1 returns the handle to a new TAREA1 or the handle to
%      the existing singleton*.
%
%      TAREA1('CALLBACK',hObject,eventData,handles,...) c87¿'09876lls the local
%      function named CALLBACK in TAREA1.M with the given input arguments.
%
%      TAREA1('Property','Value',...) creates a new TAREA1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Tarea1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Tarea1_OpeningFcn via varargin.
%
%      *See GUI Options o|||||||||||||||||||||||||||||||||n GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%*/6*-
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Tarea1

% Last Modified by GUIDE v2.5 28-Apr-2019 23:40:28

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

%Logo
axes(handles.axes15);
imshow('logo.png');

%Volumen
set(handles.NVS1, 'String', num2str(get(handles.VolumenSenal1,'Value')*100));
set(handles.NVS2, 'String', num2str(get(handles.VolumenSenal2,'Value')*100));
set(handles.NVS3, 'String', num2str(get(handles.VolumenSenal3,'Value')*100));
set(handles.NVSP, 'String', num2str(get(handles.VolumenSenalP,'Value')*100));

%Desplegar dispositivos de grabación 
global dispDim;
info = audiodevinfo;
dispDim = length(info.input);

set(handles.VolumenSenal1,'string',info.input(dispDim).Name);
set(handles.VolumenSenal2,'string',info.input(dispDim).Name);
set(handles.VolumenSenal3,'string',info.input(dispDim).Name);
set(handles.VolumenSenalP,'string',info.input(dispDim).Name);
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
        hold off
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

[f,~] = size(y1);

if f == 1
    y1 = vertcat(y1,y1);
end

tround = floor(length(y1)/Fs1);
numSamplesCut = tround*Fs1;
y1 = y1(:,1:numSamplesCut);

%Graficar audio de entrada
RecordTime1 = length(y1)/Fs1;
iteration = Fs1*RecordTime1;
trama = length(y1)/15;

%Graficar
axes(handles.senal1);
for i = 1 : 15
    plot(y1(1,1:round(i*trama)),'Color','Red','LineWidth',2);
    hold on
    plot(y1(2,1:round(i*trama)),'Color','Blue','LineWidth',2);
    hold on
    axis([0 iteration -1 1]);
    xlabel('Sample number');
    ylabel('Amplitude');
    grid on;
    pause(0.05)
end   
hold off
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

[f,~] = size(y2);

if f == 1
    y2 = vertcat(y2,y2);
end

tround = floor(length(y2)/Fs2);
numSamplesCut = tround*Fs2;
y2 = y2(:,1:numSamplesCut);

%Graficar audio de entrada
RecordTime1 = length(y2)/Fs2;
iteration = Fs2*RecordTime1;
trama = length(y2)/15;

%Graficar
axes(handles.senal2);
for i = 1 : 15
    plot(y2(1,1:round(i*trama)),'Color','Green','LineWidth',2);
    hold on
    plot(y2(2,1:round(i*trama)),'Color','Yellow','LineWidth',2);
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

[f,~] = size(y3);

if f == 1
    y3 = vertcat(y3,y3);
end

tround = floor(length(y3)/Fs3);
numSamplesCut = tround*Fs3;
y3 = y3(:,1:numSamplesCut);

%Graficar audio de entrada
RecordTime1 = length(y3)/Fs3;
iteration = Fs3*RecordTime1;
trama = length(y3)/15;

%Graficar
axes(handles.senal3);
for i = 1 : 15
    plot(y3(1,1:round(i*trama)),'Color','c','LineWidth',2);
    hold on
    plot(y3(2,1:round(i*trama)),'Color','m','LineWidth',2);
    hold on
    axis([0 iteration -1 1]);
    xlabel('Sample number');
    ylabel('Amplitude');
    grid on;
    pause(0.05)
end  

% --- Executes on button press in ReproducirSenalP.
function ReproducirSenalP_Callback(hObject, eventdata, handles)
% hObject    handle to ReproducirSenalP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to ReproducirSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Sf
global Fs

inv = get(handles.InvertirSenalP, 'Value');
mono = get(handles.EstereoSenalP, 'Value');

if mono == 0
    if inv == 0
        recObjPO = audioplayer(Sf*get(handles.VolumenSenalP,'Value'),Fs,8);
        playblocking(recObjPO)
    else
        recObjPO = audioplayer(fliplr(Sf)*get(handles.VolumenSenalP,'Value'),Fs,8);
        playblocking(recObjPO)
    end
else
    %Pasar a mono y normalizar suma
    [l,~] = size(Sf);
    if l > 1
        yp_raw = Sf(1,:)+Sf(2,:);
        maxyp = max(yp_raw);
        minyp = min(yp_raw);
        if maxyp > minyp
            yp_m = yp_raw./maxyp;
        else 
            yp_m = yp_raw./minyp;
        end
    end
        
    if inv == 0
        recObjPO = audioplayer(yp_m*get(handles.VolumenSenalP,'Value'),Fs,8);
        playblocking(recObjPO)
    else
        recObjPO = audioplayer(fliplr(yp_m)*get(handles.VolumenSenalP,'Value'),Fs,8);
        playblocking(recObjPO)
    end
end

% --- Executes on button press in EDRealizar.
function EDRealizar_Callback(hObject, eventdata, handles)
% hObject    handle to EDRealizar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Sf
global Fs

EDSignal = get(handles.EDSenal,'Value');
EDChannel = get(handles.EDCanal,'Value');

switch EDSignal
    case 1
        global y1
        global Fs1
        In = y1;
        Fs = Fs1;
    case 2
        global y2
        global Fs2
        In = y2;
        Fs = Fs2;
    case 3
        global y3
        global Fs3
        In = y3;
        Fs = Fs3;
end

A1 = str2num(get(handles.CA, 'string'));
B = str2num(get(handles.CB, 'string'));
Ci = str2num(get(handles.CCi, 'string'));
N = length(A1) - 1;
M = length(B) - 1;

switch EDChannel
    case 1
        X = horzcat(zeros(1,M),In(1,:));
        Y1 = horzcat(fliplr(Ci(1:N)), zeros(1,length(X) - M));
        A = A1./A1(1);
        A = A(2:end);
        B = B./A1(1);
        j = M + 1;
        for i = N + 1:length(Y1)
            aux = fliplr(Y1(i - N:i-1));
            aux2 = fliplr(X(1,j - M:j));
            Y1(i) = -sum(aux.*A) + sum(aux2.*B);
            j = j + 1;
        end
        
        [Y1_n,~] = mapminmax(Y1);
        Yt = vertcat(Y1_n(N+1:end), In(2,:));
       
    case 2
        X = horzcat(zeros(1,M),In(2,:));
        Y2 = horzcat(fliplr(Ci(1:N)), zeros(1,length(X) - M));
        A = A1./A1(1);
        A = A(2:end);
        B = B./A1(1);
        j = M + 1;
        for i = N + 1:length(Y2)
            aux = fliplr(Y2(i - N:i-1));
            aux2 = fliplr(X(1,j - M:j));
            Y2(i) = -sum(aux.*A) + sum(aux2.*B);
            j = j + 1;
        end        
        
        [Y2_n,~] = mapminmax(Y2);
        Yt = vertcat(In(1,:), Y2_n(N+1:end));
        
    case 3
        X = horzcat(zeros(1,M),In(1,:));
        Y1 = horzcat(fliplr(Ci(1:N)), zeros(1,length(X) - M));
        A = A1./A1(1);
        A = A(2:end);
        B = B./A1(1);
        j = M + 1;
        for i = N + 1:length(Y1)
            aux = fliplr(Y1(i - N:i-1));
            aux2 = fliplr(X(1,j - M:j));
            Y1(i) = -sum(aux.*A) + sum(aux2.*B);
            j = j + 1;
        end

        X = horzcat(zeros(1,M),In(2,:));
        Y2 = horzcat(fliplr(Ci(1:N)), zeros(1,length(X) - M));
        A = A1./A1(1);
        A = A(2:end);
        B = B./A1(1);
        j = M + 1;
        for i = N + 1:length(Y2)
            aux = fliplr(Y2(i - N:i-1));
            aux2 = fliplr(X(1,j - M:j));
            Y2(i) = -sum(aux.*A) + sum(aux2.*B);
            j = j + 1;
        end
        
        [Y1_n,~] = mapminmax(Y1);
        [Y2_n,~] = mapminmax(Y2);
        
        Yt = vertcat(Y1_n(N+1:end), Y2_n(N+1:end));
end

%Graficar audio de entrada
RecordTime = length(Yt(1,:))/Fs;
iteration = Fs*RecordTime;
trama = length(Yt)/15;
Sf = Yt;

%Graficar
axes(handles.senal4);
for i = 1 : 15
    plot(Sf(1,1:round(i*trama)),'Color','r','LineWidth',2);
    hold on
    plot(Sf(2,1:round(i*trama)),'Color','y','LineWidth',2);
    hold off
    axis([0 iteration -1 1]);
    xlabel('Sample number');
    ylabel('Amplitude');
    grid on;
    pause(0.05)
end 

% --- Executes on button press in SumaRealizar.
function SumaRealizar_Callback(hObject, eventdata, handles)
% hObject    handle to SumaRealizar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Sf
global Fs

Signal1 = get(handles.SumaSenal1,'Value');
Signal2 = get(handles.SumaSenal2,'Value');
Signal1Channel = get(handles.SumaCanalSenal1,'Value');
Signal2Channel = get(handles.SumaCanalSenal2,'Value');

global y1
global Fs1
global y2
global Fs2
global y3
global Fs3
        
switch Signal1
    case 1        
        Y1 = y1;
        FsY1 = Fs1;
    case 2        
        Y1 = y2;
        FsY1 = Fs2;
    case 3       
        Y1 = y3;
        FsY1 = Fs3;
end

switch Signal2
    case 1
        Y2 = y1;
        FsY2 = Fs1;
    case 2
        Y2 = y2;
        FsY2 = Fs2;
    case 3
        Y2 = y3;
        FsY2 = Fs3;
end

switch Signal1Channel
    case 1
        Y1 = vertcat(Y1(1,:),zeros(1,length(Y1(1,:))));
        disp('Señal 1 CH1');
    case 2
        Y1 = vertcat(zeros(1,length(Y1(1,:))), Y1(2,:));
        disp('Señal 1 CH2');
end   

switch Signal2Channel
    case 1
        Y2 = vertcat(Y2(1,:),zeros(1,length(Y2(1,:))));
        disp('Señal 2 CH1');
    case 2
        Y2 = vertcat(zeros(1,length(Y2(1,:))), Y2(2,:));
        disp('Señal 2 CH2');
end  

%Igualar frecuencias
if FsY1 > FsY2
    originalFs = FsY1;
    desiredFs = FsY2;
    [p,q] = rat(desiredFs / originalFs);
    Y1_s1 = resample(Y1(1,:),p,q);
    Y1_s2 = resample(Y1(2,:),p,q);
    Y1_s = vertcat(Y1_s1, Y1_s2);
    Y2_s = Y2;
    Fs = FsY2;
elseif FsY1 < FsY2
    originalFs = FsY2;
    desiredFs = FsY1;
    [p,q] = rat(desiredFs / originalFs);
    Y2_s1 = resample(Y2(1,:),p,q);
    Y2_s2 = resample(Y2(2,:),p,q);
    Y2_s = vertcat(Y2_s1, Y2_s2);
    Y1_s = Y1;
    Fs = FsY1;
else
    Y1_s1 = Y1(1,:);
    Y1_s2 = Y1(2,:);
    Y2_s1 = Y2(1,:);
    Y2_s2 = Y2(2,:);
    Y1_s = vertcat(Y1_s1, Y1_s2);
    Y2_s = vertcat(Y2_s1, Y2_s2);
    Fs = FsY1;
end 

%Igualar tiempos
if length(Y1_s(1,:)) > length(Y2_s(1,:))
   Y2_IGU = horzcat(Y2_s, zeros(2, length(Y1_s(1,:)) - length(Y2_s(1,:))));
   Yt = Y1_s + Y2_IGU;
elseif length(Y1_s(1,:)) < length(Y2_s(1,:))
   Y1_IGU = horzcat(Y1_s, zeros(2, length(Y2_s(1,:)) - length(Y1_s(1,:))));
   Yt = Y2_s + Y1_IGU;
else
   Yt = Y2_s + Y1_s;
end

[Sf,~] = mapminmax(Yt);

%Graficar audio de entrada
RecordTime = length(Yt(1,:))/Fs;
iteration = Fs*RecordTime;
trama = length(Sf)/15;

%Graficar
axes(handles.senal4);
for i = 1 : 15
    plot(Sf(1,1:round(i*trama)),'Color','r','LineWidth',2);
    hold on
    plot(Sf(2,1:round(i*trama)),'Color','y','LineWidth',2);
    hold off
    axis([0 iteration -1 1]);
    xlabel('Sample number');
    ylabel('Amplitude');
    grid on;
    pause(0.05)
end 

% --- Executes on button press in MultiplicarRealizar.
function MultiplicarRealizar_Callback(hObject, eventdata, handles)
% hObject    handle to MultiplicarRealizar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Sf
global Fs

Signal1 = get(handles.MultiplicarSenal1,'Value');
Signal2 = get(handles.MultiplicarSenal2,'Value');
Signal1Channel = get(handles.MultiplicarCanalSenal1,'Value');
Signal2Channel = get(handles.MultiplicarCanalSenal2,'Value');

global y1
global Fs1
global y2
global Fs2
global y3
global Fs3
        
switch Signal1
    case 1        
        Y1 = y1;
        FsY1 = Fs1;
    case 2        
        Y1 = y2;
        FsY1 = Fs2;
    case 3       
        Y1 = y3;
        FsY1 = Fs3;
end

switch Signal2
    case 1
        Y2 = y1;
        FsY2 = Fs1;
    case 2
        Y2 = y2;
        FsY2 = Fs2;
    case 3
        Y2 = y3;
        FsY2 = Fs3;
end

%Igualar frecuencias
if FsY1 > FsY2
    originalFs = FsY1;
    desiredFs = FsY2;
    [p,q] = rat(desiredFs / originalFs);
    Y1_s1 = resample(Y1(1,:),p,q);
    Y1_s2 = resample(Y1(2,:),p,q);
    Y1_s = vertcat(Y1_s1, Y1_s2);
    Y2_s = Y2;
    Fs = FsY2;
elseif FsY1 < FsY2
    originalFs = FsY2;
    desiredFs = FsY1;
    [p,q] = rat(desiredFs / originalFs);
    Y2_s1 = resample(Y2(1,:),p,q);
    Y2_s2 = resample(Y2(2,:),p,q);
    Y2_s = vertcat(Y2_s1, Y2_s2);
    Y1_s = Y1;
    Fs = FsY1;
else
    Y1_s1 = Y1(1,:);
    Y1_s2 = Y1(2,:);
    Y2_s1 = Y2(1,:);
    Y2_s2 = Y2(2,:);
    Y1_s = vertcat(Y1_s1, Y1_s2);
    Y2_s = vertcat(Y2_s1, Y2_s2);
    Fs = FsY1;
end 

%Igualar tiempos
if length(Y1_s(1,:)) > length(Y2_s(1,:))
   Y2_s = horzcat(Y2_s, zeros(2, length(Y1_s(1,:)) - length(Y2_s(1,:))));
elseif length(Y1_s(1,:)) < length(Y2_s(1,:))
   Y1_s = horzcat(Y1_s, zeros(2, length(Y2_s(1,:)) - length(Y1_s(1,:))));
else
    disp('dimensión igual');
end

switch Signal1Channel
    case 1
        CHS1 = 1;
    case 2
        CHS1 = 2;
    case 3
        CHS1 = 3;
end   

switch Signal2Channel
    case 1
        CHS2 = 1;
    case 2
        CHS2 = 2;
    case 3
        CHS2 = 3;
end  

if CHS1 ~= 3 && CHS2 ~=3
    Yt1 = Y1_s(CHS1,:) .* Y2_s(CHS2,:);
    Yt2 = Y1_s(CHS1,:) .* Y2_s(CHS2,:);
    Yt = vertcat(Yt1, Yt2);
elseif CHS1 == 3 && CHS2 ~=3
    Yt1 = Y1_s(1,:) .* Y2_s(CHS2,:);
    Yt2 = Y1_s(2,:) .* Y2_s(CHS2,:);
    Yt = vertcat(Yt1, Yt2);
elseif CHS1 ~= 3 && CHS2 ==3
    Yt1 = Y2_s(1,:) .* Y1_s(CHS1,:);
    Yt2 = Y2_s(2,:) .* Y1_s(CHS1,:);
    Yt = vertcat(Yt1, Yt2);
else
    Yt1 = Y2_s(1,:) .* Y1_s(1,:);
    Yt2 = Y2_s(2,:) .* Y1_s(2,:);
    Yt = vertcat(Yt1, Yt2);
end

[Sf,~] = mapminmax(Yt);

%Graficar audio de entrada
RecordTime = length(Yt(1,:))/Fs;
iteration = Fs*RecordTime;
trama = length(Sf)/15;

%Graficar
axes(handles.senal4);
for i = 1 : 15
    plot(Sf(1,1:round(i*trama)),'Color','r','LineWidth',2);
    hold on
    plot(Sf(2,1:round(i*trama)),'Color','y','LineWidth',2);
    hold off
    axis([0 iteration -1 1]);
    xlabel('Sample number');
    ylabel('Amplitude');
    grid on;
    pause(0.05)
end 

% --- Executes on button press in ModulacionRealizar.
function ModulacionRealizar_Callback(hObject, eventdata, handles)
% hObject    handle to ModulacionRealizar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Sf
global Fs

signal = get(handles.ModulacionSenal,'Value');
ch = get(handles.ModulacionCanal,'Value');
Fm = str2num(get(handles.ModulacionFrecuencia, 'string'));
Metodo = get(handles.ModulacionTipo,'Value');

global y1
global Fs1
global y2
global Fs2
global y3
global Fs3
        
switch signal
    case 1        
        Y1 = y1;
        Fs = Fs1;
    case 2        
        Y1 = y2;
        Fs = Fs2;
    case 3       
        Y1 = y3;
        Fs = Fs3;
end

switch ch
    case 1
        CHS = 1;
    case 2
        CHS = 2;
    case 3
        CHS = 3;
end 

if CHS == 1
    Y = vertcat(Y1(1,:),zeros(1,length(Y1(1,:))));
elseif CHS == 2
    Y = vertcat(zeros(1,length(Y1(1,:))), Y1(2,:));
else
    Y = Y1;
end

switch Metodo
    case 1
        t = 1:1/(length(Y(1,:))-1):2;
        c = sin(2*pi*Fm*t);
        %modulacion
        Yt1 = Y(1,:) .* c;
        Yt2 = Y(2,:) .* c;
        Yt = vertcat(Yt1, Yt2);
        
    case 2
        t = 1:1/(length(Y(1,:))-1):2;
        c = sawtooth(Fm*t);
        %modulacion
        Yt1 = Y(1,:) .* c;
        Yt2 = Y(2,:) .* c;
        Yt = vertcat(Yt1, Yt2);
end

[Sf,~] = mapminmax(Yt);

%Graficar audio de entrada
RecordTime = length(Yt(1,:))/Fs;
iteration = Fs*RecordTime;
trama = length(Sf)/15;

%Graficar
axes(handles.senal4);
for i = 1 : 15
    plot(Sf(1,1:round(i*trama)),'Color','r','LineWidth',2);
    hold on
    plot(Sf(2,1:round(i*trama)),'Color','y','LineWidth',2);
    hold off
    axis([0 iteration -1 1]);
    xlabel('Sample number');
    ylabel('Amplitude');
    grid on;
    pause(0.05)
end 


% --- Executes on button press in RealizarCorrelacion.
function RealizarCorrelacion_Callback(hObject, eventdata, handles)
% hObject    handle to RealizarCorrelacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function VolumenSenal1_Callback(hObject, eventdata, handles)
% hObject    handle to VolumenSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.NVS1, 'String', num2str(round(get(handles.VolumenSenal1,'Value')*100)));


% --- Executes on slider movement.
function VolumenSenal2_Callback(hObject, eventdata, handles)
% hObject    handle to VolumenSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.NVS2, 'String', num2str(round(get(handles.VolumenSenal2,'Value')*100)));

% --- Executes on slider movement.
function VolumenSenal3_Callback(hObject, eventdata, handles)
% hObject    handle to VolumenSenal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.NVS3, 'String', num2str(round(get(handles.VolumenSenal3,'Value')*100)));

% --- Executes on slider movement.
function VolumenSenalP_Callback(hObject, eventdata, handles)
% hObject    handle to VolumenSenalP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.NVSP, 'String', num2str(round(get(handles.VolumenSenalP,'Value')*100)));

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


% --- Executes on selection change in SumaCanalSenal1.
function SumaCanalSenal1_Callback(hObject, eventdata, handles)
% hObject    handle to SumaCanalSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SumaCanalSenal1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SumaCanalSenal1


% --- Executes during object creation, after setting all properties.
function SumaCanalSenal1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SumaCanalSenal1 (see GCBO)
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

function CA_Callback(hObject, eventdata, handles)
% hObject    handle to CA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CA as text
%        str2double(get(hObject,'String')) returns contents of CA as a double


% --- Executes during object creation, after setting all properties.
function CA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CB_Callback(hObject, eventdata, handles)
% hObject    handle to CB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CB as text
%        str2double(get(hObject,'String')) returns contents of CB as a double


% --- Executes during object creation, after setting all properties.
function CB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CCi_Callback(hObject, eventdata, handles)
% hObject    handle to CCi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CCi as text
%        str2double(get(hObject,'String')) returns contents of CCi as a double


% --- Executes during object creation, after setting all properties.
function CCi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CCi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SumaCanalSenal2.
function SumaCanalSenal2_Callback(hObject, eventdata, handles)
% hObject    handle to SumaCanalSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SumaCanalSenal2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SumaCanalSenal2


% --- Executes during object creation, after setting all properties.
function SumaCanalSenal2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SumaCanalSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in MultiplicarCanalSenal1.
function MultiplicarCanalSenal1_Callback(hObject, eventdata, handles)
% hObject    handle to MultiplicarCanalSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MultiplicarCanalSenal1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MultiplicarCanalSenal1


% --- Executes during object creation, after setting all properties.
function MultiplicarCanalSenal1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MultiplicarCanalSenal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in MultiplicarCanalSenal2.
function MultiplicarCanalSenal2_Callback(hObject, eventdata, handles)
% hObject    handle to MultiplicarCanalSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MultiplicarCanalSenal2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MultiplicarCanalSenal2


% --- Executes during object creation, after setting all properties.
function MultiplicarCanalSenal2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MultiplicarCanalSenal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SWsignal1.
function SWsignal1_Callback(hObject, eventdata, handles)
% hObject    handle to SWsignal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y1;
global Fs1;

N = length(y1);
datafft=fft(y1);
datafft_abs1=abs(datafft(1,:)/N);
datafft_abs1=datafft_abs1(1:N/2+1);
datafft_abs2=abs(datafft(2,:)/N);
datafft_abs2=datafft_abs2(1:N/2+1);
datafft_abs = vertcat(datafft_abs1, datafft_abs2);
f=Fs1*(0:N/2)/N;

figure;
plot(f,datafft_abs(1,:), 'r')
hold on
plot(f,datafft_abs(2,:), 'b')
hold off
grid on;
xlabel('Frequency [Hz]')
ylabel('Amplitude')
title('FFT SIGNAL 1 - Mag');

% --- Executes on button press in SWSignal3.
function SWSignal3_Callback(hObject, eventdata, handles)
% hObject    handle to SWSignal3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y3;
global Fs3;

N = length(y3);
datafft=fft(y3);
datafft_abs1=abs(datafft(1,:)/N);
datafft_abs1=datafft_abs1(1:N/2+1);
datafft_abs2=abs(datafft(2,:)/N);
datafft_abs2=datafft_abs2(1:N/2+1);
datafft_abs = vertcat(datafft_abs1, datafft_abs2);
f=Fs3*(0:N/2)/N;

figure;
plot(f,datafft_abs(1,:), 'c')
hold on
plot(f,datafft_abs(2,:), 'm')
hold off
grid on;
xlabel('Frequency [Hz]')
ylabel('Amplitude')
title('FFT SIGNAL 3 - Mag');
% subplot(1,2,2);
% plot(f,phs/pi)
% grid on;
% xlabel('Frequency [Hz]')
% ylabel('Phase / \pi')
% title('FFT SIGNAL 3- Angle');

% --- Executes on button press in SWSignal4.
function SWSignal4_Callback(hObject, eventdata, handles)
% hObject    handle to SWSignal4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Sf;
global Fs;

N = length(Sf);
datafft=fft(Sf);
datafft_abs1=abs(datafft(1,:)/N);
datafft_abs1=datafft_abs1(1:N/2+1);
datafft_abs2=abs(datafft(2,:)/N);
datafft_abs2=datafft_abs2(1:N/2+1);
datafft_abs = vertcat(datafft_abs1, datafft_abs2);
f=Fs*(0:N/2)/N;

figure;
plot(f,datafft_abs(1,:), 'r')
hold on
plot(f,datafft_abs(2,:), 'y')
hold off
grid on;
xlabel('Frequency [Hz]')
ylabel('Amplitude')
title('FFT SIGNAL 4 - Mag');

% --- Executes on button press in SWSignal2.
function SWSignal2_Callback(hObject, eventdata, handles)
% hObject    handle to SWSignal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y2;
global Fs2;

N = length(y2);
datafft=fft(y2);
datafft_abs1=abs(datafft(1,:)/N);
datafft_abs1=datafft_abs1(1:N/2+1);
datafft_abs2=abs(datafft(2,:)/N);
datafft_abs2=datafft_abs2(1:N/2+1);
datafft_abs = vertcat(datafft_abs1, datafft_abs2);
f=Fs2*(0:N/2)/N;

figure;
plot(f,datafft_abs(1,:), 'g')
hold on
plot(f,datafft_abs(2,:), 'y')
hold off
grid on;
xlabel('Frequency [Hz]')
ylabel('Amplitude')
title('FFT SIGNAL 2 - Mag');

% --- Executes on button press in LPFilter.
function LPFilter_Callback(hObject, eventdata, handles)
% hObject    handle to LPFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of LPFilter
if get(handles.LPFilter,'Value') == 1
    buttons_list = [handles.BPFilter, handles.HPFilter];
    set(buttons_list, 'Value', 0);
    set(handles.FCI,'Enable','on')
    set(handles.FCS,'Enable','off')
end

% --- Executes on button press in BPFilter.
function BPFilter_Callback(hObject, eventdata, handles)
% hObject    handle to BPFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of BPFilter
if get(handles.BPFilter,'Value') == 1
    buttons_list = [handles.LPFilter, handles.HPFilter];
    set(buttons_list, 'Value', 0);
    set(handles.FCI,'Enable','on')
    set(handles.FCS,'Enable','on')
end

% --- Executes on button press in HPFilter.
function HPFilter_Callback(hObject, eventdata, handles)
% hObject    handle to HPFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of HPFilter
if get(handles.HPFilter,'Value') == 1
    buttons_list = [handles.BPFilter, handles.LPFilter];
    set(buttons_list, 'Value', 0);
    set(handles.FCI,'Enable','off')
    set(handles.FCS,'Enable','on')
end

% --- Executes on selection change in FilterType.
function FilterType_Callback(hObject, eventdata, handles)
% hObject    handle to FilterType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FilterType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FilterType


% --- Executes during object creation, after setting all properties.
function FilterType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in FilterSignal.
function FilterSignal_Callback(hObject, eventdata, handles)
% hObject    handle to FilterSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FilterSignal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FilterSignal


% --- Executes during object creation, after setting all properties.
function FilterSignal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PFilter.
function PFilter_Callback(hObject, eventdata, handles)
% hObject    handle to PFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Fs;
global Sf;

FCI = str2num(get(handles.FCI, 'string'));
FCS = str2num(get(handles.FCS, 'string'));
FilterSignal = get(handles.FilterSignal, 'Value');
FilterSignalChannel = get(handles.FilterSignalChannel, 'Value');
TipoFil = get(handles.FilterType,'Value');

%Cargar variables globales
switch FilterSignal
    case 1
        global y1;
        global Fs1;
    case 2
        global y2;
        global Fs2;
    case 3
        global y3;
        global Fs3;
end

%-----------------FILTRO PASO BAJO--------------------------------------
if get(handles.LPFilter,'Value') == 1 %Tipo LP 

    switch TipoFil %-----------------------TIPO DE FILTRO-------------
        case 1 %FIR
            a = 1;  
            switch FilterSignal %Señal 
                case 1
                    Fs = Fs1;
                    lpFilt = designfilt('lowpassfir','PassbandFrequency',FCI/(Fs1/2), ...
         'StopbandFrequency',(FCI/(Fs1/2))+0.1,'PassbandRipple',0.5, ...
         'StopbandAttenuation',65,'DesignMethod','kaiserwin');
                case 2
                    Fs = Fs2;
                    lpFilt = designfilt('lowpassfir','PassbandFrequency',FCI/(Fs2/2), ...
         'StopbandFrequency',(FCI/(Fs2/2))+0.1,'PassbandRipple',0.5, ...
         'StopbandAttenuation',65,'DesignMethod','kaiserwin');
                case 3
                    Fs = Fs3;
                    lpFilt = designfilt('lowpassfir','PassbandFrequency',FCI/(Fs3/2), ...
         'StopbandFrequency',(FCI/(Fs3/2))+0.1  ,'PassbandRipple',0.5, ...
         'StopbandAttenuation',65,'DesignMethod','kaiserwin');
            end        
        case 2 %Butter
            a = 0;
            switch FilterSignal %Señal 
                case 1
                    Fs = Fs1;
                    [num,den] = butter(6,FCI/(Fs1/2), 'low'); 
                case 2
                    Fs = Fs2;
                    [num,den] = butter(6,FCI/(Fs2/2), 'low'); 
                case 3
                    Fs = Fs3;
                    [num,den] = butter(6,FCI/(Fs3/2), 'low'); 
            end            
        case 3 %Chevy
            a = 0;
            switch FilterSignal %Señal 
                case 1
                    Fs = Fs1;
                    [num,den] = cheby2(6,40,FCI/(Fs1/2), 'low');
                case 2
                    Fs = Fs2;
                    [num,den] = cheby2(6,40,FCI/(Fs2/2), 'low');
                case 3
                    Fs = Fs3;
                    [num,den] = cheby2(6,40,FCI/(Fs3/2), 'low');
            end            
    end    
      
    switch FilterSignal %Señal ----------------APLICACION EN LA SEÑAL-----
        case 1
            switch FilterSignalChannel 
                case 1 %Canal 1
                    if a == 0
                        filterSignal1 = filter(num,den,y1(1,:));
                        Sf = vertcat(filterSignal1, y1(2,:));
                    else
                        filterSignal1 = filter(lpFilt,y1(1,:));
                        Sf = vertcat(filterSignal1, y1(2,:));
                    end
                case 2 %Canal 2
                    if a == 0
                        filterSignal2 = filter(num,den,y1(2,:));
                        Sf = vertcat(y1(1,:), filterSignal2);
                    else
                        filterSignal2 = filter(lpFilt,y1(2,:));
                        Sf = vertcat(y1(1,:), filterSignal2);
                    end
                case 3 %Ambos canales
                    if a == 0
                        filterSignal1 = filter(num,den,y1(1,:));
                        filterSignal2 = filter(num,den,y1(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    else
                        filterSignal1 = filter(lpFilt,y1(1,:));
                        filterSignal2 = filter(lpFilt,y1(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    end
            end
        case 2
            switch FilterSignalChannel 
                case 1 %Canal 1
                    if a == 0
                        filterSignal1 = filter(num,den,y2(1,:));
                        Sf = vertcat(filterSignal1, y2(2,:));
                    else
                        filterSignal1 = filter(lpFilt,y2(1,:));
                        Sf = vertcat(filterSignal1, y2(2,:));
                    end
                case 2 %Canal 2
                    if a == 0
                        filterSignal2 = filter(num,den,y2(2,:));
                        Sf = vertcat(y2(1,:), filterSignal2);
                    else
                        filterSignal2 = filter(lpFilt,y2(2,:));
                        Sf = vertcat(y2(1,:), filterSignal2);
                    end
                case 3 %Ambos canales
                    if a == 0
                        filterSignal1 = filter(num,den,y2(1,:));
                        filterSignal2 = filter(num,den,y2(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    else
                        filterSignal1 = filter(lpFilt,y2(1,:));
                        filterSignal2 = filter(lpFilt,y2(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    end
            end
        case 3
            switch FilterSignalChannel 
                case 1 %Canal 1
                    if a == 0
                        filterSignal1 = filter(num,den,y3(1,:));
                        Sf = vertcat(filterSignal1, y3(2,:));
                    else
                        filterSignal1 = filter(lpFilt,y3(1,:));
                        Sf = vertcat(filterSignal1, y3(2,:));
                    end
                case 2 %Canal 2
                    if a == 0
                        filterSignal2 = filter(num,den,y3(2,:));
                        Sf = vertcat(y3(1,:), filterSignal2);
                    else
                        filterSignal2 = filter(lpFilt,y3(2,:));
                        Sf = vertcat(y3(1,:), filterSignal2);
                    end
                case 3 %Ambos canales
                    if a == 0
                        filterSignal1 = filter(num,den,y3(1,:));
                        filterSignal2 = filter(num,den,y3(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    else
                        filterSignal1 = filter(lpFilt,y3(1,:));
                        filterSignal2 = filter(lpFilt,y3(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    end
            end
    end
    
%-----------------FILTRO BANDA PASO--------------------------------------    
elseif get(handles.BPFilter,'Value') == 1 %Tipo BP
    
    switch TipoFil %-----------------------TIPO DE FILTRO-------------
        case 1 %FIR
            a = 1;  
            switch FilterSignal %Señal 
                case 1
                    Fs = Fs1;
                    bpFilt = designfilt('bandpassfir','FilterOrder',20, ...
         'CutoffFrequency1',FCI,'CutoffFrequency2',FCS, ...
         'SampleRate',Fs1);
                case 2
                    Fs = Fs2;
                    bpFilt = designfilt('bandpassfir','FilterOrder',20, ...
         'CutoffFrequency1',FCI,'CutoffFrequency2',FCS, ...
         'SampleRate',Fs2);
                case 3
                    Fs = Fs3;
                    bpFilt = designfilt('bandpassfir','FilterOrder',20, ...
         'CutoffFrequency1',FCI,'CutoffFrequency2',FCS, ...
         'SampleRate',Fs3);
            end        
        case 2 %Butter
            a = 0;
            switch FilterSignal %Señal 
                case 1
                    Fs = Fs1;
                    [num,den] = butter(6,[FCI FCS]/(Fs1/2), 'bandpass'); 
                case 2
                    Fs = Fs2;
                    [num,den] = butter(6,[FCI FCS]/(Fs2/2), 'bandpass'); 
                case 3
                    Fs = Fs3;
                    [num,den] = butter(6,[FCI FCS]/(Fs3/2), 'bandpass'); 
            end            
        case 3 %Chevy
            a = 0;
            switch FilterSignal %Señal 
                case 1
                    Fs = Fs1;
                    [num,den] = cheby2(6,40,[FCI FCS]/(Fs1/2), 'bandpass');
                case 2
                    Fs = Fs2;
                    [num,den] = cheby2(6,40,[FCI FCS]/(Fs2/2), 'bandpass');
                case 3
                    Fs = Fs3;
                    [num,den] = cheby2(6,40,[FCI FCS]/(Fs3/2), 'bandpass');
            end            
    end    
      
    switch FilterSignal %Señal ----------------APLICACION EN LA SEÑAL-----
        case 1
            switch FilterSignalChannel 
                case 1 %Canal 1
                    if a == 0
                        filterSignal1 = filter(num,den,y1(1,:));
                        Sf = vertcat(filterSignal1, y1(2,:));
                    else
                        filterSignal1 = filter(bpFilt,y1(1,:));
                        Sf = vertcat(filterSignal1, y1(2,:));
                    end
                case 2 %Canal 2
                    if a == 0
                        filterSignal2 = filter(num,den,y1(2,:));
                        Sf = vertcat(y1(1,:), filterSignal2);
                    else
                        filterSignal2 = filter(bpFilt,y1(2,:));
                        Sf = vertcat(y1(1,:), filterSignal2);
                    end
                case 3 %Ambos canales
                    if a == 0
                        filterSignal1 = filter(num,den,y1(1,:));
                        filterSignal2 = filter(num,den,y1(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    else
                        filterSignal1 = filter(bpFilt,y1(1,:));
                        filterSignal2 = filter(bpFilt,y1(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    end
            end
        case 2
            switch FilterSignalChannel 
                case 1 %Canal 1
                    if a == 0
                        filterSignal1 = filter(num,den,y2(1,:));
                        Sf = vertcat(filterSignal1, y2(2,:));
                    else
                        filterSignal1 = filter(bpFilt,y2(1,:));
                        Sf = vertcat(filterSignal1, y2(2,:));
                    end
                case 2 %Canal 2
                    if a == 0
                        filterSignal2 = filter(num,den,y2(2,:));
                        Sf = vertcat(y2(1,:), filterSignal2);
                    else
                        filterSignal2 = filter(bpFilt,y2(2,:));
                        Sf = vertcat(y2(1,:), filterSignal2);
                    end
                case 3 %Ambos canales
                    if a == 0
                        filterSignal1 = filter(num,den,y2(1,:));
                        filterSignal2 = filter(num,den,y2(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    else
                        filterSignal1 = filter(bpFilt,y2(1,:));
                        filterSignal2 = filter(bpFilt,y2(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    end
            end
        case 3
            switch FilterSignalChannel 
                case 1 %Canal 1
                    if a == 0
                        filterSignal1 = filter(num,den,y3(1,:));
                        Sf = vertcat(filterSignal1, y3(2,:));
                    else
                        filterSignal1 = filter(bpFilt,y3(1,:));
                        Sf = vertcat(filterSignal1, y3(2,:));
                    end
                case 2 %Canal 2
                    if a == 0
                        filterSignal2 = filter(num,den,y3(2,:));
                        Sf = vertcat(y3(1,:), filterSignal2);
                    else
                        filterSignal2 = filter(bpFilt,y3(2,:));
                        Sf = vertcat(y3(1,:), filterSignal2);
                    end
                case 3 %Ambos canales
                    if a == 0
                        filterSignal1 = filter(num,den,y3(1,:));
                        filterSignal2 = filter(num,den,y3(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    else
                        filterSignal1 = filter(bpFilt,y3(1,:));
                        filterSignal2 = filter(bpFilt,y3(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    end
            end
    end                

%-----------------FILTRO PASO ALTO--------------------------------------     
elseif get(handles.HPFilter,'Value') == 1 %Tipo HP

    switch TipoFil %-----------------------TIPO DE FILTRO-------------
        case 1 %FIR
            a = 1;  
            switch FilterSignal %Señal 
                case 1
                    Fs = Fs1;
                    hpFilt = designfilt('highpassfir','StopbandFrequency',FCS/(Fs1/2), ...
         'PassbandFrequency',(FCS/(Fs1/2))+0.1,'PassbandRipple',0.5, ...
         'StopbandAttenuation',65,'DesignMethod','kaiserwin');
                case 2
                    Fs = Fs2;
                    hpFilt = designfilt('highpassfir','StopbandFrequency',FCS/(Fs2/2), ...
         'PassbandFrequency',(FCS/(Fs2/2))+0.1,'PassbandRipple',0.5, ...
         'StopbandAttenuation',65,'DesignMethod','kaiserwin');
                case 3
                    Fs = Fs3;
                    hpFilt = designfilt('highpassfir','StopbandFrequency',FCS/(Fs3/2), ...
         'PassbandFrequency',(FCS/(Fs3/2))+0.1,'PassbandRipple',0.5, ...
         'StopbandAttenuation',65,'DesignMethod','kaiserwin');
            end        
        case 2 %Butter
            a = 0;
            switch FilterSignal %Señal 
                case 1
                    Fs = Fs1;
                    [num,den] = butter(6,FCS/(Fs1/2), 'high'); 
                case 2
                    Fs = Fs2;
                    [num,den] = butter(6,FCS/(Fs2/2), 'high'); 
                case 3
                    Fs = Fs3;
                    [num,den] = butter(6,FCS/(Fs3/2), 'high'); 
            end            
        case 3 %Chevy
            a = 0;
            switch FilterSignal %Señal 
                case 1
                    Fs = Fs1;
                    [num,den] = cheby2(6,40,FCI/(Fs1/2), 'high');
                case 2
                    Fs = Fs2;
                    [num,den] = cheby2(6,40,FCI/(Fs2/2), 'high');
                case 3
                    Fs = Fs3;
                    [num,den] = cheby2(6,40,FCI/(Fs3/2), 'high');
            end            
    end    
      
    switch FilterSignal %Señal ----------------APLICACION EN LA SEÑAL-----
        case 1
            switch FilterSignalChannel 
                case 1 %Canal 1
                    if a == 0
                        filterSignal1 = filter(num,den,y1(1,:));
                        Sf = vertcat(filterSignal1, y1(2,:));
                    else
                        filterSignal1 = filter(hpFilt,y1(1,:));
                        Sf = vertcat(filterSignal1, y1(2,:));
                    end
                case 2 %Canal 2
                    if a == 0
                        filterSignal2 = filter(num,den,y1(2,:));
                        Sf = vertcat(y1(1,:), filterSignal2);
                    else
                        filterSignal2 = filter(hpFilt,y1(2,:));
                        Sf = vertcat(y1(1,:), filterSignal2);
                    end
                case 3 %Ambos canales
                    if a == 0
                        filterSignal1 = filter(num,den,y1(1,:));
                        filterSignal2 = filter(num,den,y1(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    else
                        filterSignal1 = filter(hpFilt,y1(1,:));
                        filterSignal2 = filter(hpFilt,y1(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    end
            end
        case 2
            switch FilterSignalChannel 
                case 1 %Canal 1
                    if a == 0
                        filterSignal1 = filter(num,den,y2(1,:));
                        Sf = vertcat(filterSignal1, y2(2,:));
                    else
                        filterSignal1 = filter(hpFilt,y2(1,:));
                        Sf = vertcat(filterSignal1, y2(2,:));
                    end
                case 2 %Canal 2
                    if a == 0
                        filterSignal2 = filter(num,den,y2(2,:));
                        Sf = vertcat(y2(1,:), filterSignal2);
                    else
                        filterSignal2 = filter(hpFilt,y2(2,:));
                        Sf = vertcat(y2(1,:), filterSignal2);
                    end
                case 3 %Ambos canales
                    if a == 0
                        filterSignal1 = filter(num,den,y2(1,:));
                        filterSignal2 = filter(num,den,y2(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    else
                        filterSignal1 = filter(hpFilt,y2(1,:));
                        filterSignal2 = filter(hpFilt,y2(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    end
            end
        case 3
            switch FilterSignalChannel 
                case 1 %Canal 1
                    if a == 0
                        filterSignal1 = filter(num,den,y3(1,:));
                        Sf = vertcat(filterSignal1, y3(2,:));
                    else
                        filterSignal1 = filter(hpFilt,y3(1,:));
                        Sf = vertcat(filterSignal1, y3(2,:));
                    end
                case 2 %Canal 2
                    if a == 0
                        filterSignal2 = filter(num,den,y3(2,:));
                        Sf = vertcat(y3(1,:), filterSignal2);
                    else
                        filterSignal2 = filter(hpFilt,y3(2,:));
                        Sf = vertcat(y3(1,:), filterSignal2);
                    end
                case 3 %Ambos canales
                    if a == 0
                        filterSignal1 = filter(num,den,y3(1,:));
                        filterSignal2 = filter(num,den,y3(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    else
                        filterSignal1 = filter(hpFilt,y3(1,:));
                        filterSignal2 = filter(hpFilt,y3(2,:));
                        Sf = vertcat(filterSignal1, filterSignal2);
                    end
            end
    end        
    
end

%Graficar audio de entrada
RecordTime = length(Sf(1,:))/Fs;
iteration = Fs*RecordTime;
trama = length(Sf)/15;

%Graficar
axes(handles.senal4);
for i = 1 : 15
    plot(Sf(1,1:round(i*trama)),'Color','r','LineWidth',2);
    hold on
    plot(Sf(2,1:round(i*trama)),'Color','y','LineWidth',2);
    hold off
    axis([0 iteration -1 1]);
    xlabel('Sample number');
    ylabel('Amplitude');
    grid on;
    pause(0.05)
end 

% --- Executes on selection change in FilterSignalChannel.
function FilterSignalChannel_Callback(hObject, eventdata, handles)
% hObject    handle to FilterSignalChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns FilterSignalChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FilterSignalChannel




% --- Executes during object creation, after setting all properties.
function FilterSignalChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterSignalChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FCI_Callback(hObject, eventdata, handles)
% hObject    handle to FCI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FCI as text
%        str2double(get(hObject,'String')) returns contents of FCI as a double


% --- Executes during object creation, after setting all properties.
function FCI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FCI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function FCS_Callback(hObject, eventdata, handles)
% hObject    handle to FCS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FCS as text
%        str2double(get(hObject,'String')) returns contents of FCS as a double


% --- Executes during object creation, after setting all properties.
function FCS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FCS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    
