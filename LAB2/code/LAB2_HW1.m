%alaising

clc;
clear;
close all;

%% 基本參數
f0 = 1e6;          % 原始訊號頻率：1 MHz
Fs1 = 4e6;         % 第一個取樣頻率：4 MHz
Fs2 = 1.5e6;       % 第二個取樣頻率：1.5 MHz
N = 256;           % DFT大小

% 發生aliasing後觀察到的頻率
f_alias = abs(f0 - Fs2);    % 0.5 MHz
Z
%% 用於畫連續訊號的時間軸
t_continuous = linspace(0, 5e-6, 2000);

x_original = cos(2*pi*f0*t_continuous);
x_alias = cos(2*pi*f_alias*t_continuous);

%% ==================================================
% Fs = 4 MHz
%% ==================================================

t1 = (0:N-1)/Fs1;
x1 = cos(2*pi*f0*t1);

X1 = fftshift(fft(x1, N));
f_axis1 = (-N/2:N/2-1)*(Fs1/N)/1e6;

% 只取前5微秒的sample來畫時域
index1 = t1 <= 5e-6;

%% ==================================================
% Fs = 1.5 MHz
%% ==================================================

t2 = (0:N-1)/Fs2;
x2 = cos(2*pi*f0*t2);

X2 = fftshift(fft(x2, N));
f_axis2 = (-N/2:N/2-1)*(Fs2/N)/1e6;

% 只取前5微秒的sample來畫時域
index2 = t2 <= 5e-6;

%% 畫四張圖
figure;

% 圖1：Fs = 4 MHz 的時域取樣
subplot(2,2,1);

plot(t_continuous*1e6, x_original, ...
    'k-', 'LineWidth', 1.2);
hold on;

stem(t1(index1)*1e6, x1(index1), ...
    'b', 'filled');

grid on;
xlabel('Time (\mus)');
ylabel('Amplitude');
title('Time Domain: F_s = 4 MHz');
legend('Original 1 MHz signal', 'Samples');
ylim([-1.2 1.2]);

% 圖2：Fs = 4 MHz 的頻譜
subplot(2,2,2);

plot(f_axis1, abs(X1)/N, 'LineWidth', 1.2);
grid on;
xlabel('Frequency (MHz)');
ylabel('|X[k]|/N');
title('Spectrum: F_s = 4 MHz');
xlim([-Fs1/(2e6), Fs1/(2e6)]);

% 圖3：Fs = 1.5 MHz 的時域aliasing
subplot(2,2,3);

plot(t_continuous*1e6, x_original, ...
    'k-', 'LineWidth', 1.2);
hold on;

plot(t_continuous*1e6, x_alias, ...
    'r--', 'LineWidth', 1.5);

stem(t2(index2)*1e6, x2(index2), ...
    'b', 'filled');

grid on;
xlabel('Time (\mus)');
ylabel('Amplitude');
title('Time-domain Aliasing: F_s = 1.5 MHz');
legend('Original 1 MHz', ...
       'Aliased 0.5 MHz', ...
       'Samples');
ylim([-1.2 1.2]);

% 圖4：Fs = 1.5 MHz 的頻譜
subplot(2,2,4);

plot(f_axis2, abs(X2)/N, 'LineWidth', 1.2);
grid on;
xlabel('Frequency (MHz)');
ylabel('|X[k]|/N');
title('Spectrum: F_s = 1.5 MHz');
xlim([-Fs2/(2e6), Fs2/(2e6)]);
