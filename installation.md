##### installation files for the genome evaluation using the compleasm and the last one is a YAML file so can be imported directly.
wget https://github.com/huangnengCSU/compleasm/releases/download/v0.2.5/compleasm-0.2.5_x64-linux.tar.bz2 \
tar -jxvf compleasm-0.2.5_x64-linux.tar.bz2 \
compleasm_kit/compleasm.py -h \
git clone https://github.com/lh3/miniprot \
cd miniprot && make \
##### YAML begins
```
name: compleasm
channels:
  - bioconda
  - defaults
dependencies:
  - _libgcc_mutex=0.1=main
  - _openmp_mutex=5.1=1_gnu
  - bzip2=1.0.8=h5eee18b_5
  - ca-certificates=2024.3.11=h06a4308_0
  - expat=2.5.0=h6a678d5_0
  - hmmer=3.3.2=h87f3376_2
  - ld_impl_linux-64=2.38=h1181459_1
  - libffi=3.4.4=h6a678d5_0
  - libgcc-ng=11.2.0=h1234567_1
  - libgomp=11.2.0=h1234567_1
  - libstdcxx-ng=11.2.0=h1234567_1
  - libuuid=1.41.5=h5eee18b_0
  - ncurses=6.4=h6a678d5_0
  - openssl=3.0.13=h7f8727e_0
  - python=3.12.2=h996f2a0_0
  - readline=8.2=h5eee18b_0
  - sqlite=3.41.2=h5eee18b_0
  - tk=8.6.12=h1ccaba5_0
  - tzdata=2024a=h04d1e81_0
  - xz=5.4.6=h5eee18b_0
  - zlib=1.2.13=h5eee18b_0
  - pip:
    - pip==23.3.1
    - sepp==0.0.0
    - setuptools==68.2.2
    - wheel==0.41.2
prefix: /home/sablok/.conda/envs/compleasm \
```
```
export PATH="WORKDIR_OF_MINPROT_INSTALLATION":$PATH \
source activate compleasm \
python3 compleasm.py run -a ERR10930361ASM.fasta -o ERR10930361ASM -l viridiplantae_odb10 \
```
#### Gaetan instructions for setting up the genomeasm4pg on the Universitat Potsdam
```
- Clone the reporistory (git clone https://gitlab.cirad.fr/agap/workflows/genomeassembly)
- cd genomeassembly
- Edit the config.yaml for an accession (Path to fastq.gz file and reference assembly for ragtag). 3 mode are available \
        (default for an accession, trio (with mother and father raw data) or hic (but for after because Nestlé made also theses datas))
- Edit the profile/config.yaml (for Slurm parameters, partition and memory).
Section default-resources and set-resources.
- And snakelike.sh (for singularity and snakemake if needed)
```

#### busco can be installed in the following ways:
```
docker pull ezlabgva/busco:v5.6.1_cv1
docker run -u $(id -u) -v $(pwd):/busco_wd ezlabgva/busco:v5.6.1_cv1
conda create -n busco && conda install -n busco -c bioconda busco 
conda clean -t 
conda activate busco
```
#### alternatively the conda channels can be added directly 
```
conda config --add channels bioconda
conda config --add channels conda-forge
```
##### installation for the polishing and the variant estimation. the complete YAML is given below: 
```
name: longshot
channels:
  - bioconda
  - conda-forge
  - defaults
dependencies:
  - _libgcc_mutex=0.1=conda_forge
  - _openmp_mutex=4.5=2_gnu
  - binutils_impl_linux-64=2.40=ha885e6a_0
  - bzip2=1.0.8=hd590300_5
  - c-ares=1.28.1=hd590300_0
  - ca-certificates=2024.2.2=hbcca054_0
  - cmake=3.29.2=hcfe8598_0
  - gcc_impl_linux-64=13.2.0=h1d3d475_6
  - kernel-headers_linux-64=2.6.32=he073ed8_17
  - keyutils=1.6.1=h166bdaf_0
  - krb5=1.21.2=h659d440_0
  - ld_impl_linux-64=2.40=h55db66e_0
  - libcurl=8.7.1=hca28451_0
  - libedit=3.1.20191231=he28a2e2_2
  - libev=4.33=hd590300_2
  - libexpat=2.6.2=h59595ed_0
  - libgcc-devel_linux-64=13.2.0=h95c4c6d_106
  - libgcc-ng=13.2.0=hc881cc4_6
  - libgomp=13.2.0=hc881cc4_6
  - libnghttp2=1.58.0=h47da74e_1
  - libsanitizer=13.2.0=h95c4c6d_6
  - libssh2=1.11.0=h0841786_0
  - libstdcxx-ng=13.2.0=h95c4c6d_6
  - libuv=1.48.0=hd590300_0
  - libzlib=1.2.13=hd590300_5
  - longshot=1.0.0=hd4f2111_1
  - miniprot=0.13=he4a0461_0
  - ncurses=6.4.20240210=h59595ed_0
  - nextpolish2=0.2.0=hdcf5f25_0
  - openssl=3.2.1=hd590300_1
  - rhash=1.4.4=hd590300_0
  - rust=1.77.2=h70c747d_0
  - rust-std-x86_64-unknown-linux-gnu=1.77.2=h2c6d0dc_0
  - sysroot_linux-64=2.12=he073ed8_17
  - xz=5.2.6=h166bdaf_0
  - yak=0.1=he4a0461_4
  - zlib=1.2.13=hd590300_5
  - zstd=1.5.5=hfc55251_0
prefix: /home/sablok/.conda/envs/longshot
```
- to install use the following 
```
conda env create -f longshot 
```


