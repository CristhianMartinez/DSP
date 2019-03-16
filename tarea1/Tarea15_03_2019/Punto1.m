clc;
clear;
% PUNTO 1. ANALIZAR FILTRO ECUACIÓN DE DIFERENCIA
n = 60;

%impulso unidad
Xim=[zeros(1,n/2-1),ones(1,1),zeros(1,n/2)];

%escalón
Xesc=[zeros(1,n/2),ones(1,n/2)];


for i=1:n   
    %ramp
    Xram(i) = i;
    
    %senoidal
    A = 1;
    w = 2*pi*0.02;
    Xsen(i) = A*cos(w*i);
end

%Se elige la señal de entrada
X = Xsen;

A1 = [1 -2.0260 2.148000 -1.159 0.279];
B = [0.02 0.053 0.071 0.053 0.028];
Ci = [0 0 0 0]; 

N = length(A1) - 1;
M = length(B) - 1;

X = horzcat(zeros(1,M),X);
Y = horzcat(fliplr(Ci(1:N)), zeros(1,length(X) - M));
A = A1./A1(1);
A = A(2:end)

B = B./A1(1);
j = M + 1;

for i = N + 1:length(Y)
    aux = fliplr(Y(i - N:i-1));
    aux2 = fliplr(X(j - M:j));
    Y(i) = -sum(aux.*A) + sum(aux2.*B);
    j = j + 1;
end

t =-(n/2+4):(n/2-1); %escalon

stem(t,X, 'r')
hold on
stem(t,Y, 'b')