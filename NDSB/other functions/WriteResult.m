function [  ] = WriteResult( prob,filename )
%% write result to excel
load(fullfile('data','header.mat'));
%%
% % alldata=cell(size(prob)+1);
% alldata=cell(length(pictureNames)+1,length(speciesNames)+1);
% alldata{1,1}='image';
% alldata(1,2:end)=speciesNames;
% alldata(2:end,1)=pictureNames;
% alldata(2:end,2:end)=cellfun(@(x)num2str(x,'%1.8f'),num2cell(prob),'UniformOutput',0);
% 
% xlswrite('result1.xlsx',alldata);

fileID = fopen(filename,'w');
fprintf(fileID,'image');
for i=1:length(speciesNames)
    fprintf(fileID,[',',speciesNames{i}]);
end
fprintf(fileID,'\n');
for i=1:length(pictureNames)
    fprintf(fileID,pictureNames{i});
    for j=1:length(speciesNames)
        fprintf(fileID,',%.8f',prob(i,j));
    end
    fprintf(fileID,'\n');
end
fclose(fileID);
end

