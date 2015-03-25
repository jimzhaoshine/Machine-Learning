clear all;
clc;
close all;

%% load data

load('species.mat');


%% 


for z = 1:numDir
    disp(species(z).name);
    for j = 1:species(z).numFiles
        img = species(z).sample(j).img;
        species(z).sample(j).features = FeatureExtraction(img,0,0);
    end
end


save('species.mat','species');

%%

totalIntensity = cell(numDir,1);
meanIntensity = cell(numDir,1);
stdIntensity = cell(numDir,1);
area = cell(numDir,1);
perimeter = cell(numDir,1);
diameter = cell(numDir,1);
eccentricity = cell(numDir,1);
success = zeros(numDir,1);
for z = 1:numDir
    totalIntensity{z} = zeros(species(z).numFiles,1);
    meanIntensity{z} = zeros(species(z).numFiles,1);
    stdIntensity{z} = zeros(species(z).numFiles,1);
    area{z} = zeros(species(z).numFiles,1);
    perimeter{z} = zeros(species(z).numFiles,1);
    diameter{z} = zeros(species(z).numFiles,1);
    eccentricity{z} = zeros(species(z).numFiles,1);
    numFail = 0;
    for j = 1:species(z).numFiles
        features = species(z).sample(j).features;
        if features.success == 1
            totalIntensity{z}(j) = features.totalIntensity;
            meanIntensity{z}(j) = features.meanIntensity;
            stdIntensity{z}(j) = features.stdIntensity;
            area{z}(j) = features.area;
            perimeter{z}(j) = features.perimeter;
            diameter{z}(j) = features.diameter;
            eccentricity{z}(j) = features.eccentricity;
        else
            numFail = numFail + 1;
        end
    end
    success(z) = numFail/species(z).numFiles;
end



%% check out failed features

index = find(success > .5);

for i = 1:length(index)
    for j = 1:species(index(i)).numFiles
        
        figure(1); clf;
        imshow(species(index(i)).sample(j).img);
        title(species(index(i)).name);
        pause;
    end
end

%%
bin = 15;
MIN = 0;
MAX = 255;
h = PlotHistogram(totalIntensity,bin,MIN,MAX);
h = PlotCumulativeProb(var,bin,MIN,MAX);
h = PlotScatter(totalIntensity,area);







