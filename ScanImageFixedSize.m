function [ dets ] = ScanImageFixedSize( Cparams, im, varargin)
%SCANIMAGEFIXEDSIZE Summary of this function goes here
%   Detailed explanation goes here
if nargin == 3
    L = varargin{1};
    display(['Chosen size of patch: ' num2str(L)]);  
else
    L = 19;
end
L_sq = L*L;
if isa(im,'char')
    im = imread(im);
    if ndims(im)>2
        im = rgb2gray(im);
        display('Image transformed to gray...');   
    end
end
im = double(im);

im_squared = im.*im;
ii_im = cumsum(cumsum(im,2),1);
ii_im_squared = cumsum(cumsum(im_squared,2),1);



% ii_patch = zeros(L*L,size(im,1)*size(im,2));
ii_patch = zeros(L*L,length(im(:)));
coord = zeros(size(im,1)*size(im,2),4);
mean_im = zeros(1,size(im,1)*size(im,2));
std_im = zeros(1,size(im,1)*size(im,2));
ii_num = 1;
xmax = size(im,2)-L+1;
ymax = size(im,1)-L+1;
for x = 1:xmax
    for y = 1:ymax
        if x~=1 && y~=1
            mean_im(ii_num) = (-ii_im(y-1, x+L-1)+ii_im(y-1, x-1) ... 
                               -ii_im(y+L-1, x-1)+ii_im(y+L-1, x+L-1))/L_sq;
            std_im(ii_num) = ((-ii_im_squared(y-1, x+L-1) + ii_im_squared(y-1, x-1) ...
                               -ii_im_squared(y+L-1, x-1) + ii_im_squared(y+L-1, x+L-1) ...
                       - L_sq*mean_im(ii_num)*mean_im(ii_num))/(L_sq-1))^0.5;
        elseif x == 1 && y ~= 1


            mean_im(ii_num) = (-ii_im(y-1,x+L-1)+ii_im(y+L-1, x+L-1))/L_sq;
            std_im(ii_num) = ((-ii_im_squared(y-1,x+L-1) + ii_im_squared(y+L-1, x+L-1) ...
                       - L_sq*mean_im(ii_num)*mean_im(ii_num))/(L_sq-1))^0.5;
        elseif y == 1 && x~= 1
            mean_im(ii_num) = (-ii_im(y+L-1, x-1)+ii_im(y+L-1, x+L-1))/L_sq;
            std_im(ii_num) = ((-ii_im_squared(y+L-1, x-1) + ii_im_squared(y+L-1, x+L-1) ...
                       - L_sq*mean_im(ii_num)*mean_im(ii_num))/(L_sq-1))^0.5;
        else
            mean_im(ii_num) = ii_im(y+L-1, x+L-1)/L_sq;
            std_im(ii_num) = ((ii_im_squared(y+L-1, x+L-1) ...
                       - L*L*mean_im(ii_num)*mean_im(ii_num))/(L*L-1))^0.5;
        end

%         Thiese rows takes up to 60 sec for fixedscan many_faces
%         if std_im==0
%             std_im = std_im + 0.0001;
%         end
        ii_one_patch = ii_im(y:y+L-1,x:x+L-1);
        ii_patch(:,ii_num) = ii_one_patch(:);
%         ii_patch(:,ii_num) = reshape(ii_im(y:y+L-1,x:x+L-1),[L*L 1]);
        coord(ii_num,:) = [x,y,L,L];
        ii_num = ii_num + 1;
    end
end
scs = ApplyDetector(Cparams,ii_patch,mean_im,std_im); %Cparams.thresh
dets= coord(scs>4.36,:);

end
