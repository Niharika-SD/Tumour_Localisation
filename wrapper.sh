#!/bin/bash -l

#SBATCH
#SBATCH --job-name=field_US
#SBATCH --time=6:00:0
#SBATCH --partition=shared
#SBATCH --nodes=1
# number of tasks (processes) per node
#SBATCH --ntasks=1
# number of cpus (threads) per task (process)
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16GB

#### load and unload modules you may need
module load matlab/R2017a
module list

curr_dir=$PWD
matlab -nodisplay -nodesktop -r "subj_no=$subj_no;tol=$tol;beta=$beta;max_iter=$max_iter ;run /work-zfs/avenka14/MARCC/main.m"

cd $curr_dir
