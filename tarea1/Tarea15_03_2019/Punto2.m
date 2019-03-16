function varargout = Punto2(varargin)
% PUNTO2 MATLAB code for Punto2.fig
%      PUNTO2, by itself, creates a new PUNTO2 or raises the existing
%      singleton*.
%
%      H = PUNTO2 returns the handle to a new PUNTO2 or the handle to
%      the existing singleton*.
%
%      PUNTO2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PUNTO2.M with the given input arguments.
%
%      PUNTO2('Property','Value',...) creates a new PUNTO2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Punto2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Punto2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Punto2

% Last Modified by GUIDE v2.5 16-Mar-2019 10:14:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Punto2_OpeningFcn, ...
                   'gui_OutputFcn',  @Punto2_OutputFcn, ...
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


% --- Executes just before Punto2 is made visible.
function Punto2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Punto2 (see VARARGIN)
global diccionarioReducidoP1
global diccionarioReducidoP2
% Choose default command line output for Punto2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Punto2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
diccionarioReducidoP1 = containers.Map;
diccionarioReducidoP2 = containers.Map;


% --- Outputs from this function are returned to the command line.
function varargout = Punto2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in grabarBtn.
function grabarBtn_Callback(hObject, eventdata, handles)
% hObject    handle to grabarBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Fs
global CH1
global recorder1

nBits = 8;
CH1 = 1;
Fs = 8000;

nuevaPalabra = get(handles.palabraTxt,'String');

if isempty(nuevaPalabra)
    return;
end

set(handles.pararBtn,'enable','on');
recorder1 = audiorecorder(Fs,nBits,1);
record(recorder1);

% --- Executes on button press in pararBtn.
function pararBtn_Callback(hObject, eventdata, handles)
% hObject    handle to pararBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global recorder1
global Fs
global diccionarioReducidoP1
global diccionarioReducidoP2

set(handles.pararBtn,'enable','off');
stop(recorder1);
y1 = getaudiodata(recorder1)';

nuevaPalabra = get(handles.palabraTxt,'String');

Persona = get(handles.personasMnu,'Value');

switch Persona
    case 1
        diccionarioReducidoP1(nuevaPalabra) = y1;
           
        keys(diccionarioReducidoP1)
            
        datosActuales = cellstr(get(handles.signal1Mnu, 'String'));
        datosActuales{end+1} = nuevaPalabra;
        set(handles.signal1Mnu,'string',datosActuales);
        set(handles.signal1Mnu, 'Value', length(datosActuales))
        
        items = get(handles.signal1Mnu,'String')
        palabra = items{length(datosActuales)}
        axes(handles.axes1)  
        %t=0:1/Fs:(length(diccionarioReducidoP1(palabra))-1)/Fs;
        plot(diccionarioReducidoP1(palabra));
   
    case 2
        diccionarioReducidoP2(nuevaPalabra) = y1;
        
        datosActuales = cellstr(get(handles.signal2Mnu, 'String'));
        datosActuales{end+1} = nuevaPalabra;
        set(handles.signal2Mnu,'string',datosActuales);
        set(handles.signal2Mnu, 'Value', length(datosActuales))
        
        items = get(handles.signal2Mnu,'String')
        palabra = items{length(datosActuales)}
        axes(handles.axes2)  
        %t=0:1/Fs:(length(diccionarioReducidoP2(palabra))-1)/Fs;
        plot(diccionarioReducidoP2(palabra));
end


function palabraTxt_Callback(hObject, eventdata, handles)
% hObject    handle to palabraTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of palabraTxt as text
%        str2double(get(hObject,'String')) returns contents of palabraTxt as a double


% --- Executes during object creation, after setting all properties.
function palabraTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to palabraTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in personasMnu.
function personasMnu_Callback(hObject, eventdata, handles)
% hObject    handle to personasMnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns personasMnu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from personasMnu


% --- Executes during object creation, after setting all properties.
function personasMnu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to personasMnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in correlacionBtn.
function correlacionBtn_Callback(hObject, eventdata, handles)
% hObject    handle to correlacionBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global diccionarioReducidoP1
global diccionarioReducidoP2

idx1 = get(handles.signal1Mnu,'Value');
items1 = get(handles.signal1Mnu,'String')
palabra1 = items1{idx1}

if isempty(palabra1)
    return
end

idx2 = get(handles.signal2Mnu,'Value');
items2 = get(handles.signal2Mnu,'String')
palabra2 = items2{idx2}

if isempty(palabra1)
    return
end

% Señales a correlacionar
x=diccionarioReducidoP1(palabra1); 
nx=0:length(x)-1;
Ex=sum(x.^2); %Energía de x(n)=rxx(0)
 
y=diccionarioReducidoP2(palabra2);
%y=diccionarioReducidoP1(palabra1);
ny=0:length(y)-1;
Ey=sum(y.^2); %Energía de y(n)=ryy(0)

% Calcular Correlación
N=max(length(x),length(y));
r = xcorr(x,y);
l=(-N+1):(N-1); % rango de valores de l
ro=r/sqrt(Ex*Ey); %Normalizar la correlación
% Graficación

