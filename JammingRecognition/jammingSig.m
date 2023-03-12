%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This module is aimed to simulate different jammer signals normally used
% in former works, such as pluse interference, sigleton interference,
% multitone interference and swept jammer.
% 
% 
% This module will update with different type of jammer.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc
clear 
clc



Fs=20000;  %����Ƶ��
N=20000;    %������
n=0:N-1;
t=n/Fs;  %ʱ������
fc=1000;  %�ز��ź�Ƶ�� 
f=n*Fs/N;  %Ƶ�� 
Uc=1*sin(2*fc*pi*t);     %�ز��ź� 
C1=fft(Uc);             %���ز��źŽ��и���Ҷ�任 
cxf=abs(C1);           %���и���Ҷ�任  
cxf=cxf/max(cxf);%��һ��
subplot(2,1,1);plot(t,Uc);title('�ز��źŲ���');xlabel('ʱ��(s)');ylabel('����(V)');title('���������źŲ���');axis([0 0.009 -1 1]);
subplot(2,1,2); plot(f(1:N/2),cxf(1:N/2));title('�ز��ź�Ƶ��'); axis([0 2000 0 1]);xlabel('Ƶ��(Hz)');ylabel('����');title('���������źŹ�һ��������');
set(gca,'YTick',0:1:1);%���ù�����������ֻ��0��1

%% multi tone jammer

clear
clc

close all



Fs=200000;  
N=200000;    
n=0:N-1;
t=n/Fs;  
A0=1;  
fc=1000;  
f=n*Fs/N; 
w0=2*fc*pi; 
step=2*pi*50;
Uc=A0*cos(w0*t)+A0*cos((w0+step)*t)++A0*cos((w0+2*step)*t)++A0*cos((w0+3*step)*t)+A0*cos((w0-step)*t)++A0*cos((w0-2*step)*t)++A0*cos((w0-3*step)*t);%�����ź� 
C1=fft(Uc);      
cxf=abs(C1);     
cxf=cxf/max(cxf);
subplot(2,1,1);
plot(t,Uc);
xlabel('ʱ��(s)');
ylabel('����(V)');
title('�������Ų���');
axis([0 0.1 -8 8]);
subplot(2,1,2);
plot(f(1:N/2),cxf(1:N/2));
title('��������Ƶ��');
axis([0 2000 0 1]);
xlabel('Ƶ��(Hz)');
ylabel('����');
title('�������Ź�һ��������');
set(gca,'YTick',0:1:1);

% clear
% clc
% 
% close all
% 
% A = [1.2 0.94 0.63];
% fm = [1.5e6 3.5e6 0.4e6] ;  
% fs = 10e6; 
% N = 1024;
% 
% dt = 1/fs;
% t = 0:dt:dt*N;
% 
% for index = 1:length(fm)
%     singleToneJammerTemp(index,:) = exp(1i*2*pi*fm(index)*t);
% end
% singleToneJammer = sum(singleToneJammerTemp);
% 
% subplot(2,1,1)
% plot(1:length(singleToneJammer),singleToneJammer);
% title('multiTone Jammer time domain');
% xlabel('n');
% 
% Y=fft(singleToneJammer);   
% mag=abs(Y);    
% f=(0:N-1)*fs/N;
% 
% subplot(2,1,2)
% plot(f(1:N/2),mag(1:N/2)*2/N); 
% title('multiTone Jammer frequence domain');
% xlabel('f/Hz');


%% partial-band jamming

clear
clc

close all
mu = 0;
sigma = 1;

fm = 1e6 ;  
fs = 10e6; 
N = 1024;


dt = 1/fs;
t = 0:dt:dt*N;
U = normrnd(0,0.002,[1,length(t)]);

singleToneJammer = U.*exp(1i*2*pi*fm*t);

subplot(2,1,1)
plot(1:length(singleToneJammer),singleToneJammer);
title('partial-band Jammer time domain');
xlabel('n');

Y=fft(singleToneJammer);   
mag=abs(Y);    
f=(0:N-1)*fs/N;

