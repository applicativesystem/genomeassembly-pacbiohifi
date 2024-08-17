#### This file contains the project parameter that were used to standardize the assembly. Below you will find the detail information for the running of the assembly. 
#### The ones with the --paration=all are for the Universitat Potsdam server and the ones without the same are for the MESO cluster. 
#### List of modules that are of use on the Universitat Potsdam server
```
bio/HTSlib/1.11-GCC-10.2.0
bio/GenomeTools/1.6.1-GCC-10.2.0
bio/DendroPy/4.5.2-GCCcore-10.2.0
bio/Kraken/1.1.1-GCCcore-10.2.0
bio/MAKER/3.01.03-foss-2020b
bio/MetaEuk/4-GCC-10.2.0
bio/MrBayes/3.2.7-GCC-10.2.0
bio/RAxML/8.2.12-foss-2020b-pthreads-avx2
bio/RepeatMasker/4.1.2-p1-foss-2020b
bio/RepeatModeler/2.0.2a-foss-2020b
bio/SAMtools/1.11-GCC-10.2.0
bio/STAR/2.7.7a-GCC-10.2.0
bio/Trinity/2.8.4-foss-2018b
bio/prodigal/2.6.3-GCCcore-10.2.0
data/scikit-learn/0.23.2-fosscuda-2020b
lang/Anaconda3/2021.05
lang/numba/0.52.0-foss-2020b
lib/TensorFlow/2.4.1-fosscuda-2020b
vis/matplotlib/3.3.3-foss-2020b
tools/umap-learn/0.4.6-fosscuda-2020b
math/Keras/2.4.3-fosscuda-2020b
vis/torchvision/0.8.2-fosscuda-2020b-PyTorch-1.7.1
```
> meryl installation
```
git clone https://github.com/marbl/meryl.git
cd meryl/src
make -j $threads
export PATH=/path/to/meryl/…/bin:$PATH
```
> downloading the data for the assembly from the NCBI archive
```
#!/bin/sh
#SBATCH -J=assembly
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks-per-core=1
#SBATCH --partition=agap_normal
#SBATCH --mail-user=sablokg@gmail.com
module load verkko/2.0-singularity
cd /home/sablokg/scratch/grapevineassemblies
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/ERR109/062/ERR10930362/ERR10930362.fastq.gz -O ERR10930362.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/ERR109/061/ERR10930361/ERR10930361.fastq.gz -O ERR10930361.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/ERR109/064/ERR10930364/ERR10930364.fastq.gz -O ERR10930364.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/ERR109/063/ERR10930363/ERR10930363.fastq.gz -O ERR10930363.fastq.gz
mkdir fastqfiles
cp -r *.gz ./fastqfiles
cd fastqfiles
for i in *.fastq.gz; do gunzip $i; done
```
> invoking the singularity maternal and the parental assembly using the hifiasm
```
#!/bin/bash
#SBATCH -J=hifiassembly
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks-per-core=1
#SBATCH --partition=agap_bigmem
#SBATCH --mail-user=sablokg@gmail.com
#SBATCH --mem=256G
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-%j.out
cd /home/sablokg/scratch/grapevineassemblies/hifiasmparental
module load bioinfo-cirad
module load bioinfo-ifb
module load hifiasm/0.15.1
export PATH=/home/sablokg/scratch/grapevineassemblies/hifiasmparental/yak:$PATH
echo $PATH
yak count -k 31 -t 32 -o parental.yak /home/sablokg/scratch/grapevineassemblies/verkkoassemblyparental/ERR10930361.fastq.gz
yak count -k 31 -t 32 -o maternal.yak /home/sablokg/scratch/grapevineassemblies/verkkoassemblyparental/ERR10930362.fastq.gz
hifiasm -o maternalpaternal.asm -t 32 -1 parental.yak -2 maternal.yak /home/sablokg/scratch/grapevineassemblies/verkkoassemblyparental/*.fastq.gz 2> maternalpaternal.log
```
> invoking the maternal and the parental assembly using the verkko assembler
```
#!/bin/bash
#SBATCH -J=assembly
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks-per-core=1
#SBATCH --partition=agap_bigmem
#SBATCH --mail-user=sablokg@gmail.com
#SBATCH --mem=256G
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-%j.out
cd /home/sablokg/scratch/grapevineassemblies/verkkoassemblyparental
module load bioinfo-cirad 
module load bioinfo-ifb
module load verkko/2.0-conda
module load java/jdk-17.0.6
export PATH=/home/sablokg/scratch/grapevineassemblies/verkkoassemblyparental/meryl-1.4.1/bin:$PATH
export MERQURY=/home/sablokg/scratch/grapevineassemblies/verkkoassemblyparental/merqury
source $MERQURY/util/util.sh
echo $PATH
parental=/home/sablokg/scratch/grapevineassemblies/verkkoassemblyparental/ERR10930361.fastq.gz
maternal=/home/sablokg/scratch/grapevineassemblies/verkkoassemblyparental/ERR10930362.fastq.gz
echo "verkko running"
meryl count compress k=30 threads=32 memory=128 $parental output ERR10930361.meryl
meryl count compress k=30 threads=32 memory=128 $maternal output ERR10930362.meryl
$MERQURY/trio/hapmers.sh ERR10930361.meryl ERR10930362.meryl
verkko -d ERR61ERR62ERR63 --hifi /home/sablokg/scratch/grapevineassemblies/verkkoassemblyparental/*.fastq.gz --hap-kmers ERR10930361.meryl ERR10930362.meryl trio
```
> invoking the indivual haplotype assembly using the hifiasm assembly parameters
```
#!/bin/bash
#SBATCH --partition=all
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=60G
#SBATCH --time=5-00:00
#SBATCH --chdir=/work/sablok/grapevineassemblies/assemblyhifiasm
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-%j.out
export PATH=/work/sablok/grapevineassemblies/meryl/build/bin/meryl:$PATH
export PATH=/work/sablok/grapevineassemblies/assemblyhifiasm/hifiasm:$PATH
echo $PATH
#/work/sablok/grapevineassemblies/fastq/ERR10930361.fastq
#/work/sablok/grapevineassemblies/fastq/ERR10930362.fastq
#/work/sablok/grapevineassemblies/fastq/ERR10930363.fastq
#/work/sablok/grapevineassemblies/fastq/ERR10930364.fastq
hifiasm -o ERR10930361.asm -l0 /work/sablok/grapevineassemblies/fastq/ERR10930361.fastq 2> ERR10930361.log
hifiasm -o ERR10930362.asm -l0 /work/sablok/grapevineassemblies/fastq/ERR10930362.fastq 2> ERR10930362.log
hifiasm -o ERR10930363.asm -l0 /work/sablok/grapevineassemblies/fastq/ERR10930363.fastq 2> ERR10930363.log
hifiasm -o ERR10930364.asm -l0 /work/sablok/grapevineassemblies/fastq/ERR10930364.fastq 2> ERR10930364.log
```
> invoking the indivual haplotype assembly using the verkko assembly parameters
```
#!/bin/bash
#SBATCH --partition=all
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=256G
#SBATCH --time=5-00:00
#SBATCH --chdir=/work/sablok/grapevineassemblies/assembly
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-%j.out
module load lang/Anaconda3/2021.05
source activate verkko
readsfile
# assemblye finish checker
# if [[ $(grep "100%" *.out | wc -l) ]]; then echo "all assemblies finished"; fi
#/work/sablok/grapevineassemblies/fastq/ERR10930361.fastq
#/work/sablok/grapevineassemblies/fastq/ERR10930362.fastq
#/work/sablok/grapevineassemblies/fastq/ERR10930363.fastq
#/work/sablok/grapevineassemblies/fastq/ERR10930364.fastq
echo "verkko running"
verkko -d ERR10930361ASM --hifi /work/sablok/grapevineassemblies/fastq/ERR10930361.fastq
verkko -d ERR10930362ASM --hifi /work/sablok/grapevineassemblies/fastq/ERR10930362.fastq
verkko -d ERR10930363ASM --hifi /work/sablok/grapevineassemblies/fastq/ERR10930363.fastq
verkko -d ERR10930364ASM --hifi /work/sablok/grapevineassemblies/fastq/ERR10930364.fastq
```
> busco evaluation of the assemblies
```
#!/bin/bash
#SBATCH --partition=all
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=50G
#SBATCH --time=1-00:00
#SBATCH --chdir=/work/sablok/grapevineassemblies/busco_evaluation/assembly_eval
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-%j.out
module load bio/BUSCO/5.1.2-foss-2020b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
#busco -i ERR10930361ASM.verkko.fasta -l viridiplantae_odb10 -c 32 -o ERR10930361ASM.busco -m geno
busco -i ERR10930361ASM.fasta -l viridiplantae_odb10 -c 32 -o ERR10930361ASM.busco -m geno
busco -i ERR10930362ASM.fasta -l viridiplantae_odb10 -c 32 -o ERR10930362ASM.busco -m geno
busco -i ERR10930363ASM.fasta -l viridiplantae_odb10 -c 32 -o ERR10930363ASM.busco -m geno
busco -i ERR10930364ASM.fasta -l viridiplantae_odb10 -c 32 -o ERR10930364ASM.busco -m geno
```
> compleasm runs using the vitis data. place the vitis file in the assembly folder
 ```
for i in *.fasta; do echo compleasm.py protein -p $vitis_file -l viridiplantae_odb10 -t $THREADS -o "${i%.*}".protein.eval.vitis; done
python3 compleasm.py protein -p vitis_PN40024.v4.pep.all.fa -l viridiplantae_odb10 -t 10 -o ERR10930361ASM.protein.eval.vitis
python3 compleasm.py protein -p vitis_PN40024.v4.pep.all.fa -l viridiplantae_odb10 -t 10 -o ERR10930362ASM.protein.eval.vitis
python3 compleasm.py protein -p vitis_PN40024.v4.pep.all.fa -l viridiplantae_odb10 -t 10 -o ERR10930363ASM.protein.eval.vitis
python3 compleasm.py protein -p vitis_PN40024.v4.pep.all.fa -l viridiplantae_odb10 -t 10 -o ERR10930364ASM.p
rotein.eval.vitis
```
> there is an alternative way to run the compleasm and that is by providing the proteins of the reference genome and in this case vitis and how to do it is given below:
```
miniprot --trans -u -I --outs=0.95 --gff -t $THREADS ref_file vitis.pep.fasta > aligned.gff
compleasm.py analyze align.gff -o output_dir -l viridiplantae_odb10 -t 8
```
> if you want to see which are the duplicated genes then use this
```
cat full_table.tsv | awk '/Duplicated/ { print $1"\t"$2"\t"$3"\t"$4 }'
cat full_table.tsv | awk !'/Duplicated/ { print $1"\t"$2"\t"$3"\t"$4 }'
```
> getting the unique duplicates genes out of the annotations.
```
cat full_table.tsv | awk '/Duplicated/ { print $1"\t"$2"\t"$3"\t"$4 }' | awk '{ print $3 }' | sort | uniq -c | wc -l
cat full_table.tsv | awk '/Duplicated/ { print $1"\t"$2"\t"$3"\t"$4 }' | awk '{ print $3 }' | sort | uniq -c | wc -l
```
> getting the unique single genes out of the annotations.
```
cat full_table.tsv | awk !'/Duplicated/ { print $1"\t"$2"\t"$3"\t"$4 }' | awk '{ print $3 }' | sort | uniq -c | wc -l
cat full_table.tsv | awk !'/Duplicated/ { print $1"\t"$2"\t"$3"\t"$4 }' | awk '{ print $3 }' | sort | uniq -c | wc -l
``
> hifiasm trio binning assembly
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
```
> awk conversion for the gfa files to fasta files. 
```
awk '/^S/{print ">"$2;print $3}' graphfile > outfile.fa
```

