% AL_CD Complex Domain detection function using Hamming window of 1024
% samples and 128 sample overlap
%
% [cd] = AL_CD(x,fs) where x is is input analysis vector, fs is
% sampling frequency, cd is a returned vector of the complex domain onset
% detection function, fsN is novelty sample rate
%
% Post-processing on onset detection: 10th order butterworth lowpass filter
% with Wn of 0.2, running average of 50 samples removed and half-wave
% rectified.


function [cd,fsN,onsets] = AL_CD(x,fs,thresh,order)
%set order
if nargin < 4
    %set thresh
    if nargin < 3
        %set threshold to 0l
        thresh =  0; 
    end
    %2ms window for events
    order = round(fs*0.002);
end


%% Initialize paramters

% If x is stereo, make mono
x = x(:,1);

%windowing
N = 1024;
h = 128;
if length(x) < 1024
        error('this file is too short');
end
Ol = N-h;
W = window(@hamming,N);

%% take spectrogram of signal
[s,f,t] = spectrogram(x,W,Ol,N,fs);

%% Phase Prediction

%generate blank phase matrix that will store phase values plus 2 blank
%columns of zeros at the beginning and end to generate differences of all
%values
phasemat = zeros(size(s,1),size(s,2)+2);
phasemat(:,3:size(s,2)+2) = angle(s);

%calculate predicted phase
thetahat = princarg( ( 2 .* phasemat(:,2:size(phasemat,2))) - phasemat(:,1:size(phasemat,2)-1) );
%truncate to size of s
thetahat = thetahat(:,1:size(s,2));

%% Magnitude Prediction

%create matrix of magnitude values delayed one sample
magmat = zeros(size(s,1),size(s,2)+1);
magmat(:,2:size(s,2)+1) = abs(s);
%truncate last column to size of s
magmat = magmat(:,1:size(s,2));


%% Complex Prediction

compmat = zeros(size(s,1),size(s,2));
compmat = magmat .* (exp(j*thetahat));

%% Rectified Complex Domain

cd = s-compmat;
%rectify
cd = abs((cd + abs(cd))/2);
%average
cd = mean(cd,1);

%local energy
%cd = cd .^2;

%normalize
cd = cd ./ max(cd);


[b,a] = butter(10,0.09,'low');
cd = filtfilt(b,a,cd);

%remove running average
%filtwinsize = 50, hardcoded for now, should probably be paramterized
cd = cd - filter(ones(1,50)/50,1,cd);
%half wave rectify
cd = (cd + abs(cd))/2;

%local energy
cd = cd .^2;
%normalize
cd = cd ./ max(cd);

fsN = fs/h;

[~,onsets] = findpeaks(cd,'MINPEAKDISTANCE',order,'MINPEAKHEIGHT',thresh);
onsets = onsets .* h;



