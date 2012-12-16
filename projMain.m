%pass this an array containing an audio file at each point, and fs
function [newDat] = projMain(libraryDir,targetF,outfilename);

fs = 44100;


%% get filenames
fnames = dir(libraryDir);


%% run analysis on dataset
for m =4:length(fnames)
    alldata(m) = projAnalysis(libraryDir,fnames(m).name);
end

%% analyze target
targetDat = projAnalysis('',targetF);

%buffer for output
output = zeros(length(target),1);

%get sample lengths
lengths = targetDat.endTime - targetDat.startTime;

len = length(targetDat.startTime);


%% for each sample in the target, find the closest from database
for i = 1:len
    str = ['computing distances for sample ',i,' of ',len);
    disp(str);
    %starting distance high so first will be lower
    bestmin = 999999999;
    loc = [0,0];
    
    %size of sample
    sizeofsamp = lengths(i);
    
    %Distance measurements from entire library to single sample
    for j = 1:length(library)
        
        %temporary for easier typing
        temp = alldata(i);
        
        %rms distances
       rmsD = abs(temp.rms - targetDat.rms(i));
        %max chroma distance
       maxChrD = abs(temp.maxChroma - targetDat.maxChroma(i));
        %max amplitude difference
       ampD = abs(temp.maxAmp - targetDat.maxAmp(i));
        %chroma distance
        chromD = zeros(length(temp.startTime),1);
        for k = 1:length(temp.startTime)
            %euclidean distance btw chroma vectors
            chromD(k) = AL_EDist(temp.chroma(k,:),targetDat.chroma(i,:));
        end
        
        %weighted differences
        temp.weightedD = rmsD + maxChrD + ampD + chromD;
        
        %if there's a distance closer than the closest found distance,
        %store the index and value for future reference
        [tempmin,temploc] = min(temp.weightedD);
        if tempmin < bestmin
            bestmin = tempmin;
            %library file index, sample index
            loc = [j,temploc];
        end
    end
    
    %get sample to use to avoid hairy coding again
    touse = library(j).audioFile( (library(j).startTime(loc)) : (library(j).endTime(loc)) );
    
    %timestretch touse based on desired sample length           
    touse = pvoc(touse, (sizeofsamp/length(touse)));
    
    %concat samp to output
    output( (targetDat.startTime(i)) : (targetDat.endTime(i)) ) = touse;
    str = ['found sample ',i,'!');
    disp(str);
    
end


%% run analysis on output
newDat = projAnalysis(output,fs);
%compare to target's analysis

%rms distances
rmsD = abs(targetDat.rms - newDat.rms);
%max chroma distance
maxChrD = abs(targetDat.maxChroma - newtDat.maxChroma);
%max amplitude difference
ampD = abs(targetDat.maxAmp - newtDat.maxAmp);
%chroma distance
chromD = zeros(length(targetDat.startTime),1);
for n = 1:length(targetDat.startTime)
    %euclidean distance btw chroma vectors
    chromD(k) = AL_EDist(targetDat.chroma(n,:),newDat.chroma(n,:));
end
        
%weighted differences
newDat.weightedD =  rmsD + maxChrD + ampD + chromD;

%% wavwrite output
wavwrite(ouput,fs,16,outfilename);
    