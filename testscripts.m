dinfo1 = load('DebugInfo/debuginfo1.mat');
[im, ii_im] =LoadImage('TrainingImages/FACES/face00001.bmp');
montage({im/max(max(im)), ii_im/max(max(ii_im))}, 'size', [1 2]);
% imagesc(ii_im);
eps = 1e-6;
s1 = sum(abs(dinfo1.im(:) - im(:)) > eps)
s2 = sum(abs(dinfo1.ii_im(:) - ii_im(:)) > eps)

%% Test program 2 (A1 and A2 should be the same)
x = 2;
y = 2;
w = 3;
h = 3;
b_vec = VecBoxSum(x, y, w, h, 19, 19);
A1 = b_vec * ii_im(:)
A2 = sum(sum(im(y:y+h-1, x:x+w-1)))

%% Test Program 3 (A1 and A2 should be the same)
x = 2;
y = 2;
w = 3;
h = 3;
display('Result of feature 1 calculations:');
ftype_vec = VecFeature([1, x, y, w, h], 19, 19);
A1 = ftype_vec * ii_im(:) 
b0 = sum(sum(im(y:y+h-1, x:x+w-1)));
b1 = sum(sum(im(y+h:y+2*h-1, x:x+w-1)));
A2 = b0 - b1
display('Result of feature 2 calculations:');
ftype_vec = VecFeature([2, x, y, w, h], 19, 19);
A1 = ftype_vec * ii_im(:) 
b0 = sum(sum(im(y:y+h-1, x:x+w-1)));
b1 = sum(sum(im(y:y+h-1, x+w:x+2*w-1)));
A2 = -b0 + b1
display('Result of feature 3 calculations:');
ftype_vec = VecFeature([3, x, y, w, h], 19, 19);
A1 = ftype_vec * ii_im(:) 
b0 = sum(sum(im(y:y+h-1, x:x+w-1)));
b1 = sum(sum(im(y:y+h-1, x+w:x+2*w-1)));
b2 = sum(sum(im(y:y+h-1, x+2*w:x+3*w-1)));
A2 = -b0 + b1 -b2
display('Debug should give zeros:');
dinfo2 = load('DebugInfo/debuginfo2.mat');
fs = dinfo2.fs; W=19; H=19;
abs(fs(1) - VecFeature(dinfo2.ftypes(1, :), W, H)* ii_im(:)) > eps
abs(fs(2) - VecFeature(dinfo2.ftypes(2, :), W, H)* ii_im(:)) > eps
abs(fs(3) - VecFeature(dinfo2.ftypes(3, :), W, H)* ii_im(:)) > eps
abs(fs(4) - VecFeature(dinfo2.ftypes(4, :), W, H)* ii_im(:)) > eps

%% Test Program 4
all_ftypes = EnumAllFeatures(19,19);
correct = (all_ftypes(:,2)+all_ftypes(:,4)-1<=19) & (all_ftypes(:,3)+all_ftypes(:,5)-1<=19);
sum(correct)
[M I] = max(all_ftypes)
all_ftypes(I,:)

%% Test Program 5
dinfo3 = load('DebugInfo/debuginfo3.mat');
fmat = VecAllFeatures(dinfo3.all_ftypes, W, H);
sum(abs(dinfo3.fs - fmat * ii_im(:)) > eps)

%% Test program 6
dinfo4 = load('DebugInfo/debuginfo4.mat');
ni = 100;
ii_ims = LoadImDataDir('TrainingImages/FACES/',ni);
fmat = VecAllFeatures(dinfo4.all_ftypes, 19, 19);
sum(sum(abs(dinfo4.fmat-fmat)> eps))
sum(sum(abs(dinfo4.ii_ims-ii_ims)> eps))
fs = fmat*ii_ims;
sum(sum(abs(dinfo4.fs-fs)> eps))

%% Test program 7
% WARNING WARNING WARNING WARNING WARNING: slow segment!
dinfo5 = load('DebugInfo/debuginfo5.mat');
train_inds = dinfo5.train_inds;
all_ftypes = dinfo5.all_ftypes;
SaveTrainingData(all_ftypes, train_inds, 'training_data.mat');


%% PART II Load variables

Tdata = load('training_data.mat');
fmat = Tdata.fmat; 
ii_ims = Tdata.ii_ims;
all_ftypes=Tdata.all_ftypes;
ys = Tdata.ys;
fs = fmat(12028, :)*ii_ims ;  
%% This plots the histograms of the featurerespons from all the trainingims
fig=figure;
hax=axes;
h1 = histogram(fs(ys==1),30);
hold on;
h2 = histogram(fs(ys==-1),30);
h1.Normalization = 'probability';
h1.BinWidth = 0.25;
h2.Normalization = 'probability';
h2.BinWidth = 0.25;

%% Test Program 8
m = sum(ys==-1);
n = length(ys);
ws = [1/(2*(n-m)) * ones(1,n-m) 1/(2*m) * ones(1,m)];
[theta,p,err] = LearnWeakClassifier(ws,fs,ys)

hold on;
line([theta theta],get(hax,'YLim'))
%% Test Program 9
fpic = MakeFeaturePic( [4 5 5 5 5], 19, 19 );
imagesc(-fpic);
colormap(gray);
axis image;
%% Test Program 10
cpic = MakeClassifierPic(all_ftypes, [5192, 12765], [1.8725,1.467],[1,-1],19,19);
imagesc(-cpic);
colormap(gray);
axis image;

