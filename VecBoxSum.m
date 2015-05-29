function [ b_vec ] = VecBoxSum( x, y, w, h, W, H)
%This function returns the sum of all pixels in a subarea of the image,
%with the help of the integral image and 4 points around the box
%Output:        b_vec:  1 x W*H

b_vec = sparse(H,W);

if x==1 && y ==1
    b_vec(y+h-1, x+w-1)=1;
elseif x == 1 && y ~= 1
    
    b_vec(y-1,x+w-1)=-1;
    b_vec(y+h-1, x+w-1)=1;
        
elseif y == 1 && x ~= 1
    b_vec(y+h-1, x-1)=-1;
    b_vec(y+h-1, x+w-1)=1;
else
    b_vec(y-1,x-1)=1;
    b_vec(y-1,x+w-1)=-1;
    b_vec(y+h-1, x-1)=-1;
    b_vec(y+h-1, x+w-1)=1;
    
    
%     ul = [x-1 y-1];      %Upper Left
%     ur = [x+w-1, y-1];   %Upper Right
%     ll = [x-1, y+h-1];   %Lower Left
%     lr = [x+w-1, y+h-1]; %Lower Right
% 
%     %
%     b_vec = zeros(1,W*H);
%     b_vec([((ul(1)-1)*H+ul(2)) ((ur(1)-1)*H+ur(2)) ((ll(1)-1)*H+ll(2)) ...
%             ((lr(1)-1)*H+lr(2))]) = [1 -1 -1 1];
end

b_vec=b_vec(:)';
end

