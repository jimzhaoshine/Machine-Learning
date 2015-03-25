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
%
load(fullfile('data','header.mat'))
%%
numpair=numSpecies;
numpic=length(groundTruth0);
features=features0;
for ispec=1%:numSpecies
    %%
    tic
    display(['process type: ',speciesNames{ispec}]);
    ind2=find(~strcmp(groundTruth0,speciesNames{ispec}));
    groundTruth=groundTruth0;
    groundTruth(ind2)={'0'};
    display(['percentage of species =',num2str(1-length(ind2)/numpic)]);
    %create partition
    partition= cvpartition(numpic,'KFold',8);
    %construct minimization function
    %     minfn=@(z)SVMoptfun(features,groundTruth,partition,exp(z(1)),exp(z(2)));
    minfn=@(bc,ks)SVMoptfun(features,groundTruth,partition,bc,ks);
    %minimize minfn
%     range= exp(1:.5:6);
%     range= exp(-1:.25:1);
    range=exp(-1:0.5:4);
    lr=length(range);
    fmin=zeros(lr,lr);
    precisions=zeros(lr,lr);
    recalls=zeros(lr,lr);
    for bci = 1:lr
        for ksi = 1:lr
            boxconstraint=range(bci);
            kernelscale=range(ksi);
            [ fmin(bci,ksi),precisions(bci,ksi),recalls(bci,ksi) ] = SVMoptfun( features,groundTruth,...
                partition,boxconstraint,kernelscale);
        end
    end
    %     opts=optimset('TolX',5e-4,'TolFun',5e-4,'display','iter');
    %     z0=[0 0];%randn(2,1);
    %     [searchmin fval]=fminsearch(minfn,z0,opts);
    toc
end
save('data3','precisions','recalls');
%%
numpair=numSpecies;
numpic=length(groundTruth0);
features=features0;
for ispec=1%:numSpecies
    %%
    result=cell(1,10);
    for ii=1:10
    tic
    display(['process type: ',speciesNames{ispec}]);
    ind2=find(~strcmp(groundTruth0,speciesNames{ispec}));
    groundTruth=groundTruth0;
    groundTruth(ind2)={'0'};
    display(['percentage of species =',num2str(1-length(ind2)/numpic)]);
    %create partition
    partition= cvpartition(numpic,'KFold',8);
    %construct minimization function
    minfn=@(z)SVMoptfunFP(features,groundTruth,partition,exp(z(1)),exp(z(2)));
    opts=optimset('TolX',1e-2,'TolFun',1e-2,'display','iter');
    z0=randn(2,1);
    [searchmin,fval]=fminsearch(minfn,z0,opts);
    ii
    result{ii}.z0=z0;
    result{ii}.searchmin=searchmin;
    result{ii}.fval=fval;
    end
end


save('svmconverge','result');