%quick test
boxconstraint=zeros(size(result));
kernelscale=zeros(size(result));
fval=zeros(size(result));
for i=1:length(result)
    boxconstraint(i)=result{i}.z0(1);
    kernelscale(i)=result{i}.z0(2);
    fval(i)=result{i}.fval;
end
% plot3(boxconstraint,kernelscale,fval,'.')
plot(boxconstraint,kernelscale,'.')