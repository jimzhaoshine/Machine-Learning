%obsolete

clear all;
clc;
close all;


load(fullfile('data','species.mat'));
numSpecies = length(species);

%%
% get fieldnames from field
structField = 'everything_props';
eval(['featureNames = fieldnames( species(1).sample(1).' structField ');']);
numFields = length(featureNames);

disp('gathering features from:');
features = []; groundTruth = [];
for z = 1:numSpecies
    disp(species(z).name);
    val = zeros(species(z).numFiles,numFields);
    for i = 1:species(z).numFiles
        for j = 1:numFields
            eval(['val(i,j) = species(z).sample(i).' structField '.' featureNames{j} ';']);
        end
    end
    features = [features; val];
    groundTruth = [groundTruth; repmat({species(z).name},species(z).numFiles,1)];
end

structField = 'ImageMoment';
% eval(['featureNames = fieldnames( species(1).sample(1).' structField ');']);
numFields = 6;%length(featureNames);
numSpecies = length(species);
features1=[];
groundTruth1=[];
for z = 1:numSpecies
    disp(species(z).name);
    val = zeros(species(z).numFiles,numFields);
    for i = 1:species(z).numFiles
            eval(['val(i,:) = species(z).sample(i).' structField ';']);
    end
    features1 = [features1; val];
    groundTruth1 = [groundTruth1; repmat({species(z).name},species(z).numFiles,1)];
end

features=[features,features1];
groundTruth=[groundTruth1];

%% multi svm classifier
tic
disp('starting multiclass SVM classifier');
options = statset('UseParallel',1);
t=templateSVM('KernelFunction','rbf','KernelScale',5,'BoxConstraint',80,'Standardize',1);
Mdl = fitcecoc(features,groundTruth,...
    'coding','onevsone',...
    'FitPosterior',1,....
    'Learners',t,...
    'Verbose',1,...
    'options',options);

toc
%%
% [label,Negloss,probscore,Posterior] = kfoldPredict(Mdl,'Verbose',1);
% a=kfoldPredict(Mdl,);
%%
% features1=features(1:50:end,:);
tic
[label,negloss,probscore,priorprob]=predict(Mdl,features);
toc
save('allsvm.mat','label','negloss','probscore','priorprob');
%%

resubPredict(Mdl);
%%
% groundTruth1=groundTruth(1:50:end,:);
CalculateScore(probscore,groundTruth,Mdl.ClassNames)




