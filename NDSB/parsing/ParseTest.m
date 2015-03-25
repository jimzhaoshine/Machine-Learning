
dirpath = uigetdir('.');
dirlist=dir(fullfile(dirpath,'*.jpg'));
%%
testpic(size(dirlist))=struct('name',[],'image',[]);
for i=1:length(dirlist)
    testpic(i).name=dirlist(i).name;
    testpic(i).image=255-imread(fullfile(dirpath,dirlist(i).name));
end

%%
save(fullfile('data','testpics.mat'),'testpic');
