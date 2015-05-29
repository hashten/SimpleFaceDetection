function [ scs ] = ApplyDetector( Cparams, ii_ims, varargin )
% This function applies your strong classifier to a set of test images. It takes
% as input the parameters of your classifier Cparams and an array of integral
% images, ii_ims, computed from a normalized version of your test images, such
% that each integral image is a column of ii ims. It extracts each feature used
% in the strong classifier from the test images and then computes a weighted
% sum of the weak classifier outputs. The function returns for each test image
% the score

ni = size(ii_ims,2); % The number of images
Thetas=Cparams.Thetas;
theFeatures = Thetas(:,1);


if nargin == 4
    mu = varargin{1};
    im_std = varargin{2};
    fs = Cparams.fmat(theFeatures,:)*ii_ims + ...
    bsxfun(@times,repmat((Cparams.all_ftypes(theFeatures,1)==3).*Cparams.all_ftypes(theFeatures,4)...
    .* Cparams.all_ftypes(theFeatures,5),[1 ni]),mu); % The featurevectors of each image is in columns and each column
                                             % should be divided by an
                                             % individual std and mu that
                                             % are in rows then.
    fs = bsxfun(@times,fs,1./im_std);
else
    fs = Cparams.fmat(theFeatures,:)*ii_ims; %The features on the images
% calculated with normalized ii_ims.
end




p = Cparams.Thetas(:,3);
thetas = Thetas(:,2);
alphas = Cparams.alphas;
% for i = 1:ni
%     scs(i) = sum(alphas.*((p.*fs(:,i) < p.*thetas)*2-1));
% end
scs = alphas*((bsxfun(@lt,bsxfun(@times,fs,p), p.*thetas)).*2-1);


end

