function [ ftype_vec ] = VecFeature( ftype, W, H )
%This functions uses VecBoxSum to make sums of adjacent subareas in the
%image according to 4 different patterns. The Output is in the same format:
% ftype_vec:        1 x W*H

x = ftype(2);
y = ftype(3);
w = ftype(4);
h = ftype(5);
switch ftype(1)
    case 1
        ftype_vec = VecBoxSum(x, y, w, h, W, H) - VecBoxSum(x, y+h, w, h, W, H);
        %Output:        VecBoxSum:  1 x W*H
    case 2
        ftype_vec = -VecBoxSum(x, y, w, h, W, H) + VecBoxSum(x+w, y, w, h, W, H);
    case 3
        ftype_vec = -VecBoxSum(x, y, w, h, W, H) + VecBoxSum(x+w, y, w, h, W, H) ...
                    -VecBoxSum(x+2*w, y, w, h, W, H);
    case 4
        ftype_vec = -VecBoxSum(x, y, w, h, W, H) + VecBoxSum(x+w, y, w, h, W, H) ...
                    + VecBoxSum(x, y+h, w, h, W, H) - VecBoxSum(x+w, y+h, w, h, W, H);
end
end

