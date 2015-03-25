function [ score, classscores ] = CalculateScore( prob,groundTruth,classnames )
%calculate the score
N=size(prob,1);
prob=max(min(prob,1-1e-15),1e-15);
numground=length(groundTruth);
groundind=zeros(1,numground);
for i=1:length(classnames)
    groundind(strcmp(groundTruth,classnames{i}))=i;
end


ind=sub2ind(size(prob),1:N,groundind);
score=-mean(log(prob(ind)));

classscores=zeros(1,length(classnames));
for i=1:length(classnames)
    classind=find(groundind==i);
    ind=sub2ind(size(prob),classind,groundind(classind));
    classscores(i)=-mean(log(prob(ind)));
end
end

