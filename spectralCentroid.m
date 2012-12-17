%This function returns a single mean spectral centroid value for the input
%wave file

function [centroid] = spectralCentroid(audio, fs)
audio=audio(:,1);

windowSize = 8192;
%reset window size if signal length is too small
if length(audio) < 8192
    windowSize = 4096;
    if length(audio) < 4096
        windowSize = 2048;
    end
end

preferredSampleRate = 40;
hop = windowSize - (fs/preferredSampleRate);
if hop < 1
    error('this is it')
end

if(length(audio)<windowSize)
    conc = zeros(windowSize - length(audio),1);
    audio = vertcat(audio, conc);
end

[S,F,T,P] = spectrogram(audio, hamming(windowSize), floor(hop), 16384*2, fs, 'yaxis');

for i=1:size(P,2)
    centroid(1,i) = sum(F.*P(:,i))/sum(P(:,i)); 
end

centroid = mean(centroid);

end