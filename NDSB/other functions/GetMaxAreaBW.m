function [ bw2 ] = GetMaxAreaBW( bw , connectivity)
%get the bw image with the max area from bw image

bb=bwconncomp(bw,connectivity);
cc=regionprops(bb,'Area','PixelIdxList');
[~,maxind]=max([cc.Area]);
bw2=zeros(size(bw));
bw2(cc(maxind).PixelIdxList)=1;

end

