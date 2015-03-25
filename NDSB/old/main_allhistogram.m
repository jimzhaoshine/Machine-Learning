% test
clear all;
close all;
load(fullfile('data','species.mat'));
%%
barc=0:2:125;% 255;
for ispecies=1:length(species)
    close all;
    spec=species(ispecies);
    display(spec.name);
    counts=zeros(size(barc));
    for ipic=1:spec.numFiles
        img=double(spec.sample(ipic).img);
        counttmp=hist(img(:),barc);
        counts=counts+counttmp;
    end
    clf;
    bar(barc(2:end),counts(2:end)     );pause
end

%% 
% can't tell significant peak distribution