function dst=ManhattanDistance(F1, F2)

% This function should compare F1 to F2 - i.e. compute the distance
% between the two descriptors via Manhattan distance (L1 norm / City block)

% Subtract each element of feature F1 from feature F2
x=F1-F2;
% Get the absolute values of these differences
x=abs(x);
% Sum up the absolute differences
dst=sum(x);

return;