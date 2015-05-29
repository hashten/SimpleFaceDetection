function [ scs ] = ComputeROC( Cparams, Tdata )
%COMPUTEROC Summary of this function goes here
%   Detailed explanation goes here
noTrain_inds = setdiff(1:size(Tdata.ii_ims_all,2),Tdata.train_inds);

scs = ApplyDetector(Cparams,Tdata.ii_ims_all(:,noTrain_inds))';
ys = Tdata.ys_all(noTrain_inds)'; %Picks out the ys that wasnt in training.
steps = 100;
fpr = zeros(steps,1);
tpr = zeros(steps,1);
thresholds = linspace(min(scs),max(scs),steps);
for i = 1:steps
    thr = thresholds(i);
    positives = scs>thr;
    negatives = positives==0;
    real_pos = ys==1;
    real_neg = ys==-1;
%   n_tp = sum((positives+real_pos)==2);
    n_tp = sum((positives==1 & real_pos==1)); %This is the same as...
    n_fn = sum((negatives+real_pos)==2);      %this row!
    
    n_fp = sum((positives+real_neg)==2);
    n_tn = sum((negatives+real_neg)==2);
    tpr(i) = n_tp/(n_tp+n_fn);
    if i>1
        if abs(tpr(i)-0.7)<abs(tpr(i-1)-0.7)
            goodIndex = i;
        end
    end
    fpr(i) = n_fp/(n_tn+n_fp);
end
display(['The threshold that results in a tpr closest to 0.7 is:' num2str(thresholds(goodIndex))]);
%With 10000 steps i get threshold = 1.7631
plot(fpr,tpr);
xlabel('fpr');
ylabel('tpr');
end

