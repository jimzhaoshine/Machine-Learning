function [ prob ] = RearrangeScore( B, probScore )
% rearrange the probability matrix to the right probability
ClassNames=cellfun(@str2num,B.ClassNames);
prob=zeros(size(probScore));
for i=1:length(ClassNames)
    prob(:,ClassNames(i))=probScore(:,i);
end


end

