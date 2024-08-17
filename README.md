#### genomeassembly-pacbiohifi

<div align = "justify"> I completed analysis and benchmarking of the pacbiohifi for the genome assembly coming from the PacBioHifi reads for the genotypes and haplotypes and their quality assessment. This is the complete genome assembly standardization coming from the PacBioHifi reads and includes all the scripts and the analysis for the reproducibility and the visualziation and the summary analysis. </div>
   
#### Genome assembly packages used for the assembly
- [hifiasm](https://github.com/chhylp123/hifiasm) 
- [Meryl](https://github.com/marbl/meryl) 
- [Merqury](https://github.com/marbl/merqury) 
- [Verkko](https://github.com/marbl/verkko)

#### Genome assembly evaluation
- [QUAST](https://github.com/ablab/quast) 
- [BUSCO](https://github.com/metashot/busco) 
- [compleasm](https://github.com/huangnengCSU/compleasm)
  
#### Genome Analysis and Project Summary
- The project is loated at the following links given below:
   <img src="https://github.com/gauravcodepro/genomeassembly-robusta/blob/main/publication_ready_figure.png" alt="image" width="400" height="auto">
- Project parameters: [Project parameters](https://github.com/gauravcodepro/genomeassembly-robusta/blob/main/projectparameters.md) 
- Genome assembly summary: [Summary evaluation](https://github.com/gauravcodepro/genomeassembly-robusta/blob/main/summarystats.md) 
- Reference evaluation: [Reference evaluation](https://github.com/gauravcodepro/genomeassembly-robusta/blob/main/referenceevaluation.md) 
- Installation and configuration: [Installation](https://github.com/gauravcodepro/genomeassembly-robusta/blob/main/installation.md) 

<img src="https://github.com/gauravcodepro/genomeassembly-robusta/blob/main/reading/read_count.png" alt="image" width="500" height="auto" align = "center">
<img src="https://github.com/gauravcodepro/genomeassembly-robusta/blob/main/reading/assembly_quality.png" alt="image" width="500" height="auto" align = "center">

**Haplotype based assembly**
- ERR10930361.fastq - maternal
- ERR10930362.fastq - paternal
- ERR10930363.fastq -child
- The hifiasm generates two files when you do the trio binning based on the maternal and the paternal and the filenames outputted are maternalpaternal.asm.dip.hap1.p_ctg.fa and maternalpaternal.asm.dip.hap2.p_ctg.fa and hence they are long so i put the hap1 for the first one and the hap2 for the second one. 
- The hifiasm trio binning results are present at [trio binning](https://github.com/gauravcodepro/genomeassembly-robusta/tree/main/hifiasm_tri_binning)
- All the configuration, run time, wallclock time, nodes, cpu, memory are listed here along with the runtime for each of the analysis [project parameters](https://github.com/gauravcodepro/genomeassembly-robusta/blob/main/projectparameters.md)

| haplotypes | contigs | Largest contig |  Total length | GC (%) |  N50 | N75 | L50 | L75 |
|---------|----------------|---------------|--------|------|-----|-----|-----|------------|
| hap 1 | 823     |  37880845   | 534683615  | 35.47  | 15838561 | 9224513 | 12  | 23  | 0.00
| hap 2 | 116 |    31333120 | 502852466 |  35.28 |  23599708 |  18852907 | 10 |  16 |  0.00

- BUSCO evaluation of both the haplotypes: completeness based on BUSCO for the trio binning method ( Total BUSCO searched 425)

| Species | Complete BUSCO | Complete and single-copy BUSCO |  Complete and duplicated BUSCOs (D)  |  Fragmented BUSCOs (F) |  Missing BUSCOs (M) | Completion score |
| -------------- | --------------- | -------------- | --------------- |  --------------- | --------------- |-------------|
|  hap1 | 422  | 415| 7 | 1 | 2 | 99.2%
| hap2 | 420 | 407 | 13 | 4 | 1 | 98.9%

**Haplotype assembly without the trio method**: 
- The last l3 means that for the same sample, the -l3 extensive purging was involved.

| contigs | ERR10930361 | ERR10930362 | ERR10930363 | ERR10930364 | ERR10930364_l3 |
|-----------------|-----------------|-----------------|-----------------|--------------------|-------------------|
| | 1248 | 2593 | 2611 | 1640 | 312 |
-----------------------------------------------------------------------------------------------------------------

- since the name of the files after the ragtag are so long so i have named them like this for the easier read:
  -  maternalpaternal.asm.dip.hap2.p_ctg.fa.ragtag.correct.scaffold: ragtag1
  -  maternalpaternal.asm.dip.hap1.p_ctg.ragtag.correct.scaffold: ragtag2

#### Ragtag assembly stats on the tribinning asm methods.

| haplotype name | placed_sequences  |   placed_bp  |   unplaced_sequences |  unplaced_bp |  gap_bp |  gap_sequences |
|----------------| ---------------------|----------------|-----------------------|------------------|----------------|--------------|
| ragtag1 | 293 |    473623733 |      1619 |    61059882 |       27100 |   271 |
| ragtag2 | 302   |  465201572      | 1054    |37650894        |28100  | 28 |

#### Quast results after the scaffolding with the ragtag. 
  - The number of the scaffolds have increased and this might be due to the fact that the genome is polyploid so the scaffold have been placed accordingly. The assembled size is near to the grapevine genome. 

| haplotypes | contigs | Largest contig |  Total length | GC (%) |  N50 | N75 | L50 | L75 |
|---------|----------------|---------------|--------|------|-----|-----|-----|------------|
| ragtag1 | 1626 | 37075411 | 534706754 | 35.47 |  24081286 | 20838642 |  10 |  16 |   5.07 |
| ragtag2| 1050 | 35080446 | 502871947 | 35.28 | 23258691 | 21132941 | 10 | 15 | 5.59

#### BUSCO report for the ragtag corrected scaffolds. 

| Species | Complete BUSCO | Complete and single-copy BUSCO |  Complete and duplicated BUSCOs (D)  |  Fragmented BUSCOs (F) |  Missing BUSCOs (M) | Completion score |
| -------------- | --------------- | -------------- | --------------- |  --------------- | --------------- |-------------|
| ragtag1 | 422  | 415| 7 | 1 | 2 | 99.2%
| ragtag2| 421 | 408 | 13 | 3 | 1 | 99.1%

#### Verkko assembly has been finished, parameters added to the parameters, including the wallclock time, resources used, time of execution, summary below: kmer used 30

 - assembly stats of the verkko assemblies using the trio binning. kmer used 30

| haplotypes | contigs | Largest contig |  Total length | GC (%) |  N50 | N75 | L50 | L75 |
|---------|----------------|---------------|--------|------|-----|-----|-----|------------|
| verkko hap 1 | 2259 | 33896910 | 508997582 | 35.56 |  10831024 | 5617093 |  16 |  31 |   5.07 |
| verkko hap 2 | 995 | 26795713 | 477196271 | 35.13 |  13168430 | 7656591 |  13 |  23 |   5.07 |

 - assembly stats of the verkko assemblies using the trio binning. kmer used 50

| haplotypes | contigs | Largest contig |  Total length | GC (%) |  N50 | N75 | L50 | L75 |
|---------|----------------|---------------|--------|------|-----|-----|-----|------------|
| verkko hap 1 |  2511  |  33896910 |   524953580 |  35.53 |  10586138 |  5279585  | 17 |  34 |  193.92 | 
| verkko hap 2 | 1061 |   26317445 |   485115873 |  35.14 |  13168430 |  7577555 | 13 |  24 |  263.24 |

- BUSCO results from the verkko assemblies using the trio binning. kmer used 30

| assembly type | complete busco | complete and single copy busco | complete and duplicated busco | fragmented busco | missing busco | completion score | 
| --------------- |------------------- | ---------------- | ------------------ | ------------------- |------------------------ | ------------ |
| hap1 | 393 | 385 | 8 | 1 | 31 | 92.5% |
| hap2 | 394 | 384 | 10 | 3 | 28 | 92.8% |

- BUSCO results from the verkko assemblies using the trio binning. kmer used 50
- By using the high kmer the BUSCO score improved.

| assembly type | complete busco | complete and single copy busco | complete and duplicated busco | fragmented busco | missing busco | completion score | 
| --------------- |------------------- | ---------------- | ------------------ | ------------------- |------------------------ | ------------ |
| hap1 | 401 | 392 | 9 | 0 | 24 | 94.3% |
| hap2 | 400 | 389 | 11 | 3 | 21 | 94.1% |

- assembly mapping reads using the pacbiohifi mapping and the coverage for the haplotypes. 

  -- bamstats coverage for hap1 and hap2 
    | Haplotype | Total reads | Mapped reads | Forward strand | Reverse strand | 
    |-----------|------------|-------------|---------------|---------------|
    |  hap1 | 3866068 | 3863435 (99.9319%) | 1936181 (50.0814%)  | 1929887 (49.9186%) |
    |  hap2 | 3656794 | 3653759 (99.917%) | 1831768      (50.0922%) | 1825026  (49.9078%) | 
  
  -- bamstats for the hap1 and hap2 
    | haplotype | total | unmapped | mapped | mappings ratio | mappings count |
    | ----------|-------|----------|--------|----------------|----------------|
    | hap1 | 2330837 | 2633 | 2328204 | 1.65941 | 3863435 |
    | hap2 | 2529319 | 3035 | 2526284 | 1.4463 | 3653759 |

#### Genome assembly stats for the hifiasm after polishing the genome with the ERR10930363.fastq reads

 - QUAST reports

 | haplotypes | contigs | Largest contig |  Total length | GC (%) |  N50 | N75 | L50 | L75 |
|---------|----------------|---------------|--------|------|-----|-----|-----|------------|
| hap 1 |  2259  |  33896900 |   508823952 |  35.56 |  10831023 |  5617076  | 16 |  31 |  195.80 | 
| hap 2 | 995 |   26781654 |   477006706 |  35.13 |  13168428 |  7656584 | 13 |  23 |  256.48 |

 - BUSCO reports of hifiasm polished genome

  | assembly type | complete busco | complete and single copy busco | complete and duplicated busco | fragmented busco | missing busco | completion score | 
| --------------- |------------------- | ---------------- | ------------------ | ------------------- |------------------------ | ------------ |
| hap1 | 422 | 415 | 7 | 1 | 2 | 99.2% |
| hap2 | 420 | 407 | 13 | 4 | 1 | 98.9% |

#### Genome assembly stats for the verkko after polishing the genome with the ERR10930363.fastq reads 

  - QUAST reports 

 | haplotypes | contigs | Largest contig |  Total length | GC (%) |  N50 | N75 | L50 | L75 |
|---------|----------------|---------------|--------|------|-----|-----|-----|------------|
| hap 1 |  823  |  37880684 |   534634347 |  35.47 |  15838572 |  9224508  | 12 |  23 |  0.00 | 
| hap 2 | 116 |   31333114 |   502764077 |  35.28 |  23599476 |  18852818 | 10 |  16 |  0.00 |

  -BUSCO reports
  
| assembly type | complete busco | complete and single copy busco | complete and duplicated busco | fragmented busco | missing busco | completion score | 
| --------------- |------------------- | ---------------- | ------------------ | ------------------- |------------------------ | ------------ |
| hap1 | 393 | 385 | 8 | 1 | 31 | 92.5% |
| hap2 | 394 | 383 | 11 | 3 | 28 | 92.7% |

- I am extending this with the HiC, Chromosomal Application development, Genome bubble solver and other applications. 

Gaurav Sablok
University of Potsdam
Potsdam,Germany