> busco evaluation on the hifiasm trio binning assembly
```
busco -i maternalpaternal.asm.dip.hap1.p_ctg.fa -l viridiplantae_odb10 -c 32 -o maternalpaternal.asm.dip.hap1.p_ctg.fa.busco -m geno
busco -i maternalpaternal.asm.dip.hap2.p_ctg.fa -l viridiplantae_odb10 -c 32 -o maternalpaternal.asm.dip.hap2.p_ctg.fa.busco -m geno
```
> quast run scores

```
conda create -n quast && conda install -n quast -c condaforge quast
conda clean -t
conda activate quast
quast.py -i hap1.fa 
quast.py -i hap2.fa
```
> ragtag runs on the triobinning assembly for the correction phase based on the reference. 
```
#!/bin/bash
#SBATCH --partition=all
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=256G
#SBATCH --time=2-00:00
#SBATCH --chdir=/work/sablok/grapevineassemblies/assemblyhifiasm/triobinning_ragtag
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-%j.out
module load lang/Anaconda3/2021.05
source activate ragtag
ragtag.py correct /work/sablok/grapevineassemblies/vitis_refgenome/Vitis_vinifera.PN40024.v4.dna.toplevel.fa maternalpaternal.asm.dip.hap1.p_ctg.fa
ragtag.py correct /work/sablok/grapevineassemblies/vitis_refgenome/Vitis_vinifera.PN40024.v4.dna.toplevel.fa maternalpaternal.asm.dip.hap2.p_ctg.fa
```
> ragtag runs on the triobinning assembly for the scaffolding phase 
```
#!/bin/bash
#SBATCH --partition=all
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=256G
#SBATCH --time=2-00:00
#SBATCH --chdir=/work/sablok/grapevineassemblies/assemblyhifiasm/triobinning_ragtag
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-%j.out
module load lang/Anaconda3/2021.05
source activate ragtag
ragtag.py scaffold /work/sablok/grapevineassemblies/vitis_refgenome/Vitis_vinifera.PN40024.v4.dna.toplevel.fa maternalpaternal.asm.dip.hap1.p_ctg.fa
ragtag.py scaffold /work/sablok/grapevineassemblies/vitis_refgenome/Vitis_vinifera.PN40024.v4.dna.toplevel.fa maternalpaternal.asm.dip.hap2.p_ctg.fa
```
> verkko trio binning assembly 
```
#!/bin/bash
#SBATCH --partition=all
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=256G
#SBATCH --time=5-00:00
#SBATCH --chdir=/work/sablok/grapevineassemblies/assembly/verkkomaternalparental
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-%j.out
module load lang/Anaconda3/2021.05
source activate verkko
source activate merqury
###### making hapmers #########
meryl count compress k=50 /work/sablok/grapevineassemblies/fastq/ERR10930361.fastq output ERR10930361.meryl
meryl count compress k=50 /work/sablok/grapevineassemblies/fastq/ERR10930362.fastq  output ERR10930362.meryl
meryl count compress k=50 /work/sablok/grapevineassemblies/fastq/ERR10930361.fastq output ERR10930363.meryl
###### running the trio binning assembly #########
verkko -d ERR61ERR62ERR63 --hifi /work/sablok/grapevineassemblies/fastq/maternalpaternalchild/ERR10930363.fastq --hap-kmers parentaladd maternaladd trio
```

