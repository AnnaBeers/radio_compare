% Add scripts to path
% addpath(genpath('C:\Users\chang\Desktop\Texture Test\MATLAB Scripts'))

moist_run_directory = 'C:\Users\azb22\Documents\Scripting\Machine_Learning_Pipeline\qin_moistRun\';
moist_run_regex = '*_result_.nii';
moist_run_files = diQr(strcat(moist_run_directory, moist_run_regex));

index = 1;
final_struct(length(moist_run_files)).filename = 'a';

for volfile = moist_run_files'
   
%    if index < 244
%        index = index + 1;
%        continue;
%    end
    
   image = load_nii(strcat(moist_run_directory, volfile.name));
   mask = load_nii(strcat(moist_run_directory, volfile.name(1:end-4), '-label.nii'));
   
   volfile.name
   
   image_array = image.img;
   mask_array = mask.img;
   
   mask_array(find(mask_array ~= 0)) = 1;
   
    try
   
   [preprocessed_volume_matrix,levels] = prepareVolume(image_array,mask_array,'Other',1,1,1,'pixelW','Matrix','Equal',64);
   %get the GLCM
   
   
   GLCM = getGLCMtextures(getGLCM(preprocessed_volume_matrix,levels));
   
   GLCM
   
   [preprocessed_volume_global,levels] = prepareVolume(image_array,mask_array,'Other',1,1,1,'pixelW','Global','Equal',100);
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
xlswrite(strcat(moist_run_directory, 'QIN_Feature_Test_Ken_barebones.xlsx'), squeeze(cell_file));