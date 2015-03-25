
z = index(1);

for z=1:length(species)
j=1;
img = species(z).sample(j).img;
species(z).sample(j).features = FeatureExtraction(img,1,0);


% weiner filter image to smooth speckle noise
mask = 2;
[fimg noise] = wiener2(img,[mask mask]);

% convert to black-white
bimg = im2bw(fimg,.1);

% remove borders
bimg(1,:) = 0;
bimg(:,1) = 0;
bimg(:,end) = 0;
bimg(end,:) = 0;

intensity = double(img(bimg==1));
results.intensity = intensity;
results.totalIntensity = sum(intensity);
results.meanIntensity = mean(intensity);
results.stdIntensity = std(intensity);
results.totalarea = length(bimg==1);

D = regionprops(bimg, 'Centroid','Area', 'Perimeter','Eccentricity','EquivDiameter');

if showplot == 1
    figure(1); clf; 
    subplot(1,3,1); imshow(img);
    subplot(1,3,2); imshow(fimg,[]);
    subplot(1,3,3); imshow(bimg);
    hold on;
    for i = 1:length(D)
        if D(i).Area > mask^2 + 1
            pos = D(i).Centroid;
            scatter(pos(1),pos(2),'r');
        end    
    end
end
pause;
end


%% pixel-pixel correlation (nearest-neighbor)
warning off

neighbor = 2;
center = 13;
nearestneighbor = [7:9 12 14 17:19];
farneighbor = [1:6 10 11 15:16 20:25];

results = struct([]);
for z=1:length(species)
    disp(species(z).name);
    
    results(z).sample = struct([]);
    for j=1:species(z).numFiles
        img = species(z).sample(j).img;
        
%         % weiner filter image to smooth speckle noise
%         mask = 2;
%         [fimg noise] = wiener2(img,[mask mask]);

        % convert to black-white
        bimg = im2bw(img,.1);

        % remove borders
        bimg(1:neighbor,:) = 0;
        bimg(:,1:neighbor) = 0;
        bimg(:,end-neighbor+1:end) = 0;
        bimg(end-neighbor+1:end,:) = 0;

        [y x] = find(bimg==1);

        corr1 = []; corr2 = [];
        counts = []; 
        for k = 1:length(x)
            gridx = x(k)-neighbor:x(k)+neighbor;
            gridy = y(k)-neighbor:y(k)+neighbor;    
            match = find(bimg(gridy,gridx) == 1);
            
            % get rid of center pieces
            match(match == center) = [];
            
            nnIndex = find(ismember(match,nearestneighbor)==1);
            fnIndex = find(ismember(match,farneighbor)==1);
            counts = [counts; length(nnIndex) length(fnIndex)];
            
            % calculate correlation
            grid = double(img(gridy,gridx));
            corr1 = [corr1; grid(center)*grid(match(nnIndex))];
            corr2 = [corr2; grid(center)*grid(match(fnIndex))];
        end
        
%         % normalize connectivity
%         numCounts1 = zeros(8,1);
%         for k = 1:8
%             numCounts1(k) = length(find(counts(:,1) == k))/length(counts(:,1));
%         end
%         numCounts2 = zeros(16,1);
%         for k = 1:16
%             numCounts2(k) = length(find(counts(:,2) == k))/length(counts(:,2));
%         end
        
        results(z).sample(j).corr1 = corr1;
        results(z).sample(j).corr2 = corr2;
        results(z).sample(j).counts = counts;
%         results(z).sample(j).totalConnect1 = sum(counts(:,1));
%         results(z).sample(j).totalConnect2 = sum(counts(:,2));
%         results(z).sample(j).numCounts1 = numCounts1;
%         results(z).sample(j).numCounts2 = numCounts2; 
    end
end

save('nncorr.mat','results');


length(find(counts(:,1) <= 3))/length(counts(:,1))
length(find(counts(:,2) <= 3))/length(counts(:,2))









%%
bin = 5000;
MIN = 0;
MAX = 500000;
edges = MIN:(MAX-MIN)/bin:MAX;

figure; hold on;
colorSet = hsv(length(species));
for z = 1:length(species)
    
    numCounts1 = zeros(species(z).numFiles,1);
    numCounts2 = zeros(species(z).numFiles,1);
    for j = 1:species(z).numFiles
        numCounts1(j) = results(z).sample(j).totalConnect1;
        numCounts2(j) = results(z).sample(j).totalConnect2;
    end
    
%     DN = histc(numCounts1,edges);
%     DN2 = histc(numCounts2,edges);
%     subplot(1,2,1); hold on; plot(edges,cumsum(DN)/sum(DN),'color',colorSet(z,:));
%     subplot(1,2,2); hold on; plot(edges,cumsum(DN2)/sum(DN2),'color',colorSet(z,:));
    scatter(numCounts1,numCounts2,'markeredgecolor',colorSet(z,:));
end









%% PCA


z = index(1);
z=1;

% find max width and height of images
numFiles = species(z).numFiles;
imgSize = zeros(numFiles,2);
for j = 1:numFiles
    [h w] = size(species(z).sample(j).img);
    imgSize(j,:) = [h w];
end
MAX = max(imgSize);
maxh = MAX(1);
maxw = MAX(2);

% resize images to same size
images = zeros(maxh,maxw,numFiles);
for j = 1:numFiles
    [h w] = size(species(z).sample(j).img);
    images(1:h,1:w,j) = species(z).sample(j).img;
end

MAX = maxh*maxw;
imgVec = zeros(MAX,numFiles);
for j = 1:numFiles
    imgVec(1:MAX,j) = reshape(images(:,:,j)',MAX,1); 
end

% Compute difference with average for each vector
meanImg = mean(imgVec,2);
imgVec = imgVec - repmat(meanImg,1,numFiles);

% Get the patternwise (nexamp x nexamp) covariance matrix
C = imgVec'*imgVec;

% Get the eigenvectors and eigenvalues 
[vec val] = eig(C);

% normalize eivenvectors so the evalues are specifically for cov(A'), not A*A'.
eigenvals = diag(val);
val = eigenvals(end:-1:1)/(numFiles-1);
figure; plot(cumsum(val)/sum(val));

% Convert the eigenvectors of A'*A into eigenvectors of A*A'
vec = vec(:,end:-1:1);
vec = imgVec*vec;
% Normalize Vectors to unit length, kill vectors corr. to tiny evalues
for i = 1:numFiles
    vec(:,i) = vec(:,i)/norm(vec(:,i));
end



i=1;
original = imgVec(:,i);                     % Grab image 20
numComponents = 150;
projection = vec(:,1:numComponents)'*(original - meanImg);     
reconstruction = vec(:,1:numComponents)*projection + meanImg;  
reconstruction = reshape(reconstruction,maxw,maxh)';

figure(1); clf; 
subplot(1,2,1); imshow(images(:,:,i),[]); 
subplot(1,2,2); imshow(reconstruction,[]);




