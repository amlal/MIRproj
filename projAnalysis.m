%This function loads in the file in libraryDir/fname and extracts its
%onsets and event segment start and end times.
%For each segment, chroma, rms amplitude, max chroma, max amplitude, and
%spectral centroid are extracted. All data is stored in return struct
%'data'

function [data] = projAnalysis(libraryDir,fname)


%% Start and end times
str = ['loading file ',fname];
disp(str);
%% Read audio to analyze
x = loadLib(libraryDir,fname);
fs = 44100;

str = ['analyzing file ',fname];
disp(str);
disp('onsets...');
%get onsets for input file. optional threshold level and filter order
[~,~,onsets] = AL_CD(x,fs); %,thresh,order);
%buffer into start/end times
startend = buffer(onsets,2,1);
%fix first overlap index
startend(1,1) = 1;

%% Initialize
%zero vector of appropriate size to allocate memory
zv = zeros(size(startend,2),1);
%set up data structure based on number of samples
%also includes allocation for temporary weighted distances from current
%target
data = struct('audioFile',x,'startTime',zv, 'endTime',zv,'rms',zv,'maxChroma',zv, ...
   'chroma',zeros(size(startend,2),12),'maxAmp',zv, 'specCent', zv,'weightedD',zv);


disp('chroma, spectral centroid and amplitude...');
%% Analysis loop
for i = 1:size(startend,2)
    
    %get block
    block = x(startend(1,i):startend(2,i));
    %store times startend(1,i) startend(2,i) in structure
    data.startTime(i) = startend(1,i);
    data.endTime(i) = startend(2,i);
    %compute chroma
    chroma = chromaValues(block,fs);
    %mean of chroma over time
    chromaVec = mean(chroma,2);
    %store in data structure
    data.chroma(i,:) = chromaVec;
    
    %max chroma value
    [~,maxChr] = max(chromaVec);
    %store in data structure
    data.maxChroma(i) = maxChr;
    %get rms of sample
    rmsval = sqrt(sum(block .^2)/(length(block)));
    %store in data structure
    data.rms(i) = rmsval;
    
    %Spectral Centroid!
    centroid = spectralCentroid(block, fs);
    %store in a data struct
    data.specCent(i) = centroid;
    
    
    %get max amplitude
    dmax = max(block);
    %store in data structure
    data.maxAmp(i) = dmax;
    
end


str = [fname,' successfully analyzed'];
disp(str);
end

