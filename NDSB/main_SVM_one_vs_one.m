clear all;
clc;
close all;

%%

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
load(fullfile('data','header.mat'))
numpair=numSpecies*(numSpecies-1)/2;
svmpairall(1:numpair)=struct('ispec',[],'jspec',[],'svmm',[],'classloss',[],...
    'logloss',[],'cvsvmm',[],'scores',[],'scoresvmm',[]);
trackind=0;

for ispec=1:numSpecies-1
    for jspec=ispec+1:numSpecies
        %%
        tic
%         disp('gathering features from:');
        features = []; groundTruth = [];
        for z = [ispec,jspec]
            ind1=find(strcmp(groundTruth0,speciesNames{ispec}));
            ind2=find(strcmp(groundTruth0,speciesNames{jspec}));
            features = [features0(ind1); features0(ind2);];!!!!!
            !!!! major bugg up
            groundTruth = [groundTruth0(ind1); groundTruth0(ind2)];
        end
        % svm classifier
        % disp('starting multiclass SVM classifier');
        options = statset('UseParallel',0);
        SVMModel = fitcsvm(features,groundTruth,'KernelFunction','RBF','Standardize',true,...
            'KernelScale','auto');...
            CVSVMModel=crossval(SVMModel);
        classLoss = kfoldLoss(CVSVMModel);
        % display(['cross validation classLoss:',num2str(classLoss)]);
        ScoreSVMModel = fitPosterior(SVMModel,features,groundTruth);
        [label,score]=predict(ScoreSVMModel,features);
        loglossscore=CalculateScore(score,groundTruth,ScoreSVMModel.ClassNames);
        % display(['logloss score:',num2str(loglossscore)]);
        % save
        trackind=trackind+1;
        svmpairall(trackind).ispec=ispec;
        svmpairall(trackind).jspec=jspec;
        svmpairall(trackind).svmm=SVMModel;
        svmpairall(trackind).cvsvmm=CVSVMModel;
        svmpairall(trackind).scoresvmm=ScoreSVMModel;        
        svmpairall(trackind).scores=score;
        svmpairall(trackind).classloss=classLoss;
        svmpairall(trackind).logloss=loglossscore;
        toc
    end
end

%% resave svm  and save
svmpairall2=cell(size(svmpairall));
for ispec=1:numSpecies-1
    for jspec=ispec+1:numSpecies
                svmpairall(trackind).ispec=ispec;
        svmpairall(trackind).jspec=jspec;
        svmpairall(trackind).svmm=SVMModel;
        svmpairall(trackind).cvsvmm=CVSVMModel;
        svmpairall(trackind).scoresvmm=ScoreSVMModel;        
        svmpairall(trackind).scores=score;
        svmpairall(trackind).classloss=classLoss;
        svmpairall(trackind).logloss=loglossscore;

    end
end
% save('svmonevsone1.mat','svmpairall')
%% 
tclassloss=zeros(numSpecies,numSpecies);
for i=1:length(svmpairall)
    data=svmpairall(i);
    ispec=data.ispec;
    jspec=data.jspec;
    tclassloss(ispec,jspec)=data.logloss;
    tclassloss(jspec,ispec)=data.logloss;
end

% imagesc(1-tclassloss,[0 1]);axis image;colormap jet;colorbar;

SI(tclassloss>0.4);


