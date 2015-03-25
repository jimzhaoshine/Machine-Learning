function [ minfun,precision,recall ] = SVMoptfun( features,groundTruth,...
    partition,boxconstraint,kernelscale)
%construct a function to evaluate the SVM function,
%used to train svm for the right boxconstraint and kernalscale
tic

%% train partitioned svm
% display('train partitioned svm')
% tic
svm=fitcsvm(features,groundTruth,'CVPartition',partition,...
    'KernelFunction','rbf','BoxConstraint',boxconstraint,...
    'KernelScale',kernelscale,'Standardize','on','Prior','empirical');
% toc
%%
NegativeName='0';
PositiveName=svm.ClassNames{~strcmp(svm.ClassNames,'0')};
PosInd=(strcmp(groundTruth,PositiveName));
NegInd=(strcmp(groundTruth,NegativeName));

%predict loss
%loop through partition
% display('Calculate recision and recall rate');
% tic
kfold=svm.KFold;
TPs=zeros(1,kfold);
FPs=zeros(1,kfold);
FNs=zeros(1,kfold);
for i=1:kfold
    svmcompact=svm.Trained{i};
    testInd=test(partition,i);
%     testPos=testInd & PosInd;
%     testNeg=testInd & NegInd;
    label=predict(svmcompact,features(testInd,:));
    PredictPos=(strcmp(label,PositiveName));
    PredictNeg=(strcmp(label,NegativeName));
    TPs(i)=sum(PredictPos & PosInd(testInd));
    FPs(i)=sum(PredictPos & ~PosInd(testInd));
    FNs(i)=sum(~PredictPos & PosInd(testInd));
end
% toc
%%
%calculate precision and recall and minfun
    TP=sum(TPs);
    FP=sum(FPs);
    FN=sum(FNs);
    precision=TP/(TP+FP);
    recall=TP/(TP+FN);
    minfun=1-precision*recall;
    
    display(['For boxconstraint=',num2str(boxconstraint),...
        ' and kernelscale=',num2str(kernelscale)]);
    display(['precision =',num2str(precision),' recall=',num2str(recall)]);
toc
end

