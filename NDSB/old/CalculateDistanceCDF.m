function P = CalculateDistanceCDF(CDF,meanCDF)

numSpecies = length(meanCDF);

% sum of square difference
error = zeros(numSpecies,1);
for p = 1:numSpecies
    error(p) = sum((CDF - meanCDF{p}).^2);
end

% rescale likelihood 
logP = -log(error);
P = exp(logP);
P = P/sum(P);

