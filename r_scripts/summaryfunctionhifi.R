#!/usr/bin/R
# Author: Gaurav Sablok
# Universitat Potsdam
# Date 2024-3-19
#sample coverage file = https://github.com/sablokgaurav/genomeassembly_standards/blob/main/test_sample_code_files/test.cov
summary <- function(hifiinfile, coverage){
    readdf <- read.csv(hifiinfile, sep = "\t")
    return (length(readdf[readdf["coverage"] > coverage])) 
} 
# how to run the functions
# summary("ERR10930361ASM_assembly.hifi-coverage.csv", 100) 
#          -> total 4137 scaffolds with coverage more than 100. 

# a deafcto function for pulling the file directly from the bucket is also present below and it tell where the file is
summary <- function(hifiinfile, coverage){
    if (!hifiinfile) {
        print(paste0("a sample file is present at the https://github.com/sablokgaurav/genomeassembly_standards/blob/main/test_sample_code_files/test.cov"))
    } 
    else {
        readdf <- read.csv(hifiinfile, sep = "\t")
        return (length(readdf[readdf["coverage"] > coverage])) 
    }
   
} 
