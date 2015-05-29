function [ output_args ] = SaveTrainingData( all_ftypes, train_inds, s_fn )
%SAVETRAININGDATA Summary of this function goes here
%   Detailed explanation goes here

ni = 10;
ii_imsF = LoadImDataDir('TrainingImages/FACES/');
ii_imsNF = LoadImDataDir('TrainingImages/NFACES/');
ii_ims_all = [ii_imsF ii_imsNF]; 
ys_all = [ones(size(ii_imsF(1,:))) -1*ones(size(ii_imsNF(1,:)))];
fmat = VecAllFeatures(all_ftypes, 19, 19);

ii_ims = ii_ims_all(:,train_inds);
ys = ys_all(train_inds);
W = 19
H = 19
save(s_fn, 'ii_ims_all', 'ys_all', 'ii_ims', 'ys', 'fmat', 'all_ftypes', 'W', 'H','train_inds');
end

