function [ Cparams ] = BoostingAlg( Tdata, T )
% The inputs to this function are the training data obtained from the 
% positive and negative images and the number of weak classiers T to 
% include in the final strong classifier. The output is then the structure 
% representing the final classifier.

% Extracting variables from Tdata
fmat = sparse(Tdata.fmat); 
ii_ims = Tdata.ii_ims;
all_ftypes=Tdata.all_ftypes;
ys = Tdata.ys;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here one change the number of features to run the program with:
fs = (fmat*ii_ims)';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


nf = size(fs,2);     %These rows was used for the non-vectorized solution
errors = zeros(1,nf);
thetas = zeros(1,nf);
p      = zeros(1,nf);

m = sum(ys==-1);
n = length(ys);
ws = [1/(2*(n-m)) * ones(n-m,1); 1/(2*m) * ones(m,1)]; % training_im x 1



Thetas = zeros(T,3);   %(chosen_f, theta, p)
alphas = zeros(1,T);

ys_t = ys';
ys_p = sparse(ys+1);
ys_m = sparse(ys-1);
for t = 1:T
    t
    ws = ws/sum(ws);
    pos_w = (ys_p*ws);
    neg_w = (ys_m*ws);
%%%%%%%%%%%%%%%%%% Non-Vectorized Version %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:nf
        fs_i = fs(:,i);
        thetas_i = thetas(i);
        a = (ws.*fs_i);
        mu_p = ys_p*a / pos_w;
        mu_n = ys_m*a / neg_w;
        thetas(i) = 0.5*(mu_p+mu_n);
        err_n = 0.5 * sum( ws.*abs(ys_t-((-1*fs_i < -1*thetas_i)*2-1)));
        err_p = 0.5 * sum( ws.*abs(ys_t-((1*fs_i < 1*thetas_i)*2-1)));
        [errors(i), min_ind] = min([err_n err_p]);
        p(i) = (min_ind-1)*2-1;
    end
    [err, j] = min(errors);
    Thetas(t,:) = [j, thetas(j), p(j) ];
    alphas(t) = 0.5 * log((1-err)/err);
    ws = ws .* exp(-alphas(t)*ys_t.*((p(j)*fs(:,j) < p(j)*thetas(j))*2-1));
%%%%%%%%%%%%%%%%%%%%%%% Vectorized version %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     ws_t = ws';
%     A = bsxfun(@times,fs,ws);
%     MU_P = ys_p*A/pos_w;
%     MU_N = ys_m*A/neg_w;
%     THETAS=0.5*(MU_P+MU_N);
%     ERR_N = 0.5*ws_t*abs(bsxfun(@plus,-(2*bsxfun(@lt,-fs,-THETAS)-1),ys_t));
%     ERR_P = 0.5*ws_t*abs(bsxfun(@plus,-(2*bsxfun(@lt,fs,THETAS)-1),ys_t));
%     [errors, min_ind] = min([ERR_N; ERR_P]);
%     p = (min_ind-1)*2-1;
%     [err, j] = min(errors);
%     Thetas(t,:) = [j, THETAS(j), p(j) ];
%     alphas(t) = 0.5 * log((1-err)/err);
%     ws = ws .* exp(-alphas(t)*ys_t.*((p(j)*fs(:,j) < p(j)*THETAS(j))*2-1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

Cparams = struct('alphas',alphas,'Thetas',Thetas,'fmat',fmat,'all_ftypes',all_ftypes);



end

