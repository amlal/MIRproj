% AL_ACF Auto-Correlation Tempo Extraction function using Hamming window of
% 4096 samples and 64 sample overlap
%
% [tempos,acf] = AL_ACF(novelty,fs) where novelty is input novelty
% function, fsN is sampling rate of novelty function (fs/h for novelty
% parameters), tempos is a vector of maximum values and locations for
% tempo, and acf is the autocorrelation matrix.


function [tempos,ACF,convtempos,bpmvec] = AL_ACF(novelty,fsN)

%% set parameters

%set window and hop
N = 2048;
h = 64;

%re-set window based on input novelty length
if length(novelty) < 3072
   
           error('length is probably too short to compute tempo');
      
end

Ol = N - h;
w = window(@hamming,N);

%ACF Lag
L = 128;

%Find Power of 2 greater than N+L-1!!!N
nfft = 2^nextpow2(N+L-1);


%% Take spectrum of novelty function
[s,f,t] = spectrogram(novelty,w,Ol,nfft,ceil(fsN));
%Square magnitude spectrum
s = abs(s) .^ 2;

%% compute ACF function
ACF = real(ifft(s,N*2,1));
ACF = ACF(1:(size(ACF,1)/2),:);

%% Weighting
%generate weighting vector
weight = ones(size(ACF,1),1);
%weight = weight ./ ((N/2)-((size(ACF,1)-1):-1:0)');
weight = weight ./ ((N)-((size(ACF,1)-1):-1:0)');
%weight = weight ./ ((N)-((size(ACF,1)-1):-1:0)');

%turn into weighting matrix
weight = repmat(weight,1,size(ACF,2));

%weight ACF
ACF = ACF./ weight;


%% COMB FILTER
%Defining BPM range as 60 to 279, so 400 samples to 86 samples lag
Rw = zeros(400,N);


for i=86:400
    %
    for m = 1:floor(N/L)
        if (i*m) < size(Rw,2)
            Rw(i,i*m) = 1;
        end
    end
end
%grab only relevant part of matrix
Rw = Rw(86:400,:);

%Rayleigh weighting
%column
raylcol = 1:size(Rw,1);
raylcol = raylpdf(raylcol,210); %43 based on Davies paper
%matrix
raylmat = repmat(raylcol',1,size(Rw,2));
%weight Rw
Rw = Rw .* raylmat;



%% multiplication

ACF = Rw * ACF;

[~,tempos] = max(ACF);

convtempos = 60 ./ (tempos ./ 400);
bpmvec = 60 ./ ((86:400)./400);
            