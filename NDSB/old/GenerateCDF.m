function CDF = GenerateCDF(train,cdfEdges)

numSpecies = length(train);

% calculate cdf
CDF = cell(numSpecies,1);
for z = 1:numSpecies
    numFiles = length(train(z).vals);
    CDF{z} = zeros(length(cdfEdges),numFiles);
    for k = 1:numFiles
        DN = histc(train(z).vals{k},cdfEdges);
        CDF{z}(:,k) = cumsum(DN)/sum(DN);
    end
end


