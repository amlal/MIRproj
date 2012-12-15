function [datastruct] = ALKM_Analysis(x,fs,thresh)

%get onsets for input file. optional threshold level and filter order
[novelty,fsN,onsets] = AL_CD(x,fs); %,thresh,order);


%% Start and end times
%buffer into start/end times
startend = buffer(onsets,2,1);
%fix first overlap index
startend(1,1) = 1;



%% Analysis loop
for i = 1:size(startend,2)
    %get block
    block = x(startend(1,i):startend(2,i));
    %store times startend(i,1) startend(i,2) in structure
    
    %compute chroma
    
    %sum/avg if necessary
    
    %store in data structure
    
    %get rms of sample
    rmsval = sqrt(sum(block .^2)/(length(block)));
    
    %store in data structure
    

        
end