> polishing and the phasing of the haplotig assemblies including the detection of the structural variants
```
conda config --add-channels bioconda 
conda config --add-channels conda-forge
conda clean -t 
conda create -n longshot && conda install -n longshot longshot 
conda clean -t 
```
> polishing of the hifi assemblies 
```
#!/bin/bash
#SBATCH --partition=all
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=256G
#SBATCH --time=5-00:00
#SBATCH --chdir=/work/sablok/grapevineassemblies/polishing
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-%j.out

module load lang/Anaconda3/2021.05
source activate longshot 

minimap2 -ax map-hifi -t 20 /work/sablok/grapevineassemblies/polishing/maternalpaternal.asm.dip.hap1.p_ctg.fa  /work/sablok/grapevineassemblies/fastq/ERR10930363.fastq -o ERR10930363.hifi.hap1.bam
minimap2 -ax map-hifi -t 20 /work/sablok/grapevineassemblies/polishing/maternalpaternal.asm.dip.hap2.p_ctg.fa  /work/sablok/grapevineassemblies/fastq/ERR10930363.fastq -o ERR10930363.hifi.hap2.bam
samtools sort -o ERR10930363.hifi.hap1.sorted.bam ERR10930363.hifi.hap1.bam
samtools sort -o ERR10930363.hifi.hap2.sorted.bam ERR10930363.hifi.hap2.bam
samtools index ERR10930363.hifi.hap1.sorted.bam
samtools index ERR10930363.hifi.hap2.sorted.bam
yak count -o k31.yak -k 31 -b 37 /work/sablok/grapevineassemblies/fastq/ERR10930363.fastq
nextPolish2 -t 20 ERR10930363.hifi.hap1.sorted.bam maternalpaternal.asm.dip.hap1.p_ctg.fa k31.yak > ERR10930363.hap1.polished.fasta
nextPolish2 -t 20 ERR10930363.hifi.hap2.sorted.bam maternalpaternal.asm.dip.hap2.p_ctg.fa k31.yak > ERR10930363.hap2.polished.fasta
```

