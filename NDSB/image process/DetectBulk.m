function [ bwf ] = DetectBulk( img )
%detect the bulk shape of the plankton

% %detect things thicker than 100, choose the largest shape
% bw=img>80;
% bw=bwmorph(bw,'clean');
% cc=bwconncomp(bw,4);
% stats=regionprops(cc,'Area');%,'PixelIdxList');
% [~,maxind]=max([stats.Area]);
% bw2=zeros(size(bw));
% bw2(cc.PixelIdxList{maxind})=1;
% bw2=bwmorph(bw2,'fill');
% img2=bw2;

% bulk main part
img1=bpass(img,2,0);
bw1=img1>40;
SE1=strel('disk',3);
% bw2=imclose(bw1,SE1);
bw2=bw1;
% bw2=GetMaxAreaBW(bw2,8);
bb=bwconncomp(bw2,8);
cc=regionprops(bb,'Area','PixelIdxList');
[maxarea,maxind]=max([cc.Area]);
bw4=zeros(size(bw2));
for i=1:length(cc)
    if cc(i).Area>0.3*maxarea
        bw4(cc(i).PixelIdxList)=1;
    end
end
bwf=zeros(size(bw2));
bwf(bw4==1)=1;

%bulk brightest detail
bw3=img>150;
bwf(bw3==1&bw4==1)=2;

end

