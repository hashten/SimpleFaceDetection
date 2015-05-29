function [ im, ii_im ] = LoadImage( im_fname )
%LOADIMAGE Summary of this function goes here
%   Detailed explanation goes here

im = double(imread(im_fname));
mean_im = mean(im(:));
std_im = std(im(:));

if std_im==0
    std_im = std_im + 0.0001;
end

im = (im - mean_im) / std_im;
ii_im = cumsum(cumsum(im,2),1);
end

