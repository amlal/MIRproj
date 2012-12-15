function [beats] = AL_Beats(tempos,novelty,x)


%% PHASE/BEATS
N = 2048;
h = 64;
NovH = 128;
NovN = 1024;
ACFround = round(tempos);

%empty vector for shift values
shift = zeros(1,length(ACFround));

%for each frame of ND
for i = 1:length(ACFround)

    %generate pulse train matrix using ACF value
    pt = zeros((ACFround(i)-1),N);
    
    
    
    
    %for each possible shift (row)
    for j=1:ACFround(i)-1
        for m = 1:16 %based on 16 max partials in previous comb filter definition
            if ACFround(i)*m+j < size(pt,2)
              pt(j,(ACFround(i)*m)+j)=1;
           end
        end
        
        
    end
    %multiply by each hop chunk of novelty detection function
    chunk = zeros(N,1);
    chunk = novelty(((i-1)*h)+1:((i-1)*h)+N);
    chunk = pt * chunk';
    %find the maximum value, or lag, and store in vector of shift
    %values/frame
    [~,shift(i)] = max(chunk);
end

%convert shift vector from ND sample shifts to audio sample shifts
%not 100% on this
shift = shift .* NovH;

%the values in shift fall within each of these newwindow windows
%no overlap. i think? the number of ACF frames times this window size is a
%little short of the original signal length...
newwindow = NoveltyH * h;


%% BEATS

%buffer file into chunks size newwindow
buffed = buffer(x,newwindow);
%discard last few windows...
buffed = buffed(:,1:size(ACF,2));

%generate pulse trains for each of them

%vector of the period for each pulse train for each newwindow frame
%NOTE: I'm getting beats twice as often as I should. Not sure why, but *2
%seems to fix everything.
shiftPeriods = ACFround .* NoveltyH*2;

%genereate blank matrix for pulse trains
pulses = zeros(size(buffed));

%need shift value to start before creating pulse train
for i = 1:size(pulses,2)
    
    for g = shift(i):shiftPeriods(i):newwindow
        pulses(g,i) = 1;
    end    
    
end
    
%turn into beat vector
pulses = reshape(pulses,(size(pulses,1)*size(pulses,2)),1);