> mapping reads for the polishing of the genome and depth estimation 
```
  for i in *.sorted.bam; do bamstats -in $i > ${i%.*}.json.txt; done 
```
> if you use jq for the json parsing then 
```  
  for i in *.json.txt; cat $i | jq -c ".general.reads" -c; done
```
> genome contiguity analysis 
```
#!/bin/bash
#SBATCH --partition=all
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=256G
#SBATCH --time=5-00:00
#SBATCH --chdir=/work/sablok/grapevineassemblies/genomecontiguityanalysis
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-%j.out

module load lang/Anaconda3/2021.05
source activate longshot 

minimap2 -ax map-hifi -t 20 /work/sablok/grapevineassemblies/genomecontiguityanalysis/maternalpaternal.asm.dip.hap1.p_ctg.fa  /work/sablok/grapevineassemblies/fastq/ERR10930363.fastq > ERR10930363.hifi.hap1.sam
minimap2 -ax map-hifi -t 20 /work/sablok/grapevineassemblies/genomecontiguityanalysis/maternalpaternal.asm.dip.hap2.p_ctg.fa  /work/sablok/grapevineassemblies/fastq/ERR10930363.fastq > ERR10930363.hifi.hap2.sam
paftools.js sam2paf -p ERR10930363.hifi.hap1.sam | sort -k6,6V -k8,8n > ERR10930363.hifi.hap1.paf
paftools.js sam2paf -p ERR10930363.hifi.hap2.sam | sort -k6,6V -k8,8n > ERR10930363.hifi.hap2.paf
```
> verkko assembly polishing 
```
#!/bin/bash
#SBATCH --partition=all
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=256G
#SBATCH --time=5-00:00
#SBATCH --chdir=/work/sablok/grapevineassemblies/polishing/ERR61ERR62ERR63_polishing
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-%j.out

module load lang/Anaconda3/2021.05
source activate longshot 

minimap2 -ax map-hifi -t 20 assembly.haplotype1.fasta  /work/sablok/grapevineassemblies/fastq/ERR10930363.fastq -o ERR10930363verkko.hifi.hap1.bam
minimap2 -ax map-hifi -t 20 assembly.haplotype2.fasta  /work/sablok/grapevineassemblies/fastq/ERR10930363.fastq -o ERR10930363verkko.hifi.hap2.bam
samtools sort -o ERR10930363verkko.hifi.hap1.sorted.bam ERR10930363verkko.hifi.hap1.bam
samtools sort -o ERR10930363verkko.hifi.hap2.sorted.bam ERR10930363verkko.hifi.hap2.bam
samtools index ERR10930363verkko.hifi.hap1.sorted.bam
samtools index ERR10930363verkko.hifi.hap2.sorted.bam
yak count -o k31.yak -k 31 -b 37 /work/sablok/grapevineassemblies/fastq/ERR10930363.fastq
nextPolish2 -t 30 ERR10930363verkko.hifi.hap1.sorted.bam assembly.haplotype1.fasta k31.yak > assembly.haplotype1.polished.fasta
nextPolish2 -t 30 ERR10930363verkko.hifi.hap2.sorted.bam assembly.haplotype2.fasta k31.yak > assembly.haplotype2.polished.fasta
```
