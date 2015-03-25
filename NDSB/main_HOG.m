% test the histogram distribution and HOG

% test
clear all;
close all;
load(fullfile('data','species.mat'));
%%
bins=0:255;
binsg=0:1000;
cumgall=zeros(length(binsg),length(species));
cumhall=zeros(length(bins),length(species));
for ispecies=1:length(species)
    %%
    spec=species(ispecies);
    imgc=zeros(length(bins),spec.numFiles);
    gradc=zeros(length(binsg),spec.numFiles);
    for ipic=1:min(spec.numFiles,20)
        display(['process, ',spec.name,' ',num2str(spec.numFiles)])
        img=double(spec.sample(ipic).img);
        bw=DetectEverything(img);
        gimg=imgradient(img);
        c1=hist(img(bw>0),bins);
        c1=cumsum(c1)/sum(c1);
        c2=hist(gimg(bw>0),binsg);
        c2=cumsum(c2)/sum(c2);
        clf;
        plot(bins,c1,binsg,c2);
        pause
        imgc(:,ipic)=c1;
        gradc(:,ipic)=c2;
    end
    cumhall(:,ispecies)=mean(imgc,2);
    cumgall(:,ispecies)=mean(gradc,2);
%     %%
%     figure(1)
%     clf
%     plot(imgc);
%     figure(2)
%     clf
%     plot(gradc);
%     pause
end
% save(fullfile('data','meanhog'),'cumhall','cumgall');
%%

% plot(cumgall)


