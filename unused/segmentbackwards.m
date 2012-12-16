%%

%analysis loop
for i = 1:size(startend,2)
    %store times startend(i,1) startend(i,2) in structure
    
    %compute chroma
    
    %sum/avg if necessary
    
    %store in data structure
    
    %get rms of sample
    %rmsval = rms(abs(x(startend(i,1):startend(i,2))));
    
    %store in data structure
    wavwrite(x(startend(1,i):startend(2,i)),fs,sprintf('%d',i));
        
end

concat = zeros(length(x),1);
index = 1;
for i = size(startend,2):-1:1
    sized = startend(2,i) - startend(1,i);
    concat(index:index+sized) = x(startend(1,i):startend(2,i));
    index = index +sized;
    
    
end

wavwrite(concat,fs,'out');