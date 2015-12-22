clear all
clc

x(1)=0;
ser = serial('com4', 'BaudRate', 2400, 'Parity', 'none', 'DataBits', 8, 'Terminator', 'CR')
fclose(instrfind);
fopen(ser);
a=[];
for i=1:500,
%while(1==1),
    a(i) = fscanf(ser, '%f');
    %x(i)=x(i-1)+1;
    %if(i==100), break; end
end
plot(a,x)
grid on