

function jammerSignals = jammerSigFunc(jammerType)

    switch jammerType
        
        case 1                                  % ���������źţ�������ʽ���Բ���������� 
                    Fs=20000;  % ����Ƶ��
                    N=20000;   % ������
                    n=0:N-1;
                    t=n/Fs;    % ʱ������
                    fc=1000;   % ���������ź�Ƶ�� 
                    f=n*Fs/N;  % Ƶ�� 
                    Uc=1*exp(2*1i*fc*pi*t);     
                    C1=fft(Uc);                 % �Ե��������źŽ��и���Ҷ�任 
                    cxf=abs(C1);                % ȡ����ֵ  
                    cxf=cxf/max(cxf);           % ���й�һ��
                    subplot(2,1,1);plot(t,Uc);title('�ز��źŲ���');xlabel('ʱ��(s)');ylabel('����(V)');title('���������źŲ���');axis([0 0.009 -1 1]); % ���������ź�ʱ����
                    subplot(2,1,2); plot(f, cxf);title('�ز��ź�Ƶ��'); axis([0 2000 0 1]);xlabel('Ƶ��(Hz)');ylabel('����');title('���������źŹ�һ��������'); % ���������ź�Ƶ����
                    jammerSignals = Uc;         % f(1:N/2),cxf(1:N/2)

        case 2                                  % �������������źţ�������ʽ���Բ����������
                    Fs=20000;   
                    N=20000;    
                    n=0:N-1;
                    t=n/Fs;  
                    A0=1;  
                    fc=1000;  
                    f=n*Fs/N; 
                    w0=2*fc*pi*1i; 
                    step=2*pi*50*1i;
                    Uc=A0*exp(w0*t)+A0*exp((w0+step)*t)+A0*exp((w0+2*step)*t)+A0*exp((w0+3*step)*t)+A0*exp((w0-step)*t)+A0*exp((w0-2*step)*t)+A0*exp((w0-3*step)*t); % ���������źţ�������ʽ���Բ����������  
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
                    jammerSignals = Uc.';

        case 3                               % ��������ɨƵ�źţ�������ʽ���Բ����������
                    t=0:0.0001:2-0.0001;     % 2��Ӧ2�����ڣ�0.00001Ϊ����
                    
                    f0=5;                   % ɨƵ��ʼƵ��
                    fe=100;                 % ɨƵ��ֹƵ��
                    x=chirp(mod(t,1),f0,1,fe);% 1������ǵ�����ʱ��
                    subplot(3,1,1);plot(t,x);title('�������ڵ�����ɨƵ�źŲ���');xlabel('ʱ��(s)');ylabel('����(V)');
                     
                    ft=f0+(fe-f0)*mod(t,1);
                    subplot(3,1,2);plot(t,ft);title('����ɨƵ�ź�Ƶ��-ʱ��ͼ');xlabel('ʱ��(s)');ylabel('Ƶ��(Hz)');
                     
                    t=0:0.0001:1-0.0001;     % ��Ƶ��ʱ���ܶԶ����ڵ��󣬶�1�����ڽ���FFT
                    x2=chirp(t,f0,1,fe);
                    C1=fft(x2);     
                    cxf=abs(C1);    
                    cxf=cxf/max(cxf);
                    subplot(3,1,3);plot(cxf); axis([0 2*fe 0 1]);title('����ɨƵ�źŹ�һ��Ƶ��');xlabel('Ƶ��(Hz)');ylabel('����');
                    jammerSignals = x;

        case 4                               % �������������źţ�������ʽ���Բ����������

                    fj=20e6;
                    fs=4*fj; 
                    Tr=200e-6;
                    
                    t1=0:1/fs:1.25*Tr-1/fs; 
                    N=length(t1);            
                    u=wgn(1,N,0);            % ����N*1����˹������������Ϊ0dBW
                    
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
                    u2=u1+u0;                % �ϰ���Ĳ���
                    u3=-u0-u1;               % �°���Ĳ���

                    subplot(2,2,3), plot(t1,y,t1,u2,t1,u3),title( '���������ź�ʱ����'); axis([0,0.02e-4,-2,2]);xlabel('ʱ��(s)');ylabel('����(V)');
                    subplot(2,2,4), J=fft(y);plot(f,10*log10(abs(J(n+1))));xlabel('Ƶ��(Hz)');ylabel('����(dBW)');axis([0,4e7,-20,50]);title( '���������źŹ�����');
                    jammerSignals = y;
            
            
        case 5                               % ����������Ƶ�źţ�������ʽ���Բ����������
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
                    [~,~]=butter(Nn,wn);


                    figure;subplot(2,2,1),plot(t1,u1),title('�����źŲ���');axis([0,2e-6,-2,2]);xlabel('ʱ��(s)');ylabel('����(V)');
                    subplot(2,2,2),j2=fft(u1); plot(f,10*log10(abs(j2(n+1)*2/N)));xlabel('Ƶ��(Hz)');ylabel('���ʣ�dBW��');axis([0,4e7,-20,50]);title( '�����źŹ�����');axis([0,4e7,-80,0]);
                    i=1:N-1;
                    ss=cumsum([0 u1(i)]);
                    ss=ss*Tr/N;
                    y=uj*cos(2*pi*fj*t1+2*pi*mf*bj*ss*10);   % uj=1 �������������Ƶ�źŵķ���  fj=20M �ǵ����ź�����Ƶ�� �ٳ���10ʹ���ƵĲ��θ�������
                    subplot(2,2,3), plot(t1,y),title( '������Ƶ�źŲ���'),axis([0,2e-6,-1.5,1.5]);xlabel('ʱ��(s)');ylabel('����(V)');
                    y=uj*cos(2*pi*fj*t1+2*pi*mf*bj*ss);      % uj=1 �������������Ƶ�źŵķ���  fj=20M �ǵ����ź�����Ƶ��  
                    subplot(2,2,4),J=fft(y);plot(f,10*log10(abs(J(n+1))));axis([0,4e7,-20,60]);xlabel('Ƶ��(Hz)');ylabel('���ʣ�dBW��');axis([0,4e7,-20,50]);title( '������Ƶ�źŹ�����')
                    
                    for index = 1:20000
                         jammerSignals(index) = y(index*12) ;

                    end


        case 6                            % ����խ����˹�źţ�������ʽ���Բ����������

                    fs=1000;              % ����Ƶ��
                    T_N=20;               % ��ʱ��
                    t=1/fs:1/fs:T_N;      % ʱ������
                    L=T_N*fs;             % ��������
                    
                    power=3;              % ��������,��λΪdbw
                    z=wgn(L,1,power);
                    subplot(2,1,1)
                    plot(t,z)
                    xlabel("ʱ��/s")
                    ylabel("����/v")
                    title("��˹��������ʱ��")
                    
                    fft_z=fft(z);            % ���ٸ���Ҷ�任֮�������
                    P = abs(fft_z/L);        % ȡ��Ƶ���ԣ�����L
                    P = P(1:L/2+1);          % ��ȡǰ���
                    P(2:end-1)=2*P(2:end-1); % ����Ƶ�׷�ֱ�������ǵó���2
                    f = fs*(0:(L/2))/L;      % �ο�˹�ز�������
                    subplot(2,1,2)
                    plot(f,P)
                    xlabel("Ƶ��/Hz")
                    ylabel("����/v")
                    title("��˹��������Ƶ��")
                    
                    [b,a]=butter(8,[300/(fs/2),400/(fs/2) ]); % ���8�װ�����˹�˲���ϵ����100-200Hz
                    figure(2)
                    freqs(b,a)            % ���˲�����������
                    lvbo_z=filter(b,a,z); % �˲�
                    
                    figure(3)
                    subplot(2,1,1)
                    plot((lvbo_z))
                    xlabel("ʱ��/Hz")
                    ylabel("����/v")
                    title("խ����˹������ʱ��")
                    
                    fft_lvbo_z=fft(lvbo_z);  % ����Ҷ�任
                    P = abs(fft_lvbo_z/L);   % ȡ��Ƶ���ԣ�����L
                    P = P(1:L/2+1);          % ��ȡǰ���
                    P(2:end-1)=2*P(2:end-1); % ����Ƶ�׷�ֱ�������ǵó���2
                    subplot(2,1,2)
                    plot(f,P)
                    xlabel("Ƶ��/Hz")
                    ylabel("����/v")
                    title("խ����˹������Ƶ��")
                    jammerSignals = lvbo_z;

    end
            
        


end