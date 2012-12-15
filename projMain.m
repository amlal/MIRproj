%run analysis on dataset

%if dataset is large
if numSongs > arbitrary
    %pick a random distribution of songs
    
end

%pick from data structure at indices songs, store in smaller data structure
output = zeros(length(target),1);

for 1:size(startend,2)
    %size of sample
    sizeofsamp = startend(2,i)-startend(1,i);
    %AL_EDist on measurements
    %store in some matrix
    %find min, use index to access dataset
    samp = resample(data(starttime:endtime),sizeofsamp,length(x(starttime:endtime)); %TWEAK 4 VARS
    %concat samp to output
    output(startend(1,i):startend(2,i)) = samp;
    
end


%run analysis on output
%compare to target's analysis
%store in matrix to ouput

wavwrite(ouput,fs,16,'output');
    