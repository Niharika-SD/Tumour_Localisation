addpath(genpath('/work-zfs/avenka14/MARCC'))

subj_no

filename  = strcat('/work-zfs/avenka14/MARCC/subj',num2str(subj_no),'.mat');
load(filename);

rsData = rssubj - (rssubj.*tumorsubj);
rsData = normalizeRs(rsData);
[MRFatlas,~,IC,MRFFC] = CombineEverythingWithMRF(rsData,tumorsubj,YeoAtlas17,GLMsubjFinger,tol,1,91,30,72,52,82,99.5,beta,max_iter,indexs);
[Voxelatlas,~,~,VoxelFC] = CombineEverything(rsData,tumorsubj,YeoAtlas17,GLMsubjFinger,1.5,.5,.5,tol,1,91,30,72,52,82,99.5);

out_name = strcat('/work-zfs/avenka14/MARCC/Outputs/out_',num2str(subj_no),'_beta_',num2str(beta),'_tol_',num2str(tol),'.mat');
save(out_name,'MRFatlas','IC','MRFFC','Voxelatlas','VoxelFC','beta','max_iter','tol');