%% Test Program 11 Look further down! (Change to 1000 features in BoostingAlg)

Cparams = BoostingAlg(Tdata,3);

%% ...and plot the results
Thetas = Cparams.Thetas;
all_ftypes = Cparams.all_ftypes;
fpic = MakeFeaturePic(all_ftypes(fs1(3,1),:),19,19);
imagesc(-fpic);
colormap(gray);
axis image;

%% ...and the cpic:
alphas=Cparams.alphas;
cpic = MakeClassifierPic( all_ftypes, Thetas(:,1), alphas, Thetas(:,3)', 19, 19 );
imagesc(-cpic);
colormap(gray);
axis image;
%% ... and the real test Program 11 (first change to 1000 features in BoostingAlg
% Then do the same with all features but T = 1
dinfo6 = load('DebugInfo/debuginfo6.mat');
T = dinfo6.T;
Cparams = BoostingAlg(Tdata, T);
Thetas = Cparams.Thetas;
all_ftypes = Cparams.all_ftypes;

fpics = cell(10,1);
for showImage = 1:10
    fpics{showImage} = -MakeFeaturePic(all_ftypes(Thetas(showImage,1),:),19,19);
end
montage(fpics,'size',[1 10]);

% sum(abs(dinfo6.alphas - Cparams.alphas)>eps)
% sum(abs(dinfo6.Thetas(:) - Cparams.Thetas(:))>eps)

%% ... and one more debug point Program 11 (change to all features in BoostingAlg
% Takes a long time and I have Cparams saved anyway...
dinfo7 = load('DebugInfo/debuginfo7.mat');
T = dinfo7.T;
Cparams = BoostingAlg(Tdata, T);

sum(abs(dinfo7.alphas - Cparams.alphas)>eps)
sum(abs(dinfo7.Thetas(:) - Cparams.Thetas(:))>eps)

%% And plot these:
% like in figure 8 in instructions!
s = load('Cparams.mat');
Cparams = s.Cparams;
Thetas = Cparams.Thetas;
all_ftypes = Cparams.all_ftypes;

pics = cell(11,1);
for showImage = 1:10
    pics{showImage} = -MakeFeaturePic(all_ftypes(Thetas(showImage,1),:),19,19);
end
pics{end} = -MakeClassifierPic( all_ftypes, Thetas(1:10,1), Cparams.alphas, Thetas(1:10,3), 19, 19 );
pics{end} = pics{end}/max(max(pics{end}));
montage(pics,'size',[1 11]);

%% TASK III - Test Program 12 
s = load('Cparams.mat');
Cparams = s.Cparams;
[~, ii_im] = LoadImage('\TrainingImages\FACES\face00001.bmp');
scs = ApplyDetector(Cparams,ii_ims(:,1:2))

%% Test Program 13
[ scs ] = ComputeROC( Cparams, Tdata );

%% TASK IV - Test Program 14
% s = load('Cparams.mat');
% im = 'TestImages/one_chris.png';
im = 'TestImages/many_faces.jpg';
% im = 'TrainingImages\FACES\face00005.bmp';
dets = ScanImageFixedSize(s.Cparams, im)
DisplayDetections(im,dets);

%% ... compared to ApplyDetector which now yields the same result!
[~,imgii]=LoadImage('TrainingImages/FACES/face00001.bmp');
scs = ApplyDetector(Cparams,imgii(:))

%% Test Program 17

im = 'TestImages/student1.jpg';
[ dets ] = ScanImageOverScale( Cparams,im,0.1,0.4,0.1)
% im = 'TestImages/many_faces.jpg';
% im = 'TestImages/big_one_chris.png';
% [ dets ] = ScanImageOverScale( Cparams,im,0.6,1.3,0.06)
DisplayDetections(im,dets);



%% Task V
T=100;
Tdata = load('training_data.mat');
Cparams_strong = BoostingAlg(Tdata, T);
save('Cparams_strong.mat','Cparams_strong');
%% Make Fpics of the 100 features
s = load('Cparams_strong.mat');
Cparams_strong = s.Cparams_strong;
Thetas = Cparams_strong.Thetas;
all_ftypes = Cparams_strong.all_ftypes;
T = 100
fpics = cell(T,1);
for showImage = 1:T
    fpics{showImage} = -MakeFeaturePic(all_ftypes(Thetas(showImage,1),:),19,19);
end
montage(fpics,'size',[T/10 10]);

%% Show the Strong Classifier pic!
Thetas = Cparams_strong.Thetas;
all_ftypes = Cparams_strong.all_ftypes;
alphas=Cparams_strong.alphas;
cpic = MakeClassifierPic( all_ftypes, Thetas(:,1), alphas, Thetas(:,3)', 19, 19 );
imagesc(-cpic);
colormap(gray);
axis image;

%% Find good thresh
Tdata = load('training_data.mat');
[ scs ] = ComputeROC( Cparams_strong, Tdata );
% thresh 4.36

%% Try it on testimages!


% im = 'TestImages/student1.jpg';
% [ dets ] = ScanImageOverScale( Cparams_strong,im,0.1,0.4,0.05)
im = 'TestImages/many_faces.jpg';
[ dets ] = ScanImageOverScale( Cparams_strong,im,1.04,1.44,0.2)
% im = 'TestImages/big_one_chris.png';
% [ dets ] = ScanImageOverScale( Cparams,im,0.6,1.3,0.06)
DisplayDetections(im,dets);









