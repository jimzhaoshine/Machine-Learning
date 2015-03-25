function I=ImageMoment(img)
% calculate the 6 affline invariant moment for image recognition

%x y coordinate
[sy,sx]=size(img);
[x,y]=meshgrid(1:sx,1:sy);

%calculate center
cx=mean(mean(img.*x));
cy=mean(mean(img.*y));

% readjust x y 
x=x-cx;
y=y-cy;

%%
for i=0:4
    for j=0:4
        eval(['u',num2str(i),num2str(j),'=mean(mean(img.*(x.^i).*(y.^j)));']);
    end
end

%%
% I1= 1/u(1,1)^4*(u(3,1)*u(1,3)^2-u(2,2)^2);
% I2 = (u(4,1)^2*u(1,4)^2-6*u(4,1)*u(3,2)*u(2,3)+4*u(4,1)*u(2,3)^3 ...
% +4*u(3,2)^3*u(1,4)-3*u(3,2)^2*u(2,3)^2)/u(1,1)^10;
I1=(u20*u02-u11^2)/u00^4;
I2=(u30^2*u03^2-6*u30*u21*u12*u03+4*u30*u12^3+4*u21^3*u03-3*u21^2*u12^2)/u00^10;
I3=(u20*(u21*u03-u12^2)-u11*(u30*u03-u21*u12)+u02*(u30*u12-u21^2))/u00^7;
I4=(u20^3*u03^3-6*u20^2*u11*u12*u03-6*u20^2*u02*u21*u03+9*u20^2*u02*u12^2 ...
    +12*u20*u11^2*u21*u03+6*u20*u11*u02*u30*u03-18*u20*u11*u02*u21*u12 ...
    -8*u11^3*u30*u03-6*u20*u02^2*u30*u12+9*u20*u02^2*u21^2+12*u11^2*u02*u30*u12 ...
    -6*u11*u02^2*u30*u21+u02^3*u30^2)/u00^11;
I5=(u40*u04-4*u31*u13+3*u22^2)/u00^6;
I6=(u40*u04*u22+2*u31*u22*u13-u40*u13^2-u04*u31^2-u22^3)/u00^9;

I=[I1,I2,I3,I4,I5,I6];
end