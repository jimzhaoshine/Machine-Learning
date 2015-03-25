function [ negloss] = SVMoptfunFP( features,groundTruth,...
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
[scoresvm,scoretransform]= fitSVMPosterior(svm);
% toc
%%
[~,probs] = kfoldPredict(scoresvm);

negloss=CalculateScore( probs,groundTruth,svm.ClassNames );
    
    display(['For boxconstraint=',num2str(boxconstraint),...
        ' and kernelscale=',num2str(kernelscale)]);
    display(['negloss =',num2str(negloss)]);
toc
end

