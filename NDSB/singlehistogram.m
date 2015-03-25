%single properties histograms
clear all;
close all;
load(fullfile('data','species.mat'));
%%
speciesNames={species.name};
numSpecies=length(speciesNames);
propGroup='everything_props';
propFields=eval(['fieldnames(species(1).sample(1).',propGroup,');']);
numFields=length(propFields);

propAll=cell(numFields,numSpecies);
for ifield=1:numFields
    for ispec=1:numSpecies
        spec=species(ispec).sample;
        values=zeros(size(spec));
        for ipic=1:length(spec)
            eval(['values(ipic)=spec(ipic).',propGroup,'.',propFields{ifield},';']);
        end
        propAll{ifield,ispec}=values;
    end
end

%% get mean
propmean=cellfun(@mean,propAll);
for ifield=1:numFields
%     plot(propmean(ifield,:),'.');
    pause
end
%%


