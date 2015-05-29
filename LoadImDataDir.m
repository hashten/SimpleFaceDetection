function [ ii_ims ] = LoadImDataDir( dirname, varargin )
%LOADIMDATADIR Summary of this function goes here
%   Detailed explanation goes here
face_fnames = dir([dirname '*.bmp']);

if length(varargin) == 1
    ni = varargin{1};
else
    ni = length(face_fnames);
end
ii_ims = zeros(19*19,ni);


for i = 1:ni
    im_fname = [dirname, face_fnames(i).name];
    [ ~, ii_im] = LoadImage(im_fname);
    ii_ims(:,i) = ii_im(:);
end

end

