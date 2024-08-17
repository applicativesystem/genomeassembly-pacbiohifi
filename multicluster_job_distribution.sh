#!/usr/bin/bash 
# generating the multicluster job submission for the verkko and the hifiasm
# Author Gaurav Sablok
# Universitat Potsdam
# Date: 2024-3-27

                echo "writing multi cluster job submission for the hifiasm and verkko"
multicluster () {
    while IFS="\n"; 
    readdir=$1
    scratchdir=$2
    command=$3
    # you can also add the read -r -p readdir scratchdir command
    # but i am allowing to read it from the file estimating that the file is a newline at everyend 
    # if you are invoking C or C++ then just add 
    # include stdio;
    # st::count << 
    declare -A associativearray=([0]="#!/bin/bash",[1]="#SBATCH --partition=all",[2]="#SBATCH --nodes=1",
             [3]="#SBATCH --ntasks=1",[4]="#SBATCH --cpus-per-task=1",[5]="SBATCH --mem=5G",
             [6]="SBATCH --time=0-05:00",[7]="#SBATCH --chdir="${hostname}",[8]="#SBATCH --mail-type=ALL",
            [9]="#SBATCH --output=slurm-%j.out", [10]="module list", [11]="module load lang/Anaconda3/2021.05")
    declare -a readingfiles = ()
    for i in "${readdir}/*.gz";
        do 
            readingfiles+=("${i}")
        done 
    printf("${readfiles[*]}")
    printf("{#readfiles[@]}")
    for i in "${readfiles[*]}"; 
      for j in "${associativearray[*]}";
        do 
            printf(%s"${j}\n")
        done
            printf(%s"echo without purging duplicates"\n)
            printf(%s"hifiasm -o "${i%%.?.**} -l0 $"{i}" ">2" "${i%%.*}.log"\n)
            printf(%s,"with aggressive purging of duplicates"\n)
            printf(%s"hifiasm -o "${i%%.?.**} -l3 $"{i}" ">2" "${i%%.*}.log"\n)
    } << inputfile.txt