function  empiricalProb = GenerateProbCDF(CDF,probEdges,approx)
  
numSpecies = length(CDF);
numEdges = size(CDF{1},1);

% calculate probability of each CDF bin
if approx == 1 % Gaussian approximation
    empiricalProb = cell(numSpecies,1);
    for z = 1:numSpecies
        empiricalProb{z} = zeros(numEdges,length(probEdges));
        
        mu = mean(CDF{z},2);
        sigma =  std(CDF{z},[],2);
        for i = 1:numEdges
            if  sigma(i) ~= 0
                p = normpdf(probEdges,mu(i),sigma(i));
                empiricalProb{z}(i,:) = p/sum(p);
            else
                p = zeros(1,length(probEdges));
                index = find(mu(i) <= probEdges,1,'last');
                p(index) = 1;
                empiricalProb{z}(i,:) = p;
            end
        end
    end
    
else  % empirical CDF
    empiricalProb = cell(numSpecies,1);
    for z = 1:numSpecies
        empiricalProb{z} = zeros(numEdges,length(probEdges));
        for i = 1:numEdges
            DN = histc(CDF{z}(i,:),probEdges);
            empiricalProb{z}(i,:) = DN/sum(DN);
        end
    end
end

