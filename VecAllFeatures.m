function [ fmat ] = VecAllFeatures( all_ftypes, W, H )
%VECALLFEATURES Summary of this function goes here
%   fmat has the VecFeature of all rows in EnumAllFeatures as rows 
%   Since Vecfeature uses VecBoxSum which makes vectors of size W*H, the
%   size of fmat will be:
%                         fmat:  nf x W*H

nf = size(all_ftypes,1);
fmat = zeros(nf,W*H);


%   format of all_ftypes: [ type x y w h ]
%                           typ  x y w h ]
%                            .   . . . . ]
%                 row nf: [ type x y w h ]     nf x 5
%   VecFeature:  1 x W*H
for i = 1:nf
    fmat(i,:) = VecFeature(all_ftypes(i,:),W,H);
end

end