subplot(2,1,2)
plot(f(1:N/2),mag(1:N/2)*2/N); 
title('partial-band Jammer frequence domain');
xlabel('f/Hz');


%% linear sweep jammer
clear
clc

close all


t=0:0.00001:3-0.00001;

f0=30;
fe=1000;
x=chirp(mod(t,1),f0,1,fe);
subplot(3,1,1);plot(t,x);title('�������ڵ�����ɨƵ�źŲ���');xlabel('ʱ��(s)');ylabel('����(V)');
 
ft=f0+(fe-f0)*mod(t,1);
subplot(3,1,2);plot(t,ft);title('����ɨƵ�ź�Ƶ��-ʱ��ͼ');xlabel('ʱ��(s)');ylabel('Ƶ��(Hz)');
 
t=0:0.00001:1-0.00001;
x=chirp(t,f0,1,fe);
C1=fft(x);     
cxf=abs(C1);    
cxf=cxf/max(cxf);
subplot(3,1,3);plot(cxf); axis([0 2*fe 0 1]);title('����ɨƵ�źŹ�һ��Ƶ��');xlabel('Ƶ��(Hz)');ylabel('����');


%% noise AM

clear
clc

close all

fj=20e6;
fs=4*fj; 
Tr=520e-6;

t1=0:1/fs:3*Tr-1/fs; 
N=length(t1);
u=wgn(1,N,0);

df1=fs/N;n=0:N/2;f=n*df1;

wp=10e6;
ws=14e6;
rp=1; 
rs=60;
[n1,wn1]=buttord(wp/(fs/2),ws/(fs/2),rp,rs);
[b,a]=butter(n1,wn1);
u1=filter(b,a,u);

p=0.1503*mean((u1.^2));
figure;subplot(2,2,1),plot(t1,u1),title('�����źŲ���'); axis([0,0.02e-4,-2,2]);xlabel('ʱ��(s)');ylabel('����(V)');
subplot(2,2,2), j2=fft(u1);plot(f,10*log10(abs(j2(n+1)*2/N)));xlabel('Ƶ��(Hz)');ylabel('����(dBW)');axis([0,4e7,-70,0]);title( '�����źŹ�����');

u0=1;
y=(u1+u0).*cos(2*pi*fj*t1+2);
u2=u1+u0;
u3=-u0-u1;
subplot(2,2,3), plot(t1,y,t1,u2,t1,u3),title( '���������ź�ʱ����'); axis([0,0.02e-4,-2,2]);xlabel('ʱ��(s)');ylabel('����(V)');
subplot(2,2,4), J=fft(y);plot(f,10*log10(abs(J(n+1))));xlabel('Ƶ��(Hz)');ylabel('����(dBW)');axis([0,4e7,-20,50]);title( '���������źŹ�����');
%% noise FM
clear
clc

close all



uj=1;mf=2;wpp=10;

fj=20e6;fs=8*fj;Tr=520e-6;
t1=0:1/fs:3*Tr-1/fs;N=length(t1);
u=wgn(1,N,0);
wp=10e6;ws=16e6;rp=1;rs=60;
[n1,wn1]=buttord(wp/(fs/2),ws/(fs/2),rp,rs);
[b,a]=butter(n1,wn1);
u1=filter(b,a,u);
p=0.8503*mean((u1.^2)) ;
fj=20e6;fs=8*fj;Tr=520e-6;bj=5e6;
t1=0:1/fs:3*Tr-1/fs;N=length(t1);
u=wgn(1,N,wpp);
df1=fs/N;n=0:N/2;f=n*df1;
wp=10e6;ws=14e6;rp=1;rs=60;
[Nn,wn]=buttord(wp/(30e6/2),ws/(30e6/2),rp,rs);
[b,a]=butter(Nn,wn);
figure;subplot(2,2,1),plot(t1,u1),title('�����źŲ���');axis([0,2e-6,-2,2]);xlabel('ʱ��(s)');ylabel('����(V)');
subplot(2,2,2),j2=fft(u1); plot(f,10*log10(abs(j2(n+1)*2/N)));xlabel('Ƶ��(Hz)');ylabel('���ʣ�dBW��');axis([0,4e7,-20,50]);title( '�����źŹ�����');axis([0,4e7,-80,0]);
i=1:N-1;
ss=cumsum([0 u1(i)]);
ss=ss*Tr/N;
y=uj*cos(2*pi*fj*t1+2*pi*mf*bj*ss*10);
subplot(2,2,3), plot(t1,y),title( '������Ƶ�źŲ���'),axis([0,2e-6,-1.5,1.5]);xlabel('ʱ��(s)');ylabel('����(V)');
y=uj*cos(2*pi*fj*t1+2*pi*mf*bj*ss);  
subplot(2,2,4),J=fft(y);plot(f,10*log10(abs(J(n+1))));axis([0,4e7,-20,60]);xlabel('Ƶ��(Hz)');ylabel('���ʣ�dBW��');axis([0,4e7,-20,50]);title( '������Ƶ�źŹ�����')


