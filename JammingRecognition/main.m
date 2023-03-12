clear
clc
close all

% jammerType
%
%       singleTone            ->        1    单音 
%       multiTone             ->        2    多音
%       linear sweep          ->        3    线性扫频
%       AM                    ->        4    噪声调幅
%       FM                    ->        5    噪声调频
%       NB AWGN               ->        6    窄带高斯

jammerType  = 1;            
jammerSignals = jammerSigFunc(jammerType);

Y = awgn(jammerSignals,5,'measured');     % 模拟awgn信道，输入信号为干扰信号，设置干噪比为5dB，Y为接收到的信号
                                          % 其中，awgn信道为添加高斯白噪声在信号的信道                            
Y = abs(Y);
Y = Y/max(Y); 

F = fft(Y);   % 接收到的信号进行傅里叶变换
F = abs(F);
F = F/max(F); % 归一化

%% -------------时域特征提取-------------------%%
pd = skewness(Y); % 时域矩偏度：信号的分布偏离中心的程度；大于0说明信号在右侧的部分多于左侧，反之小于0
fd = kurtosis(Y); % 时域矩峰度：信号分布的尖锐程度；大于3说明波形出现多个尖峰，整体分布较为陡峭；小于3说明信号分布较为平缓，呈现扁平分布
mea = mean(Y);    % 均值
fc = var(Y);      % 方差
R = fc/(mea.^2);  % 时域包络起伏度：信号振幅随时间变化的剧烈程度

%% -------------时频域特征提取------------------%%
Rf = zeros(1,20000); max1 = zeros(5); % 创建空行向量和空矩阵
for a=0:0.5:2                         % a为分数傅里叶变换的阶数
    b=a*2+1;                          % b为计数器，一是用于记录a每一次变化时对应的Rf，二是用于记录进行分数傅里叶变换的次数
    Rf = myfrft(Y,a);
    max1(b)=abs(max(Rf));
end
M = max(max1,[],'all');               % 利用max函数，求每次不同阶数下分数阶傅里叶域的最大值

%% -------------波形域特征提取------------------%%
V = Y;
N = length(V);
V(N+1) = 0; d2 = 0; d1 = 0;
for i = 1:N
    d1 = d1+abs(V(i)-V(i+1));
end
for i = 1:(N/2)
    max2 = max(max(V(2*i-1),V(2*i)),V(2*i+1));
    min2 = min(min(V(2*i-1),V(2*i)),V(2*i+1));
    d2 = d2+(max2-min2);
    max2 = 0; min2 = 0;
end
Df = 1 + (log(d1/d2))/(log(2)); % 盒维数：描述分形信号的几何尺度信息

%% -------------频域 特征提取------------------%%
pd2 = skewness(F);          % 频域矩偏度：对正态分布的偏离程度，信号频域的对称性
fd2 = kurtosis(F);          % 频域矩峰度：信号的陡峭程度
crestfactor=max(F)/mean(F); % 频谱峰度：信号频谱的陡峭程度

% -------------计算单频能量聚集度--------------------%
[max, m]=max(F); a = 0;

for i=1:N
    a = a + F(i)^2;
end
C = (F(m)^2 + F(m+1)^2) / a;  % 单频能量聚集度,此处设置k = 1，但由于此时m=1，F（m-1）项不存在同时周围数值较小，故舍去

% -------------计算平均频谱平坦系数------------------%
F1 = zeros(1,N);              % 创建一个空行向量
for k = 1:N
    %计算和式
    if k <= 600
    temp_sum = sum(F(1:600+k));
    
    elseif k >= 19401
    temp_sum = sum(F(k-600:N));
    
    else
    temp_sum = sum(F(k-600:k+600));
    
    end
    %计算F1(k)
    F1(k) = F(k) - temp_sum/1201; 
    
end
%平均频谱平坦系数：表现信号频谱幅度的变化程度
Fc = sqrt(sum((F1-mean(F1)).^2)/N);




