function [chroma, T] = chromaValues(audio, fs)
audio=audio(:,1);

chromaOctaves = 4;
perNote = 1;

windowSize = 8192;
preferredSampleRate = 40;
hop = windowSize - (fs/preferredSampleRate);

[S,F,T] = spectrogram(audio, hamming(windowSize), floor(hop), 16384*2, fs, 'yaxis');

%creates a lin-log frequency map to multiply against the STFT
[A, ~] = constantQueComb(55, perNote, chromaOctaves, length(F), 44100);
logFreq=S'*A';
logFreq=logFreq';

%calculate the chromagram
chmg = zeros(perNote*12,size(logFreq,2));
for column = 1:size(logFreq,2)
    
    thisColumn = logFreq(:,column);thisColumn = thisColumn';
    
    for pitchClass = 1:perNote*12
      thisClass = pitchClass;
      sum = 0;
      
      while thisClass<=size(logFreq,1)
          sum = sum + abs(thisColumn(thisClass));
          
          thisClass = thisClass+perNote*12;
      end
      
      chmg(pitchClass,column) = sum;
   end
end
%filter the chromagram
%chroma = medfilt2(chmg, [1, 10]);
%chroma = 20*log10(chmg);
chroma = chmg;


end


function [A, F] = constantQueComb(minimumFrequency, binsPerNote, octaves, amountOfBins, fs)

indeces = 0:(binsPerNote*12*octaves)-1;
F = minimumFrequency*(2.^(indeces/(binsPerNote*12)));


A = zeros(length(indeces), amountOfBins);
Area = (F(2)-F(1))*0.5;
for i=1:length(indeces)
    thisCenter = F(i);
    centerIndex = (thisCenter/(fs/2))*amountOfBins+1.5;
    
    if(i==1)
        thisWidth = ceil(((F(i+1)-thisCenter))/(fs/2)*amountOfBins);
    else
        thisWidth = ceil(((thisCenter-F(i-1)))/(fs/2)*amountOfBins);
    end
    
    thisWidth= floor(thisWidth*0.8);
    thisHeight = Area*5/thisWidth;
    thisTriangle = triang(thisWidth)*thisHeight;
    leftInd = floor(centerIndex-thisWidth/2);
    
    A(i, leftInd:leftInd+length(thisTriangle)-1) = thisTriangle;
end

end