%% linear sweep
clear
clc

close all


t=0:0.00001:1-0.00001;

f0=30;
fe=1000;
x=chirp(mod(t,1),f0,1,fe);
subplot(3,1,1);plot(t,x);title('�������ڵ�����ɨƵ�źŲ���');xlabel('ʱ��(s)');ylabel('����(V)');
 
ft=f0+(fe-f0)*mod(t,1);
subplot(3,1,2);plot(t,ft);title('����ɨƵ�ź�Ƶ��-ʱ��ͼ');xlabel('ʱ��(s)');ylabel('Ƶ��(Hz)');
 
t=0:0.00001:1-0.00001;
x=chirp(t,f0,1,fe);
C1=fft(x);     
cxf=abs(C1);    
cxf=cxf/max(cxf);
subplot(3,1,3);plot(cxf); axis([0 2*fe 0 1]);title('����ɨƵ�źŹ�һ��Ƶ��');xlabel('Ƶ��(Hz)');ylabel('����');

%% NB AWGN

fs=1000;%����Ƶ��hz
T_N=1;%��ʱ��s
t=1/fs:1/fs:T_N;%ʱ������
L=T_N*fs;%��������
power=3;%��������,��λΪdbw
z=wgn(L,1,power);
subplot(2,1,1)
plot(t,z)
xlabel("ʱ��/s")
ylabel("����/v")
title("��˹��������ʱ��")

fft_z=fft(z);%���ٸ���Ҷ�任֮�������
P = abs(fft_z/L);%ȡ��Ƶ���ԣ�����L
P = P(1:L/2+1);%��ȡǰ���
P(2:end-1)=2*P(2:end-1);%����Ƶ�׷�ֱ�������ǵó���2
f = fs*(0:(L/2))/L;%Ƶ�ʣ���ൽһ�루�ο�˹�ز�������
subplot(2,1,2)
plot(f,P)
xlabel("Ƶ��/Hz")
ylabel("����/v")
title("��˹��������Ƶ��")

[b,a]=butter(8,[300/(fs/2),400/(fs/2) ]);%���8�װ�����˹�˲���ϵ����100-200Hz
figure(2)
freqs(b,a)%���˲�����������
lvbo_z=filter(b,a,z);%�˲�

figure(3)
subplot(2,1,1)
plot((lvbo_z))
xlabel("ʱ��/Hz")
ylabel("����/v")
title("խ����˹������ʱ��")

fft_lvbo_z=fft(lvbo_z);%����Ҷ�任
P = abs(fft_lvbo_z/L);%ȡ��Ƶ���ԣ�����L
P = P(1:L/2+1);%��ȡǰ���
P(2:end-1)=2*P(2:end-1);%����Ƶ�׷�ֱ�������ǵó���2
subplot(2,1,2)
plot(f,P)
xlabel("Ƶ��/Hz")
ylabel("����/v")
title("խ����˹������Ƶ��")


