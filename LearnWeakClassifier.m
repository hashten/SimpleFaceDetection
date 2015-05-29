function [ theta, p, err] = LearnWeakClassifier( ws, fs, ys )
% LEARNWEAKCLASSIFIER It takes as input:
% ws:  1xN (number of images) vector of weights associated with each training image, 
% fs: 1xN  vector containing the value of a particular feature extracted from each training image 
% ys: 1xN  and a vector of the labels associated with each training image. 
%
% The outputs are then the learnt parameters of the weak classifier and its associated error.


mu_p = sum(ws.*fs.*(1+ys)) / sum(ws.*(1+ys));
mu_n = sum(ws.*fs.*(1-ys)) / sum(ws.*(1-ys));
theta = 0.5*(mu_p+mu_n);

err_n = 0.5 * sum( ws.*abs(ys-((-1*fs < -1*theta)*2-1)));
err_p = 0.5 * sum( ws.*abs(ys-((1*fs < 1*theta)*2-1)));
err_v= [err_n err_p];
[err, i] = min(err_v);
p = (i-1)*2-1;
end

    