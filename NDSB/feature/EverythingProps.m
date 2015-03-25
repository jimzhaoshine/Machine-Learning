function [ props ] = EverythingProps( img )
%% get properties for everything type of data
bw=DetectEverything(img);
bw1=bw>=1;
bw2=bw==2;
% tic
prop1=regionprops(bw1,'Area','Eccentricity','Perimeter',...
    'MajorAxisLength','MinorAxisLength','ConvexArea');


InnerArea=bwarea(bw2);
bb1=bwboundaries(bw2,8,'noholes');
bb2=bwboundaries(bw2,8,'holes');
OuterFinePerim=GetBoundariesLength(bb1);
InnerFinePerim=GetBoundariesLength(bb2);



%
props=[];
if ~isempty(prop1)
    outerR= sqrt(prop1.Area/pi);
    props.OuterArea=prop1.Area;
%     props.OuterEccentricity=prop1.Eccentricity;
    props.OuterPerimeter_OuterRadius_Ratio=prop1.Perimeter/2/pi/outerR;
    props.OuterArea_OuterConvexArea_Ratio=prop1.Area/prop1.ConvexArea;
    props.OuterLength_Diameter_Ratio=prop1.MajorAxisLength/outerR/2;
    props.OuterWidth_Diameter_Ratio=prop1.MinorAxisLength/outerR/2;
    props.InnerArea_OuterArea_Ratio=InnerArea/prop1.Area;
    props.OuterFinePeri_OuterRadius2Pi_Ratio=sum(OuterFinePerim)/outerR/2/pi;
    props.InnerFinePerim_OuterRadius2Pi_Ratio=sum(InnerFinePerim)/outerR/2/pi;
    sumimg=length(img(bw2));
    props.Intensity15=sum(img(bw2)<15)/sumimg;
    props.Intensity30=sum(img(bw2)<30)/sumimg;
    props.Intensity60=sum(img(bw2)<60)/sumimg;
    props.Intensity90=sum(img(bw2)<90)/sumimg;
    props.Intensity130=sum(img(bw2)<140)/sumimg;
    props.Intensity250=sum(img(bw2)<200)/sumimg;
%     props.IntensityMean=mean(img(bw1));
%     props.IntensityMax=max(img(bw1));
end
% toc

end

