function [ img2 ] = DetectLine( img )
%detect the line structure of image
bw= img>=5 & img<50;
img2=bw;

end

