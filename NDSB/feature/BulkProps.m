function [ bulk_props ] = BulkProps( img )
%% extract properties from bulk image
img2=DetectBulk(img);
prop=regionprops(img2,'Area','Eccentricity','EulerNumber','Perimeter',...
    'FilledArea','PixelIdxList');
if ~isempty(prop)
    bulk_props.Area=prop.Area;
    bulk_props.Eccentricity=prop.Eccentricity;
    bulk_props.numholes=1-prop.EulerNumber;
    bulk_props.roughness=prop.Perimeter/2/pi/sqrt(prop.Area/pi);
    bulk_props.percentagefilled=prop.Area/prop.FilledArea;
    bulk_props.meanbrightness=mean(img(prop.PixelIdxList));
    bulk_props.maxbrightness=max(img(prop.PixelIdxList));
else
    bulk_props.Area=0;
    bulk_props.Eccentricity=[];
    bulk_props.numholes=[];
    bulk_props.roughness=[];
    bulk_props.percentagefilled=[];
    bulk_props.meanbrightness=[];
    bulk_props.maxbrightness=[];
end

end

