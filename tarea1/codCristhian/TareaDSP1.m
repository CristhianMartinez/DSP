function varargout = TareaDSP1(varargin)
% TAREADSP1 MATLAB code for TareaDSP1.fig
%      TAREADSP1, by itself, creates a new TAREADSP1 or raises the existing
%      singleton*.
%
%      H = TAREADSP1 returns the handle to a new TAREADSP1 or the handle to
%      the existing singleton*.
%
%      TAREADSP1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TAREADSP1.M with the given input arguments.
%
%      TAREADSP1('Property','Value',...) creates a new TAREADSP1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TareaDSP1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TareaDSP1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TareaDSP1

% Last Modified by GUIDE v2.5 05-Mar-2019 21:00:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TareaDSP1_OpeningFcn, ...
                   'gui_OutputFcn',  @TareaDSP1_OutputFcn, ...
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


% --- Executes just before TareaDSP1 is made visible.
function TareaDSP1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TareaDSP1 (see VARARGIN)

Fs = 44100   ; %Sampling rate in Hz. Valid values depend on both the sample rates permitted by MATLAB® and the specific audio hardware on your system. MATLAB has a hard restriction of 1000 Hz <= Fs <= 384000 Hz, although further hardware-dependent restrictions apply. Typical values supported by most sound cards are 8000, 11025, 22050, 44100, 48000, and 96000 Hz.
nBits = 8; %Bits per sample. Valid values depend on the audio hardware installed: 8, 16, or 24.
nChannels = 1; %The number of channels: 1 (mono) or 2 (stereo).

handles.output = hObject;
handles.recorder = audiorecorder(Fs,nBits,nChannels); % Se crea el objeto para grabar audio
guidata(hObject, handles); % se guarda la estructura handles
% UIWAIT makes TareaDSP1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = TareaDSP1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in seleccionarArchivo.
function seleccionarArchivo_Callback(hObject, eventdata, handles)
% hObject    handle to seleccionarArchivo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global file %se instancia la variable file como global

[file,path] = uigetfile('*.wav','Seleccione el archivo de audio'); %displays a dialog box used to retrieve one or more files. The dialog box lists the files and directories in the current directory.
if isequal(file,0)
   disp('El usuario seleccionó cancelar')
   return
else
   disp(['El usuario seleccionó el archivo: ', fullfile(path, file)])
end

%inicio = 1;
%fin = 200;
%samples=[inicio fin];
%audioread(file, samples)

[x,Fs] = audioread(file); % Lee los datos del archivo denominado filenamey devuelve los datos muestreados, yy una frecuencia de muestreo para esos datos,

set(handles.valMaximo, 'String', length(x));

axes(handles.axesEntrada); %Indico que la grafica se muestre en el axes1
plot(x); %Grafico el audio

% --- Executes on button press in grabarAudio.
function grabarAudio_Callback(hObject, eventdata, handles)
% hObject    handle to grabarAudio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.pararAudio,'enable','on'); %habilita el botón de parar la grabación
disp('Se empieza a grabar.')
record(handles.recorder); %graba el audio y lo almacena en handles.recorder

% --- Executes on button press in pararAudio.
function pararAudio_Callback(hObject, eventdata, handles)
% hObject    handle to pararAudio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file

set(handles.pararAudio,'enable','off'); %deshabilita el botón parar
stop(handles.recorder); %finaliza la grabación
disp('Se termina de grabar.');

myRecording = getaudiodata(handles.recorder); % Se almacenan los datos en un array de doble precisión
myRecording(1:260,:) = [];

filename = 'grabacion.wav';
audiowrite(filename, myRecording,get(handles.recorder,'SampleRate')) % writes a matrix of audio data, y, with sample rate Fs to a file called filename. The filename input also specifies the output file format. 

[x,Fs] = audioread(filename);

set(handles.valMaximo, 'String', length(x));

t=0:1/Fs:(length(x)-1)/Fs;
axes(handles.axesEntrada) %Indico que la grafica se muestre en el axes1
plot(t,x); %Grafico el audio
%title('SEÑAL DE ENTRADA')        
%xlabel('Tiempo (s)')                       
%ylabel('A')                                
file = '0'

% --- Executes on button press in reproducirAudio.
function reproducirAudio_Callback(hObject, eventdata, handles)
% hObject    handle to reproducirAudio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file
if exist('file','var') == 1 & (file ~= '0')
    [x,Fs] = audioread(file);
else
    [x,Fs] = audioread('grabacion.wav');
end

volu = get(handles.SubirVolumen,'value');
sound(volu*x,Fs); %se reproduce el audio
disp('reproduciendo')

