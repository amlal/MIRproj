%pass this an array containing an audio file at each point, and fs
function projMain(libraryDir,targetF,outfilename);

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
output = zeros(length(targetDat.audioFile),1);

%get sample lengths
lengths = targetDat.endTime - targetDat.startTime;

len = length(targetDat.startTime);


%% for each sample in the target, find the closest from database
for i = 1:len
    str = ['computing distances for sample ',sprintf('%d',i),' of ',sprintf('%d',len)];
    disp(str);
    %starting distance high so first will be lower
    bestmin = 999999999;
    loc = [0,0];
    
    %size of sample
    sizeofsamp = lengths(i);
    
    %Distance measurements from entire library to single sample
    
    %for each file
    for j = 1:length(fnames)    

        
        for r = 1:length(alldata(j).startTime)
 
            %temporary for easier typing
            temp = alldata(j);
        
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
    end
        

    
            
    %get sample to use to avoid hairy coding again
    filepull = alldata(loc(1)).audioFile;
    
    touse = filepull( (alldata(loc(1)).startTime(loc(2))) : ...
        (alldata(loc(1)).endTime(loc(2))) );
   
   
    %timestretch touse based on desired sample length           
    touse = pvoc(touse, (length(touse)/sizeofsamp));
    if length(touse) > sizeofsamp
        touse = touse(1:sizeofsamp);
    end
    if length(touse) < sizeofsamp
        touse(end:sizeofsamp) = 0;
    end
    
     
    %concat samp to output
    output( (targetDat.startTime(i)) : (targetDat.endTime(i))-1 ) = touse;
    str = ['found sample ',sprintf('%d',i)];
    disp(str);
    
end




%% wavwrite output
wavwrite(output,fs,16,outfilename);

% %% run analysis on output
% newDat = projAnalysis('',outfilename);
% %compare to target's analysis
% 
% %rms distances
% rmsD = abs(targetDat.rms - newDat.rms);
% %max chroma distance
% maxChrD = abs(targetDat.maxChroma - newtDat.maxChroma);
% %max amplitude difference
% ampD = abs(targetDat.maxAmp - newtDat.maxAmp);
% %chroma distance
% chromD = zeros(length(targetDat.startTime),1);
% for n = 1:length(targetDat.startTime)
%     %euclidean distance btw chroma vectors
%     chromD(k) = AL_EDist(targetDat.chroma(n,:),newDat.chroma(n,:));
% end
%         
% %weighted differences
% newDat.weightedD =  rmsD + maxChrD + ampD + chromD;
%     