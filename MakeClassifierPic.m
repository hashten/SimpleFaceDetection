function [ cpic ] = MakeClassifierPic( all_ftypes, chosen_f, alphas, ps, W, H )
%MAKECLASSIFIERPIC Summary of this function goes here
%   Detailed explanation goes here

cpic = zeros(H, W);
w = alphas.*ps;
for i = 1:length(chosen_f)
    fpic = MakeFeaturePic(all_ftypes(chosen_f(i), :),W,H);
    cpic = cpic + w(i)*fpic;
end
    
end

