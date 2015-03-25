
dirpath = ['..' filesep 'train'];

list = dir(dirpath);
list=list([list.isdir]);
numDir = length(list)-2;

species = struct([]);
for z = 1:numDir
    directory = list(z+2).name;
    if isdir(fullfile(dirpath,directory))
        disp(directory);

        dirlist = dir(fullfile(dirpath,directory,'*.jpg'));
        numFiles = length(dirlist);%-2;
        
        species(z).name = directory;
        species(z).numFiles = numFiles;
        species(z).sample = struct([]);
        for i = 1:numFiles

            % load image
            img = imread(fullfile(dirpath,directory,dirlist(i).name));
            
            % rescale image
%             img = 255 - double(img);
%             MAX = max(img(:));
%             MIN = min(img(:));
%             img = uint8((img + MIN)*255/(MAX-MIN));
            
            % store image in struct
            species(z).sample(i).img = 255-img;
        end
    end
end

save(fullfile('data','species.mat'),'species');