% --- Executes on button press in ecuacionDiferencia.
function ecuacionDiferencia_Callback(hObject, eventdata, handles)
% hObject    handle to ecuacionDiferencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ecuacionDiferencia
global file fil

inicio = str2double(get(handles.valorMinimoTxt,'String'));
fin = str2double(get(handles.valorMaximoTxt,'String'));

if exist('file','var') == 1 & (file ~= '0')
    [x,Fs] = audioread(file, [inicio fin]);
else
    [x,Fs] = audioread('grabacion.wav', [inicio fin]);
end

x = mapminmax(x);

dlg_title = 'Ecuación de diferencias';
prompt = { 'Ingrese los coeficientes a:','Ingrese las condiciones iniciales:', 'Ingrese los coeficientes b'};
num_lines = 1;
defaultans = {'1  2  3  2', '0 0 0', '1  2  1  4  5'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

if isempty(answer)
  set(handles.Ninguno, 'Value', 1);
  return; 
end

% Obtención de h(n) 
a=str2num(answer{1});
CI=str2num(answer{2});  
b=str2num(answer{3});   

if length(a)-1 ~= length(CI)
    return
end

N = length(a);
M = length(b);

temp1 = 0;
temp2 = 0;

for n = 1 : length(x)
    for k = 2 : N
        if n-k+1 < 1
            temp1 = temp1 + (a(k)/a(1))*CI((n-k)*-1);
        else
            temp1 = temp1 + (a(k)/a(1))*y(n-k+1);
        end
    end
    
    for j = 1 : M
        if n-j+1 < 1 || n-j > length(x)-1
            temp2 = temp2;
        else
            temp2 = temp2 + (b(j)/a(1))*x(n-j+1);
        end
    end
    y(n) = -temp1 + temp2;
    temp1 = 0;
    temp2 = 0;
end
y
fil = y;
axes(handles.axes2)                               %Indico que la grafica se muestre en el axes2
stem(y);

% --- Executes on button press in respuestaFrecuencia.
function respuestaFrecuencia_Callback(hObject, eventdata, handles)
% hObject    handle to respuestaFrecuencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of respuestaFrecuencia

% --- Executes on button press in Ninguno.
function Ninguno_Callback(hObject, eventdata, handles)
% hObject    handle to Ninguno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of Ninguno

% --- Executes on button press in SeleccionarTwoSignal.
function SeleccionarTwoSignal_Callback(hObject, eventdata, handles)
% hObject    handle to SeleccionarTwoSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fileTwo %se instancia la variable file como global
%open file
[fileTwo,path,indx] = uigetfile('*.wav','Seleccione el archivo de audio');;
if isequal(fileTwo,0)
   disp('El usuario seleccionó cancelar')
   return
else
   disp(['El usuario seleccionó el archivo: ', fullfile(path, fileTwo),... 
         ' y el indice: ', num2str(indx)])
end

[x,Fs] = audioread(fileTwo);

set(handles.valMaximo2, 'String', length(x));
axes(handles.axes3)                               %Indico que la grafica se muestre en el axes4
plot(x);
%axes(handles.axesEntrada) %Indico que la grafica se muestre en el axesEntrada
%plot(x); %Grafico el audio

% --- Executes on button press in arSen.
function SumarSen_Callback(hObject, eventdata, handles)
% hObject    handle to SumarSen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fileTwo file ope

inicio1 = str2double(get(handles.valorMinimoTxt,'String'));
fin1 = str2double(get(handles.valorMaximoTxt,'String'));

inicio2 = str2double(get(handles.valorMinimoTxt2,'String'));
fin2 = str2double(get(handles.valorMaximoTxt2,'String'));

if exist('file','var') == 1 & (file ~= '0')
    disp('entro')
    [x,Fs] = audioread(file,[inicio1, fin1]);
else
    disp('no entro')
    [x,Fs] = audioread('grabacion.wav', [inicio1, fin1]);
end

[x2, Fs2] = audioread(fileTwo, [inicio2, fin2]);


originalFs = Fs2
desiredFs = Fs 
[p,q] = rat(desiredFs / originalFs)
x2 = resample(x2,p,q); 

t=0:1/desiredFs:(length(x2)-1)/desiredFs;



if(length(x) ~= length(x2))
    if (length(x) > length(x2))
        diff = length(x) - length(x2);
        x2 = [x2; zeros(diff,1)];
    else
        diff = length(x2) - length(x);
        x = [x; zeros(diff,1)];
    end
end

ope = x + x2;
%x
%x2
%ope

axes(handles.axes4)                               %Indico que la grafica se muestre en el axes4

if length(ope) > 50
    plot(t,ope);
else
    stem(t,ope);
end

sound(ope,desiredFs)

% --- Executes on button press in MultiSen.
function MultiSen_Callback(hObject, eventdata, handles)
% hObject    handle to MultiSen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fileTwo file ope

inicio1 = str2double(get(handles.valorMinimoTxt,'String'));
fin1 = str2double(get(handles.valorMaximoTxt,'String'));

inicio2 = str2double(get(handles.valorMinimoTxt2,'String'));
fin2 = str2double(get(handles.valorMaximoTxt2,'String'));

if exist('file','var') == 1 & (file ~= '0')
    disp('entro')
    [x,Fs] = audioread(file,[inicio1, fin1]);
else
    disp('no entro')
    [x,Fs] = audioread('grabacion.wav', [inicio1, fin1]);
end

[x2, Fs2] = audioread(fileTwo, [inicio2, fin2]);

originalFs = Fs2
desiredFs = Fs 
[p,q] = rat(desiredFs / originalFs)
x2 = resample(x2,p,q); 

t=0:1/desiredFs:(length(x2)-1)/desiredFs;


if(length(x) ~= length(x2))
    if (length(x) > length(x2))
        diff = length(x) - length(x2);
        x2 = [x2; zeros(diff,1)];
    else
        diff = length(x2) - length(x);
        x = [x; zeros(diff,1)];
    end
end

ope = x .* x2;
%x
%x2
%ope
axes(handles.axes4)                               %Indico que la grafica se muestre en el axes4

if length(ope) > 50
    plot(t,ope);
else
    stem(t,ope);
end

sound(ope,desiredFs)


% --- Executes on button press in ReproducirInv.
function ReproducirInv_Callback(hObject, eventdata, handles)
% hObject    handle to ReproducirInv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file
if exist('file','var') == 1 & (file ~= '0')
    [x,Fs] = audioread(file);
else
    [x,Fs] = audioread('grabacion.wav');
end

volu = get(handles.SubirVolumen,'value');
sound(volu*flipud(x),Fs); %se reproduce el audio
axes(handles.axes2)                               %Indico que la grafica se muestre en el axes4
plot(volu*flipud(x));
disp('reproduciendo')
 
% --- Executes on button press in EsteMono.
function EsteMono_Callback(hObject, eventdata, handles)
% hObject    handle to EsteMono (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of EsteMono
global file
if exist('file','var') == 1 & (file ~= '0')
    [x,Fs] = audioread(file);
else
    [x,Fs] = audioread('grabacion.wav');
end

if get(hObject,'Value') 
   set(hObject,'String','Estereofónica');
   silence = zeros(length(x), 1);
   sound([x silence], Fs)
   
else
   set(hObject,'String','Monofónica');
    
   x = [x x];
   sound(x, Fs)
end

% --- Executes on button press in Modular.
function Modular_Callback(hObject, eventdata, handles)
% hObject    handle to Modular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on slider movement.
function SubirVolumen_Callback(hObject, eventdata, handles)
% hObject    handle to SubirVolumen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.valorVolumen,'String',get(hObject,'Value'));

% --- Executes during object creation, after setting all properties.
function SubirVolumen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SubirVolumen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Value', 1);


% --- Executes on button press in rampa.
function rampa_Callback(hObject, eventdata, handles)
% hObject    handle to rampa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rampa
global file fil

inicio = str2double(get(handles.valorMinimoTxt,'String'));
fin = str2double(get(handles.valorMaximoTxt,'String'));

if exist('file','var') == 1 & (file ~= '0')
    [x,Fs] = audioread(file, [inicio fin]);
else
    [x,Fs] = audioread('grabacion.wav', [inicio fin]);
end

xT = x';
%in = xT(1:44101);
%portadora
f = 50;
t = 1:1/(length(xT)-1):2;
length(xT)
length(t)
c = sawtooth(f*t);
%modulacion
fil = xT.*c;
axes(handles.axes2) 
plot(c)


axes(handles.axes4) 
plot(fil)

% --- Executes on button press in sinusoidal.
function sinusoidal_Callback(hObject, eventdata, handles)
% hObject    handle to sinusoidal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sinusoidal
global file fil

inicio = str2double(get(handles.valorMinimoTxt,'String'));
fin = str2double(get(handles.valorMaximoTxt,'String'));

if exist('file','var') == 1 & (file ~= '0')
    [x,Fs] = audioread(file, [inicio fin]);
else
    [x,Fs] = audioread('grabacion.wav', [inicio fin]);
end


xT = x';
%in = xT(1:44101);
%portadora
f = 50;
t = 1:1/(length(xT)-1):2;
length(xT)
length(t)
c = sin(2*pi*f*t);
%modulacion
fil = xT.*c;
axes(handles.axes2) 
plot(c)


axes(handles.axes4) 
plot(fil)

%t





% --- Executes during object creation, after setting all properties.
function valorVolumen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valorVolumen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'String', '1');



