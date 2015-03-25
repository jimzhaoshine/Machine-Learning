clear all;
clc;
close all;

%% load feature data

load(fullfile('data','species.mat'));
% get fieldnames from field
structField = 'everything_props';
eval(['featureNames = fieldnames( species(1).sample(1).' structField ');']);
numFields = length(featureNames);
numSpecies = length(species);
features0=[];
groundTruth0=[];
for z = 1:numSpecies
    disp(species(z).name);
    val = zeros(species(z).numFiles,numFields);
    for i = 1:species(z).numFiles
        for j = 1:numFields
            eval(['val(i,j) = species(z).sample(i).' structField '.' featureNames{j} ';']);
        end
    end
    features0 = [features0; val];
    groundTruth0 = [groundTruth0; repmat({species(z).name},species(z).numFiles,1)];
end
%%
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

features0=[features0,features1];
groundTruth0=[groundTruth1];
%
load(fullfile('data','header.mat'))
%%
numpair=numSpecies;
numpic=length(groundTruth0);
features=features0;
for ispec=1:numSpecies
    %%
    
    display(['process type: ',speciesNames{ispec}]);
    ind2=find(~strcmp(groundTruth0,speciesNames{ispec}));
    groundTruth=groundTruth0;
    groundTruth(ind2)={'0'};
    display(['percentage of species =',num2str(1-length(ind2)/numpic)]);
    tic
    svm=fitcsvm(features,groundTruth,...
    'KernelFunction','rbf','BoxConstraint',100,...
    'KernelScale',5,'Standardize','on','Prior','empirical');
    svm=svm.fitPosterior;
    eval(['save(''classifier save\svm one vs all 2\',num2str(ispec),''',''svm'')']);
    toc
end
%% load svm classifiers
svms=cell(1,numSpecies);
tic
for i=1:numSpecies
    load(['classifier save\svm one vs all 2\',num2str(i),'.mat']);
    svms{i}=svm;
%     save(['classifier save\svm one vs all\',num2str(i),'.mat'],'svm');
end
toc
%% calculate the probability for test pictures

prob=zeros(size(features0,1),numSpecies);
for i=1:numSpecies
    tic
    [label,probscore]=predict(svms{i},features0);
    toc
    prob(:,i)=probscore(:,2);
end
prob2=prob./(sum(prob,2)*ones(1,numSpecies));
% prob3=prob;
% for i=1:numSpecies
%     for j=1:numSpecies
%         if j~=i
%             prob(:,i) = prob(:,i).*(1-prob(:,j));
%         end
%     end
% end
% prob2=prob3./(sum(prob3,2)*ones(1,numSpecies));

[score,classscores]=CalculateScore( prob2,groundTruth0,speciesNames)

