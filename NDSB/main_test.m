% main test
% clear all;
% close all
%% get features
if ~exist(fullfile('data','testEverythingProps.mat'))
    %%
    load(fullfile('data','testpics.mat'));
    % features(size(testpic))=struct
    prop1=EverythingProps(double(testpic(1).image));
    props(size(testpic))=prop1;
    N=length(testpic);
    for i=1:length(testpic)
        if mod(i,1000)==0
            display(i/N);
        end
        %     img=double(testpic(i).img);
        props(i)=EverythingProps(double(testpic(i).image));
    end
    save(fullfile('data','testEverythingProps.mat'),'props');
end
%% get features 2 image moment
if ~exist(fullfile('data','testImageMoment.mat'))
    %%
    load(fullfile('data','testpics.mat'));
    % features(size(testpic))=struct
    prop1=EverythingProps(double(testpic(1).image));
    props(size(testpic))=prop1;
    N=length(testpic);
    for i=1:length(testpic)
        if mod(i,1000)==0
            display(i/N);
        end
        %     img=double(testpic(i).img);
        props(i)=EverythingProps(double(testpic(i).image));
    end
    save(fullfile('data','testImageMoment.mat'),'props');
end
%% set up header
if ~exist(fullfile('data','header.mat'))
    load(fullfile('data','testpics.mat'));
    load(fullfile('data','species.mat'));
    pictureNames={testpic.name};
    speciesNames={species.name};
    save(fullfile('data','header.mat'),'pictureNames','speciesNames');
end
%% 
load(fullfile('data','header.mat'));
load(fullfile('data','testEverythingProps.mat'));
props=[props1,props2];
featureNames=fieldnames(props);
numFeatures=length(featureNames);
numTest=length(props);
numSpecies=length(speciesNames);
featureTest=zeros(numTest,numFeatures);

for i=1:length(props)
    if ~isempty(props(i));
        % if empty, put all zero
        for j=1:numFeatures
            eval(['featureTest(i,j)=props(i).',featureNames{j},';']);
        end
    end
end

%% load svm classifiers
svms=cell(1,numSpecies);
for i=1:numSpecies
    load(['classifier save\svm one vs all 2\',num2str(i),'.mat']);
    tic
    svms{i}=svm;
    toc
%     save(['classifier save\svm one vs all\',num2str(i),'.mat'],'svm');
end
%%
%% calculate the probability for test pictures
prob=zeros(numTest,numFeatures);
for i=1:numSpecies
    tic
    [label,probscore]=predict(svms{i},featureTest);
    prob(:,i)=probscore(:,2);
    toc
end
prob2=prob./(sum(prob,2)*ones(1,numSpecies));
save('probscore','prob')


%% write result
WriteResult(prob2,'result2.csv');



