function h = PlotScatter(var1,var2)

numDir = length(var1);
colorSet = hsv(numDir);

h = figure; hold on;
for z = 1:numDir
    scatter(var1{z},var2{z},'markeredgecolor',colorSet(z,:));
end
