function [ output_args ] = DisplayDetections( im, dets )
%DISPLAYDETECTIONS Summary of this function goes here
%   Detailed explanation goes here
im = imread(im);
imagesc(im);
axis equal;
for row = 1:size(dets,1)
    hold on;
    rectangle('Position',dets(row,:)) 
end
end

