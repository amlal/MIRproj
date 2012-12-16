%this function mp3reads or wavreads all 
function x = loadLib(libraryDir,fname)




fs = 44100;
%only accept 1 mins of file
fmin = fs*60;

    %get extension
    [~,~,ext] = fileparts(fname);
    
    %if wave file
    if strcmp(ext,'.wav') == 1
        name = sprintf('%s%s',libraryDir,fname);
        
        [x,fs1] = wavread(name);
        %if fs doesn't match, don't store
        if fs ~= fs1
            error('wrong sample rate');
        end
        
        %mono only accept 1 mins of file
        x = x(:,1);
        if length(x) >= fmin
            x = x(1:fmin,1);
        end
        
    end
    %%
    %if mp3
%     if strcmp(ext,'.mp3') == 1
%         name = sprintf('%s%s',libraryDir,fname);
%         
%         [x,fs1] = mp3read(name);
%         %if fs doesn't match, don't store
%         if fs ~= fs1
%             error('wrong sample rate');
%         end
%         
%         %mono only accept 4 mins of file
%         x = x(:,1);
%         if length(x) >= fmin
%             x = x(1:fmin,1);
%         end
% 
%     end
    %otherwise nothing read in



end