[rmax,lmax]=max(ro);
axes(handles.axes3) 
stem(l,ro);title(['ro(l), lmax= ' num2str(lmax-N)]); 
xlabel('l');grid on;

rmax

set(handles.amplitudLbl,'String',sprintf('%s = %.3f','rmax',rmax));

% --- Executes on button press in reproducirBtn1.
function reproducirBtn1_Callback(hObject, eventdata, handles)
% hObject    handle to reproducirBtn1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Fs
global diccionarioReducidoP1

idx = get(handles.signal1Mnu,'Value');
items = get(handles.signal1Mnu,'String')
palabra = items{idx}

if isempty(palabra)
    return
end

sound(diccionarioReducidoP1(palabra),Fs);


% --- Executes on button press in reproducirBtn2.
function reproducirBtn2_Callback(hObject, eventdata, handles)
% hObject    handle to reproducirBtn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Fs
global diccionarioReducidoP2

idx = get(handles.signal2Mnu,'Value');
items = get(handles.signal2Mnu,'String')
palabra = items{idx}

if isempty(palabra)
    return
end


sound(diccionarioReducidoP2(palabra),Fs);


% --- Executes on selection change in signal1Mnu.
function signal1Mnu_Callback(hObject, eventdata, handles)
% hObject    handle to signal1Mnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns signal1Mnu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from signal1Mnu
global diccionarioReducidoP1
global Fs

contents = cellstr(get(hObject,'String'))
axes(handles.axes1)  
palabra = contents{get(hObject,'Value')};
if isempty(palabra)
    return
end
%t=0:1/Fs:(length(diccionarioReducidoP1(palabra))-1)/Fs;
plot(diccionarioReducidoP1(palabra));


% --- Executes during object creation, after setting all properties.
function signal1Mnu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signal1Mnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in signal2Mnu.
function signal2Mnu_Callback(hObject, eventdata, handles)
% hObject    handle to signal2Mnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns signal2Mnu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from signal2Mnu
global diccionarioReducidoP2
global Fs

contents = cellstr(get(hObject,'String'))
axes(handles.axes2)  
palabra = contents{get(hObject,'Value')};
if isempty(palabra)
    return
end
%t=0:1/Fs:(length(diccionarioReducidoP2(palabra))-1)/Fs;
plot(diccionarioReducidoP2(palabra));

% --- Executes during object creation, after setting all properties.
function signal2Mnu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signal2Mnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in autocorrelacionBtn.
function autocorrelacionBtn_Callback(hObject, eventdata, handles)
% hObject    handle to autocorrelacionBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global diccionarioReducidoP1
global diccionarioReducidoP2

idx1 = get(handles.signal1Mnu,'Value');
items1 = get(handles.signal1Mnu,'String')
palabra1 = items1{idx1}

if isempty(palabra1)
    return
end

idx2 = get(handles.signal2Mnu,'Value');
items2 = get(handles.signal2Mnu,'String')
palabra2 = items2{idx2}

if isempty(palabra1)
    return
end

% Señales a correlacionar
x=diccionarioReducidoP1(palabra1); 
nx=0:length(x)-1;
Ex=sum(x.^2); %Energía de x(n)=rxx(0)
 
%y=diccionarioReducidoP2(palabra2);
y=diccionarioReducidoP1(palabra1);
ny=0:length(y)-1;
Ey=sum(y.^2); %Energía de y(n)=ryy(0)

% Calcular Correlación
N=max(length(x),length(y));
r = xcorr(x,y);
l=(-N+1):(N-1); % rango de valores de l
ro=r/sqrt(Ex*Ey); %Normalizar la correlación
% Graficación

[rmax,lmax]=max(ro);
axes(handles.axes5) 
stem(l,ro);title(['ro(l), lmax= ' num2str(lmax-N)]); 
xlabel('l');grid on;


% --- Executes on button press in reconocerBtn.
function reconocerBtn_Callback(hObject, eventdata, handles)
% hObject    handle to reconocerBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global diccionarioReducidoP1
global diccionarioReducidoP2

idx = get(handles.signal2Mnu,'Value');
items = get(handles.signal2Mnu,'String')
palabra = items{idx}

if isempty(palabra)
    return
end

% Señales a correlacionar
x=diccionarioReducidoP2(palabra); 
nx=0:length(x)-1;
Ex=sum(x.^2); %Energía de x(n)=rxx(0)

ks = keys(diccionarioReducidoP1) ;
val = values(D) ;
for i = 1:length(D)
 %[ks{i} val{i}]
 
 ny=0:length(val{i})-1;
 Ey=sum(y.^2); %Energía de y(n)=ryy(0)
 
 % Calcular Correlación
 N=max(length(x),length(y));
 r = xcorr(x,y);
 l=(-N+1):(N-1); % rango de valores de l
 ro=r/sqrt(Ex*Ey); %Normalizar la correlación

 [rmax,lmax]=max(ro);
 
 
end