function valorMinimoTxt_Callback(hObject, eventdata, handles)
% hObject    handle to valorMinimoTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valorMinimoTxt as text
%        str2double(get(hObject,'String')) returns contents of valorMinimoTxt as a double



% --- Executes during object creation, after setting all properties.
function valorMinimoTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valorMinimoTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valorMaximoTxt_Callback(hObject, eventdata, handles)
% hObject    handle to valorMaximoTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valorMaximoTxt as text
%        str2double(get(hObject,'String')) returns contents of valorMaximoTxt as a double


% --- Executes during object creation, after setting all properties.
function valorMaximoTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valorMaximoTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in aplicarBtn.
function aplicarBtn_Callback(hObject, eventdata, handles)
% hObject    handle to aplicarBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inicio = str2double(get(handles.valorMinimoTxt,'String'));
fin = str2double(get(handles.valorMaximoTxt,'String'));

global file
if exist('file','var') == 1 & (file ~= '0')
    [x,Fs] = audioread(file, [inicio fin]);
else
    [x,Fs] = audioread('grabacion.wav', [inicio fin]);
end
axes(handles.axesEntrada)
if fin - inicio > 50
    plot([inicio:1:fin],x);
else
    stem([inicio:1:fin],x);
end



function valorMinimoTxt2_Callback(hObject, eventdata, handles)
% hObject    handle to valorMinimoTxt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valorMinimoTxt2 as text
%        str2double(get(hObject,'String')) returns contents of valorMinimoTxt2 as a double


