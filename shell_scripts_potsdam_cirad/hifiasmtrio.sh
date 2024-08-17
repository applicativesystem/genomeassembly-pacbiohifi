#!/bin/bash
#SBATCH --partition=all
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=256G
#SBATCH --time=5-00:00
#SBATCH --chdir=/work/sablok/grapevineassemblies/assemblyhifiasm/triobinningasm
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-%j.out

export PATH=/work/sablok/grapevineassemblies/yak:$PATH
export PATH=/work/sablok/grapevineassemblies/assemblyhifiasm/hifiasm:$PATH
yak count -k 31 -t 32 -o parental.yak /work/sablok/grapevineassemblies/fastq/maternalpaternalchild/ERR10930361.fastq
yak count -k 31 -t 32 -o maternal.yak /work/sablok/grapevineassemblies/fastq/maternalpaternalchild/ERR10930362.fastq
hifiasm -o maternalpaternal.asm -t 32 -1 parental.yak -2 maternal.yak /work/sablok/grapevineassemblies/fastq/maternalpaternalchild/ERR10930363.fastq 2> maternalpaternal.log
