clc 
clear all

path = 'D:\01Ô¬¾§\AHEdata\processed_2019\a_rawdata\nonAHE\available'
FileList = dir(path);
filelabel = struct('filename',{},'subject_id',{},'classlabel',{});
for i = 1:length(FileList)
   filename_tmp = FileList(i).name;
   if filename_tmp(1)=='s'
       filelabel(i-2).filename = filename_tmp(1:end-4);
       filelabel(i-2).subject_id = str2num(filename_tmp(2:6));
       filelabel(i-2).classlabel = 0;
   end
end