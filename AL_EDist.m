%point-wise euclidian distance of two vectors a and b

function euclid = AL_EDist(a,b)

if length(a) ~= length(b)
    error('vectors are of different lengths, cannot compute distance');
end

sum=0;

for i=1:length(a)
    sum = sum + ((b(i)-a(i))^2);
end

euclid = sqrt(sum);

end

    