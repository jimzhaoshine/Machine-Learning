clear all;
clc;
close all;

%% load data

load('species.mat');

numSpecies = length(species);

%% total intensity likelihood 


% calculate intensity CDF of training set
train = struct([]);
for z = 1:numSpecies
    intensity = cell(species(z).numFiles,1);
    for k = 1:species(z).numFiles
        intensity{k} = 255 - species(z).sample(k).img(:);
    end
    train(z).vals = intensity;
end

% generate empirical Probabilities for each cdf point
bin = 4;
cdfEdges = 0:bin:255;
CDF = GenerateCDF(train,cdfEdges);

figure; hold on;
colorSet = hsv(numSpecies);
for z = 1:numSpecies
    plot(cdfEdges,mean(CDF{z},2),'color',colorSet(z,:));
end
% 
% figure; hold on;
% colorSet = hsv(numSpecies);
% for z = 1:numSpecies
%     for j = 1:size(CDF{z},2);
%         plot(cdfEdges,CDF{z}(:,j),'color',colorSet(z,:));
%     end
% end
% 

approx = 1; % Gaussian approximation
probEdges = 0:.001:1;
empiricalProb = GenerateProbCDF(CDF,probEdges,approx);

% Calculate likelihood of cumulative intensities
likelihood = TrainLikelihoodCDF(CDF,empiricalProb,cdfEdges,probEdges);

% calculate average likelihood
sumP = sum(likelihood{z}(1:end),2);
aveLikelihood(:,z) = sumP/sum(sumP);
figure; imagesc(aveLikelihood);


%% partial intensity likelihood

% calculate intensity CDF of training set
train = struct([]);
for z = 1:numSpecies
    intensity = cell(species(z).numFiles,1);
    for k = 1:species(z).numFiles
         img = 255-species(z).sample(k).img(:);

         mask = 2;
         [fimg noise] = wiener2(img,[mask mask]);
         
         bimg = im2bw(fimg,.1);
         
         intensity{k} = double(img(bimg==1));
    end
    train(z).vals = intensity;
end

% generate empirical Probabilities for each cdf point
bin = 4;
cdfEdges = 0:bin:255;
CDF = GenerateCDF(train,cdfEdges);

figure; hold on;
colorSet = hsv(numSpecies);
for z = 1:numSpecies
    plot(cdfEdges,mean(CDF{z},2),'color',colorSet(z,:));
end

approx = 1; % Gaussian approximation
probEdges = 0:.001:1;
empiricalProb = GenerateProbCDF(CDF,probEdges,approx);

z = 8;
figure;
plot(probEdges,empiricalProb{z}');

% Calculate likelihood of cumulative intensities
likelihood = TrainLikelihoodCDF(CDF,empiricalProb,cdfEdges,probEdges);


% calculate average likelihood
aveLikelihood = zeros(numSpecies);
for z = 1:numSpecies
    sumP = sum(likelihood{z}(:,1:end-1),2);
    aveLikelihood(:,z) = sumP/sum(sumP);
end
figure; imagesc(aveLikelihood);


% sse between mean CDF
prob = TrainDistanceCDF(CDF);

% calculate average likelihood
aveProb= zeros(numSpecies);
for z = 1:numSpecies
    sumP = sum(prob{z},2);
    aveProb(:,z) = sumP/sum(sumP);
end
figure; imagesc(aveProb);


%% other features (intensity, size, eccentricity)

% calculate intensity CDF of training set
MAX = 0;
train = struct([]);
for z = 1:numSpecies
    disp(species(z).name);
    
    intensity = zeros(species(z).numFiles,1);
    numPixels = zeros(species(z).numFiles,1);
    eccentricity = zeros(species(z).numFiles,1);
    for k = 1:species(z).numFiles
         img = 255-species(z).sample(k).img;
%          mask = 2;
%          [fimg noise] = wiener2(img,[mask mask]);
         bimg = im2bw(img,.1);
         
         % total intensity
         intensity(k) = sum(img(find(bimg==1)));
         
         % size
         numPixels(k) = length(find(bimg==1));

         % eccentricity
         [y x] = find(bimg==1);
         C = cov(x,y);
         [vec val] = eig(C);
         val = diag(val);
         eccentricity(k) = val(2)/val(1);
         
    end
    train(z).vals = [intensity numPixels eccentricity];
end


%%


X = []; Y = [];
for z = 1:numSpecies
    
    intensity = zeros(species(z).numFiles,1);
    for k = 1:species(z).numFiles
        intensity(k) = sum(255 - species(z).sample(k).img(:));
    end
    
    X = [X; train(z).vals intensity];
    Y = [Y; ones(size(train(z).vals,1),1)*z];
end

nTrees = 100;
B = TreeBagger(nTrees,X,Y,'method','classification','NVarToSample','all','OOBVarImp','On','CategoricalPredictors','all');

figure; 
oobErrorBaggedEnsemble = oobError(B);
plot(oobErrorBaggedEnsemble)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';


%%

[YFIT,SCORES] = predict(B,X);

figure; imagesc(SCORES);










