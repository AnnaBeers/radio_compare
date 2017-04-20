% Add scripts to path
% addpath(genpath('C:\Users\chang\Desktop\Texture Test\MATLAB Scripts'))

DFCI_directory = '/home/kenchang/LGG_DeepLearning/DFCI_Images/';
DFCI_regex = '*_ss_n4.nii';
DFCI_files = rdir(strcat(DFCI_directory, '**/', DFCI_regex));

index = 1;
final_struct(length(DFCI_files)).filename = 'a';

for volfile = DFCI_files'
    
   image = load_nii(strcat(DFCI_directory, volfile.name));
   split_file = strsplit(path, filesep);
   file_dir = split_file{end-1};
   mask = load_nii(strcat(file_dir, filesep, 'FLAIRmask.nii'));
   
   volfile.name
   
   image_array = image.img;
   mask_array = int64(mask.img);
   
   mask_array(find(mask_array ~= 0)) = 1;
   
    try
   
   [preprocessed_volume_matrix,levels] = prepareVolume(image_array,mask_array,'MRScan',1,1,1,'Matrix','Uniform',64);
   %get the GLCM

   GLCM = getGLCMtextures(getGLCM(preprocessed_volume_matrix,levels));
   
   GLCM
   
   [preprocessed_volume_global,levels] = prepareVolume(image_array,mask_array,'Other',1,1,1,'pixelW','Global','Uniform',64);
   %get the GLCM
   Global = getGlobalTextures(preprocessed_volume_global,levels);
   
   Global
   
   fieldNames = fieldnames(GLCM);
    for i = 1:size(fieldNames,1)
        final_struct(index).(fieldNames{i}) = GLCM.(fieldNames{i});
    end
   fieldNames = fieldnames(Global);
    for i = 1:size(fieldNames,1)
        final_struct(index).(fieldNames{i}) = Global.(fieldNames{i});
    end
   
    catch
        a = 1;
    end
    
   final_struct(index).filename = volfile.name;
   
   index = index + 1;

   
end

cell_file = struct2cell(final_struct);
xlswrite(strcat(DFCI_directory, 'DFCI_Features_Test_McGill.xlsx'), squeeze(cell_file));