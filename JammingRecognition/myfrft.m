function Faf = myfrft(f, a)
% �����׸���Ҷ�任������������Խ�����ľ���������
% �������fΪԭʼ�źţ�aΪ����
% ������Ϊԭʼ�źŵ�a�׸���Ҷ�任
N = length(f);% �ܲ�������
shft = rem((0:N-1)+fix(N/2),N)+1; % �����ͬ��fftshift(1:N)���𵽷�ת�����������
sN = sqrt(N);                     % ����ɢ����Ҷ�任�Ķ��壬������˻���
a = mod(a,4);                     % �������Խ�a������[0,4]

% �������ֱ�Ӵ��������ź���ϵͳ�ĸ���Ҷ�任��ʽ�Ƶ�
if (a==0), Faf = f; return; end                        % ����
if (a==2), Faf = flipud(f); return; end                % f(-x)
if (a==1), Faf(shft,1) = fft(f(shft))/sN; return; end  % f�ĸ���Ҷ�任
if (a==3), Faf(shft,1) = ifft(f(shft))*sN; return; end % f���渵��Ҷ�任

% ���õ����Խ������任��0.5 < a < 1.5
if (a>2.0), a = a-2; f = flipud(f); end                % a=2�Ƿ�ת
if (a>1.5), a = a-1; f(shft,1) = fft(f(shft))/sN; end  % a=1�Ǹ���Ҷ�任
if (a<0.5), a = a+1; f(shft,1) = ifft(f(shft))*sN; end % a=-1���渵��Ҷ�任

% ��ʼ��ʽ�ı任
alpha = a*pi/2;
tana2 = tan(alpha/2);
sina = sin(alpha);

f = [zeros(N-1,1) ; interp(f) ; zeros(N-1,1)];         % ʹ����ũ��ֵ����չΪ4N
% ���²�����Ӧԭ�����й�ʽ��29��
% ���Ե�ƵԤ����
chrp = exp(-1i*pi/N*tana2/4*(-2*N+2:2*N-2)'.^2);
f = chrp.*f;
% ���Ե�Ƶ���
c = pi/N/sina/4;
Faf = fconv(exp(1i*c*(-(4*N-4):4*N-4)'.^2),f);
Faf = Faf(4*N-3:8*N-7)*sqrt(c/pi);
% ���Ե�Ƶ�����
Faf = chrp.*Faf;
% ������ǰ���A_Phi��
Faf = exp(-1i*(1-a)*pi/4)*Faf(N:2:end-N+1);

end

function xint=interp(x)                                % ��ũ��ֵ
% sinc interpolation
N = length(x);
y = zeros(2*N-1,1);
y(1:2:2*N-1) = x;
xint = fconv(y(1:2*N-1), sinc([-(2*N-3):(2*N-3)]'/2)); % ������
xint = xint(2*N-2:end-2*N+3);
end

function z = fconv(x,y)                                % ����fft���ټ�����
N = length([x(:);y(:)])-1;                             % ����������
P = 2^nextpow2(N);                                     % ����
z = ifft( fft(x,P) .* fft(y,P));                       % Ƶ����ˣ�ʱ����
z = z(1:N);                                            % ȥ��
end
