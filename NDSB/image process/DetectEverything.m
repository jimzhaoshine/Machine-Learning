function [ bwf ] = DetectEverything( img )
%detect everything of the image

%detail img
bw=img>=6;
bw1=bwmorph(bw,'clean');

%main img area
SE1=strel('disk',3);
bw2=imclose(bw1,SE1);
% img2=imclose(img,SE1);
% bw2=img2>=6;
bw2=GetMaxAreaBW(bw2,8);
SE2=strel('disk',3);
bw2=imdilate(bw2,SE2);
bw2=imfill(bw2,'holes');
% bw2=imerode(bw2,SE2);

bwf=bw2;
bwf(bw1==1 & bw2==1)=2;

% bright region
% SE3=strel('disk',3);
% % bw3=img>=40;
% % bw3=imopen(bw3,SE3);
% % img3=imopen(img,SE3);
% img3=bpass(img,1,0);
% bw3=img3>=60;

% bw3=GetMaxAreaBW(bw3,8);

% bb=bwconncomp(bw3,8);
% cc=regionprops(bb,'Area','PixelIdxList');
% [maxarea,maxind]=max([cc.Area]);
% bw4=zeros(size(bw));
% for i=1:length(cc)
%     if cc(i).Area>0.3*maxarea
%         bw4(cc(i).PixelIdxList)=1;
%     end
% end
% bw4=imopen(bw3,SE3);
% bw4=img>=max(40,0.7*max(img(:)));
% bwf(bw4==1 & bw2==1)=3;

% bw4=imopen(bw4,SE3);
% bwf(bw4==1 & bw2==1)=4;

end

