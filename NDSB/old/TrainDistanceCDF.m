function prob = TrainDistanceCDF(CDF)

numSpecies = length(CDF);
meanCDF = cell(numSpecies,1);
for k = 1:numSpecies
    meanCDF{k} = mean(CDF{k},2);     
end

% calculate likelihood of each CDF of each species
prob = cell(numSpecies,1);
for z = 1:numSpecies
    
    disp([num2str(z) ' out of ' num2str(numSpecies)]);
    numFiles = size(CDF{z},2);
    
    % calculate CDF likelihood for each species
    prob{z} = zeros(numSpecies,numFiles);
    for k = 1:numFiles
        prob{z}(:,k) = CalculateDistanceCDF(CDF{z}(:,k),meanCDF);
    end
end

 P = CalculateDistanceCDF(CDF{z}(:,k),meanCDF);
 [MAX index] = min(P);
 
 figure; hold on;
 plot(CDF{z}(:,k));
 plot(meanCDF{z},'k');
 plot(meanCDF{index},'r');
 
 
