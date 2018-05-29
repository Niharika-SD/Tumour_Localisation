#!/bin/bash -l

#SBATCH
#SBATCH --job-name=field_US
#SBATCH --time=1:00:0
#SBATCH --partition=shared
#SBATCH --nodes=1
# number of tasks (processes) per node
#SBATCH --ntasks=1
# number of cpus (threads) per task (process)
#SBATCH --cpus-per-task=1



#### load and unload modules you may need
module load matlab/R2017a
module list

#### execute code - START FROM 0 :3. This (32486) is hardcoded based on length of the labels array.
# for loop_index_i in $(seq 0 1 32486); - for the old anechoic parameter set
for subj_no in 2 3 4 6 9 13 15 17 18 23 24 26 27 30 31 34 37 43 46 48 49 51 52 61 63 64 67 70 74 75 78 79 83 84 92 93 96 97 101 102 104 106 109;
do
    beta=-0.75;
    max_iter=100;
    tol=0.95;
    export beta max_iter tol subj_no
    sbatch wrapper.sh
done

