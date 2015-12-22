clear all
clc

fclose(instrfind);
ser = serial('com3', 'BaudRate', 2400, 'Parity', 'none', 'DataBits', 8, 'Terminator', 'CR')
fopen(ser);
a=[];
time=[];
tic
for i=1:500,
    a(i) = fscanf(ser, '%f');
    time(i)=toc;
end
sv=80.*ones(1,500);
figure
plot(time,a,time,sv)
title('Plot Suhu vs Waktu', 'FontSize', 14, 'FontWeight', 'bold')
xlabel('Waktu (s)','FontSize', 12)
ylabel('Temperatur (\circC)','FontSize', 12)
hleg = legend('PV','SV')
grid on