clear all;
clc;
close all;
%%

load(fullfile('data','species.mat'));

%%
numSpecies = length(species);

efd = cell(numSpecies,1);
parfor i = 1:numSpecies
    tic
    efdtmp=zeros(25,species(i).numFiles);
    for j = 1:species(i).numFiles
        img = species(i).sample(j).img;
        bw=img>=6;
        bw1=bwmorph(bw,'clean');
        SE1=strel('disk',3);
        bw2=imclose(bw1,SE1);
        bb=bwconncomp(bw2,8);
        cc=regionprops(bb,'Area','PixelIdxList');
        [~,maxind]=max([cc.Area]);
        bw2=zeros(size(bw2));
        bw2(cc(maxind).PixelIdxList)=1;
        SE2=strel('disk',2);
        bw2=imdilate(bw2,SE2);
        bw2=imfill(bw2,'holes');
        
        [B L]= bwboundaries(bw2);
        x = double(B{1}(:,2));
        y = double(B{1}(:,1));
        x(end) = [];
        y(end)= [];
        N = length(x);
        [a,b,c,d,T] = ellipticFourierDescriptor(x,y,N);
        val = sqrt(a.^2 + b.^2 + c.^2 + d.^2);
        lval=min(25,length(val));
        efdtmp(1:lval,j) = val(1:lval);
    end
    efd{i}=efdtmp;
    disp([species(i).name,num2str(species(i).numFiles)]);
    toc
end
save fourierdescriptors.mat

%%

t = (1:30)/T;
N = 30;
colorSet = hsv(N);
figure; hold on;
for i = 1:N
    meanefd = mean(efd{i},2);
    stdefd = std(efd{i},[],2);
    errorbar(t,meanefd,stdefd,'color',colorSet(i,:));
end
set(gca,'xscale','log')








