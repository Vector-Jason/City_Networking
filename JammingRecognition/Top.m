

clear
clc 
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%@para
%
% jammerType
%
%       singleTone            ->        1     
%       multiTone             ->        2
%       linear sweep          ->        3
%       partial-band          ->        4 
%       FM                    ->        5
%       NB AWGN               ->        6  
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% jammer signal generate

jammerType  = 5;            

jammerSignals = jammerSigFunc(jammerType);

figure(222)
% % tf-2D
% pspectrum(jammerSignals,2e3,'spectrogram','TimeResolution',0.1,'OverlapPercent',99,'Leakage',0.85)

% tf-3D
[p,f,t] =  pspectrum(jammerSignals,2e3,'spectrogram');
waterfall(f,t,p')
xlabel('Frequency (Hz)')
ylabel('Time (seconds)')
wtf = gca;
wtf.XDir = 'reverse';


%% generate urben jamming channel




%% generate node received jamming signal



%% jamming feature extraction





















