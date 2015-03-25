% test
clear all;
close all;
load(fullfile('data','species.mat'));
%%
for ispecies=38:length(species)
    %header
    close all;
    spec=species(ispecies);
    display(spec.name);
    %%
    if 1
        GroupPlot(@DetectEverything,@DetectBulk,spec);
        set(gcf,'Name',spec.name);
        pause
    end
    %% extract feature props
    if 0
        for ipic=1:spec.numFiles
            img=double(spec.sample(ipic).img);
            props=EverythingProps(img);
            spec.sample(ipic).everything_props=props;
        end
        species(ispecies)=spec;
    end
end
save(fullfile('data','species.mat'),'species');