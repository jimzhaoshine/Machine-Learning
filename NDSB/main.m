% test
clear all;
close all;
load(fullfile('data','species.mat'));
%%
for ispecies=1:length(species)
    %header
    close all;
    spec=species(ispecies);
    display(spec.name);
    %%
    if 0
        GroupPlot(@DetectEverything,@DetectBulk,spec);
        set(gcf,'Name',spec.name);
        pause
    end
    %% extract feature props
    if 1
        for ipic=1:spec.numFiles
            %% test surf
            %             img=double(spec.sample(ipic).img);
            %             %
            %             points = detectSURFFeatures(img)%,'MinContrast',.90,...
            % %                 'MinQuality',.90,'NumOctaves',4);
            %             SI(img); hold on;
            %             for i=1:length(points)
            %                 loc=points(i).Location;
            %                 t=linspace(0,2*pi,20);
            %                 x=loc(1)+points(i).Scale*cos(t);
            %                 y=loc(2)+points(i).Scale*sin(t);
            %                 plot(x,y,'g');hold on;
            %             end
            %% everything detect
            %             bw=img>=6;
            %             bw1=bwmorph(bw,'clean');
            %
            %             %main img area
            %             SE1=strel('disk',3);
            %             bw2=imclose(bw1,SE1);
            %             % img2=imclose(img,SE1);
            %             % bw2=img2>=6;
            %             bw2=GetMaxAreaBW(bw2,8);
            %             SE2=strel('disk',3);
            %             bw2=imdilate(bw2,SE2);
            %             bw2=imfill(bw2,'holes');
            %             % bw2=imerode(bw2,SE2);
            %
            %             bwf=bw2;
            %             bwf(bw1==1 & bw2==1)=2;
            %             SI(bwf)
            
            %% gradient analysis
            %             [Gmag,Gdir]=imgradient(img);
            %             lapkernel=[-1 -1 -1; -1 8 -1; -1 -1 -1];
            %             dimg=(conv2(img,lapkernel,'same'));
            %             rgb=zeros(size(img,1),size(img,2),3);
            %             dimg1=dimg;
            %             dimg2=-dimg;
            %             dimg1(dimg1<0)=0;
            %             dimg2(dimg2<0)=0;
            %             rgb(:,:,1)=Gmag/max(Gmag(:));
            %             rgb(:,:,2)=dimg1/max(dimg1(:));
            %             rgb(:,:,3)=dimg2/max(dimg2(:));
            %             image(rgb);axis image;
            
            %             rgb(:,:,1)=img/max(img(:));
            %             rgb(:,:,2)=Gmag/max(Gmag(:));
            %             rgb(:,:,3)=dimg/max(dimg(:));
            %             image(rgb)
            
            %% extract everything props
            %             props=EverythingProps(img);
            %             spec.sample(ipic).everything_props=props;
            
            %%  extract image moment
            img=double(spec.sample(ipic).img);
            bw=DetectEverything(img);
            img1=img;
            img1(bw==0)=0;
            I=ImageMoment(img1);
            spec.sample(ipic).ImageMoment=I;
        end
        species(ispecies)=spec;
    end
end
save(fullfile('data','species.mat'),'species');