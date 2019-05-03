clc; clear all; close all;

fc = 1;
fs = 1000;

[b,a] = butter(6,fc/(fs/2));
figure,
freqz(b,a)

t = 0:1/1e3:2;
y = chirp(t,0,1,250);

dataIn = vertcat (y,y);


dataOut = filter(b,a,dataIn);


N = length(dataIn);
datafft=fft(dataIn);
datafft_abs1=abs(datafft(1,:)/N);
datafft_abs1=datafft_abs1(1:N/2+1);
datafft_abs2=abs(datafft(2,:)/N);
datafft_abs2=datafft_abs2(1:N/2+1);
datafft_abs = vertcat(datafft_abs1, datafft_abs2);
f=fs*(0:N/2)/N;

figure;
plot(f,datafft_abs(1,:), 'r')
hold on
plot(f,datafft_abs(2,:), 'b')
hold off
grid on;
xlabel('Frequency [Hz]')
ylabel('Amplitude')
title('FFT SIGNAL 2 - Mag');


% L=50;
% n=0:L-1;
% 
% x1=ones(1,L);
% x2=(-1).^n;
% %Parametros se?ales sinusoidales
% f=20;
% fs=15*20;
% x3=cos(2*pi*f*n/fs);
% x4=sin(2*pi*f*n/fs);
% 
% % Fourier
% Lw=4*L;
% dw=2*pi/Lw;
% w=0:dw:2*pi-dw; %valores eje w
% 
% X1f=fft(x1,Lw); MX1=abs(X1f);
% X2f=fft(x2,Lw); MX2=abs(X2f);
% X3f=fft(x3,Lw); MX3=abs(X3f);
% X4f=fft(x4,Lw); MX4=abs(X4f);
% 
% subplot(2,2,1);
% stem(n,x1);title('x1(n)'); grid on;
% subplot(2,2,2);
% stem(n,x2);title('x2(n)'); grid on;
% subplot(2,2,3);
% plot(w,MX1);title('Mag X1(w)'); xlabel('w'); grid on;
% subplot(2,2,4);
% plot(w,MX2);title('Mag X2(w)');xlabel('w'); grid on;
% 
% figure
% 
% subplot(2,2,1);
% stem(n,x3);title('x3(n)'); grid on;
% subplot(2,2,2);
% stem(n,x4);title('x4(n)'); grid on;
% subplot(2,2,3);
% plot(w,MX3);title('Mag X3(w)'); xlabel('w');grid on;
% subplot(2,2,4);
% plot(w,MX4);title('Mag X4(w)'); xlabel('w');grid on;