function [ ] = GroupPlot( fun1,fun2,spec )
%% plot group processing pictures
wx=1500;
wy=900;
sw=300;
expfactor=2;

figure('Position',[0 50 wx wy]);
nx=wx/sw;
ny=wy/sw;
for i=1:nx*ny/3
    if i<=spec.numFiles
        yi=2*floor((i-1)/nx)*sw;
        xi=mod((i-1),nx)*sw;
        img=double(spec.sample(i).img);
        [sy,sx]=size(img);
        % original image
        axes('Units','pixels','Position',[xi yi+2*sw expfactor*sx expfactor*sy]);
        imagesc(255-img,[0 255]);colormap gray;axis equal;axis off;
        axes('Units','pixels','Position',[xi yi+sw expfactor*sx expfactor*sy]);
%         th2=60;
%         th1=5;
%         img4=img>th1;
%         img2=img<=th2 &img>=th1;
%         img3=(img>th2)*2;
%         img4=img3+img2;

        % get max area
%                 img4=img>=5;
%                 bb=bwconncomp(img>=5,8);
%                 cc=regionprops(bb,'Area','PixelIdxList');
%                 [~,maxind]=max([cc.Area]);
%                 img4=zeros(size(img));
%                 img4(cc(maxind).PixelIdxList)=1;
%         
        
        imagesc(fun1(img),[0 2]);colormap gray;axis equal;axis off;
        axes('Units','pixels','Position',[xi yi expfactor*sx expfactor*sy]);
        
        %         bw=edge(img,'canny',[.1 .2]);
%         th2=60;
%         th1=10;
%         img12=medfilt2(img);
% img12=img;
%         bw1=img12>=th1;
%         
%         img21=bpass(img,1,0);
%         bw2=(img21>th2);
%         
%         imgf=double(bw1);
%         imgf(bw2==1)=2;
%       
        imagesc(fun2(img),[0 2]);colormap gray;axis equal;axis off;
    end
end

end

