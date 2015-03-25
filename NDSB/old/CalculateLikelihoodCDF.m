function [P totalLogL L] = CalculateLikelihoodCDF(cumDN,empricialProb,cdfEdges,probEdges)

numSpecies = length(empricialProb);

% likelihood for each point of the intensity CDF for each species
L = zeros(length(cdfEdges),numSpecies);
for p = 1:numSpecies
    for i = 1:length(cdfEdges)
        index = find(cumDN(i) >= probEdges,1,'last');
        L(i,p) = empricialProb{p}(i,index);
    end
end

% rescale likelihood 
logL = log(L);
logL(logL == -Inf) = log(eps);
logL(isnan(logL)) = log(eps);
totalLogL = sum(logL);
% MAX = max(totalLogL);
% P = exp(totalLogL-MAX)+eps;
P = exp(totalLogL);
P = P./sum(P);        

