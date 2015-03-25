function h = PlotHistogram(var,bin,MIN,MAX)

numDir = length(var);
colorSet = hsv(numDir);
edges = MIN:(MAX-MIN)/bin:MAX;

h = figure; hold on;
for z = 1:numDir
    DN = histc(var{z},edges);
    plot(edges,DN/sum(DN),'color',colorSet(z,:));
end