% --- Executes during object creation, after setting all properties.
function valorMinimoTxt2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valorMinimoTxt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valorMaximoTxt2_Callback(hObject, eventdata, handles)
% hObject    handle to valorMaximoTxt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valorMaximoTxt2 as text
%        str2double(get(hObject,'String')) returns contents of valorMaximoTxt2 as a double


% --- Executes during object creation, after setting all properties.
function valorMaximoTxt2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valorMaximoTxt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AplicarBtn2.
function AplicarBtn2_Callback(hObject, eventdata, handles)
% hObject    handle to AplicarBtn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inicio = str2double(get(handles.valorMinimoTxt2,'String'));
fin = str2double(get(handles.valorMaximoTxt2,'String'));

global fileTwo
if exist('fileTwo','var') == 1 & (fileTwo ~= '0')
    [x,Fs] = audioread(fileTwo, [inicio fin]);
else
    return
end


axes(handles.axes3)
if fin - inicio > 50
    plot([inicio:1:fin],x);
else
    stem([inicio:1:fin],x);
end


% --- Executes on button press in reproducirS2.
function reproducirS2_Callback(hObject, eventdata, handles)
% hObject    handle to reproducirS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fileTwo
if exist('fileTwo','var') == 1 & (fileTwo ~= '0')
    [x,Fs] = audioread(fileTwo);
else
    return
end
sound(x,Fs); %se reproduce el audio

% --- Executes on button press in reproduPS1.
function reproduPS1_Callback(hObject, eventdata, handles)
% hObject    handle to reproduPS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file

inicio = str2double(get(handles.valorMinimoTxt,'String'));
fin = str2double(get(handles.valorMaximoTxt,'String'));

if exist('file','var') == 1 & (file ~= '0')
    [x,Fs] = audioread(file, [inicio fin]);
else
    [x,Fs] = audioread('grabacion.wav', [inicio fin]);
end

%volu = get(handles.SubirVolumen,'value');
%sound(volu*x,Fs); %se reproduce el audio

sound(x,Fs); 


% --- Executes on button press in reproduPS2.
function reproduPS2_Callback(hObject, eventdata, handles)
% hObject    handle to reproduPS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inicio = str2double(get(handles.valorMinimoTxt2,'String'));
fin = str2double(get(handles.valorMaximoTxt2,'String'));

global fileTwo
if exist('fileTwo','var') == 1 & (fileTwo ~= '0')
    [x,Fs] = audioread(fileTwo, [inicio fin]);
else
    return
end
sound(x,Fs); 


% --- Executes on button press in repOpe.
function repOpe_Callback(hObject, eventdata, handles)
% hObject    handle to repOpe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ope;

sound(ope,8000); 

% --- Executes on button press in repFiltro.
function repFiltro_Callback(hObject, eventdata, handles)
% hObject    handle to repFiltro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fil;

sound(fil,8000); 



function frecM_Callback(hObject, eventdata, handles)
% hObject    handle to frecM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frecM as text
%        str2double(get(hObject,'String')) returns contents of frecM as a double


% --- Executes during object creation, after setting all properties.
function frecM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frecM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
