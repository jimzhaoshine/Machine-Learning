function results = FeatureExtraction(img,finalplot,showplot)

% weiner filter image to smooth speckle noise
[fimg noise] = wiener2(img,[2 2]);
if showplot == 1
    figure; 
    subplot(1,2,1); imshow(img);
    subplot(1,2,2); imshow(fimg,[]);
end

% convert to black-white
bimg = im2bw(fimg,.01);

if showplot == 1
    figure; imshow(bimg);
end

% fill any holes
% bimgh = imfill(bimg,'holes');
bimgh = bimg;

% expand
se = strel('diamond',2);
bimg2 = imdilate(bimgh,se);
if showplot == 1
    figure; 
    subplot(1,2,1); imshow(bimg);
    subplot(1,2,2); imshow(bimg2);
end

% erode
se = strel('disk',2);
bimg3 = imerode(bimg2,se);
if showplot == 1
    figure; 
    subplot(1,2,1); imshow(bimg);
    subplot(1,2,2); imshow(bimg3);
end

% edge detection
BW = edge(bimg3,'canny',[0 .99],1);
if showplot == 1
    figure; 
    subplot(1,2,1); imshow(img);
    subplot(1,2,2); imshow(BW); 
end

BWfill = imfill(BW,'holes');
if finalplot == 1
    figure(1); clf; 
    subplot(1,2,1); imshow(img);
    subplot(1,2,2); imshow(BWfill); 
end

% Area, Centroid, Eccentricity, EquivDiameter, Perimeter,
D = regionprops(BWfill, 'Area', 'Perimeter','Eccentricity','EquivDiameter');

if ~isempty(D)
    results.success = 1;
    intensity = double(img(BWfill==1));
    results.intensity = intensity;
    results.totalIntensity = sum(intensity);
    results.meanIntensity = mean(intensity);
    results.stdIntensity = std(intensity);

    [results.area index] = max([D.Area]);
    results.perimeter = D(index).Perimeter;
    results.diameter = D(index).EquivDiameter;
    results.eccentricity = D(index).Eccentricity;
else
    results.success = 0;
    results.intensity = [];
    results.totalIntensity = [];
    results.meanIntensity = [];
    results.stdIntensity = [];
    results.perimeter = [];
    results.area = [];
    results.diameter = [];
    results.eccentricity = [];
end

    








