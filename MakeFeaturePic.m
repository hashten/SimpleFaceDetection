function [ fpic ] = MakeFeaturePic( ftype, W, H )
% Create a matrix, fpic, of zeros of size (H, W). From the information in
% ftype, set the appropriate pixels to 1 and to -1.

fpic = zeros(H,W);
x = ftype(2);
y = ftype(3);
w = ftype(4);
h = ftype(5);
switch ftype(1)
    case 1
        fpic(y:y+h-1,    x:x+w-1)       = ones(h,w);
        fpic(y+h:y+2*h-1,x:x+w-1)       = -ones(h,w);
    case 2
        fpic(y:y+h-1,   x:x+w-1)        = -ones(h,w);
        fpic(y:y+h-1,   x+w:x+2*w-1)    = ones(h,w);
    case 3
        fpic(y:y+h-1,   x:x+w-1)        = -ones(h,w);
        fpic(y:y+h-1,   x+w:x+2*w-1)    = ones(h,w);
        fpic(y:y+h-1,   x+2*w:x+3*w-1)    = -ones(h,w);
    case 4
        fpic(y:y+h-1,    x:x+w-1)       = -ones(h,w);
        fpic(y+h:y+2*h-1,x:x+w-1)       = ones(h,w);
        fpic(y:y+h-1,    x+w:x+2*w-1)        = ones(h,w);
        fpic(y+h:y+2*h-1,x+w:x+2*w-1)    = -ones(h,w);
end

end

