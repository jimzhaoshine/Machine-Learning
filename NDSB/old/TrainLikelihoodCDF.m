function likelihood = TrainLikelihoodCDF(CDF,empiricalProb,cdfEdges,probEdges)

numSpecies = length(CDF);

% calculate likelihood of each CDF of each species
likelihood = cell(numSpecies,1);
for z = 1:numSpecies
    
    disp([num2str(z) ' out of ' num2str(numSpecies)]);
    numFiles = size(CDF{z},2);
    
    % calculate CDF likelihood for each species
    likelihood{z} = zeros(numSpecies,numFiles);
    for k = 1:numFiles
        [P totalLogL L] = CalculateLikelihoodCDF(CDF{z}(:,k),empiricalProb,cdfEdges,probEdges);
        likelihood{z}(:,k) = P';
    end
end
