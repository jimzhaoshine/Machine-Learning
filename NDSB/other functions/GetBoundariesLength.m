function [ L ] = GetBoundariesLength( bb )
%% calculate the length of boundary cell array
L=zeros(size(bb));
for i=1:length(bb)
    x=bb{i}(:,2);
    y=bb{i}(:,1);
    dx=diff(x);
    dy=diff(y);
    dr=sqrt(dx.^2+dy.^2);
    L(i)=sum(dr);
end

end

