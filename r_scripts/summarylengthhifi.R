#!/usr/bin/R
# Author: Gaurav Sablok
# Universitat Potsdam
# Date 2024-3-19
# a sample file is present at: https://github.com/sablokgaurav/genomeassembly_standards/blob/main/test_sample_code_files/test.cov
summarylength <- function(hifiinfile, scaffoldlength){
    readdf <- read.csv(hifiinfile, sep = "\t")
    return (length(readdf[readdf["length"] > length])) 
} 
# how to run this function and get the length filtered scaffolds
summarylength("ERR10930361ASM_assembly.hifi-coverage.csv", 5000) -> total 20505 scaffolds with coverage more than 5000bp.

# a function below will give the default file location. 
summary <- function(hifiinfile, scaffoldlength){
    if (!hifiinfile) {
        print(paste0("a sample file is present at the 
                        https://github.com/sablokgaurav/genomeassembly_standards/blob/main/test_sample_code_files/test.cov"))
    } 
    else {
         readdf <- read.csv(hifiinfile, sep = "\t")
         return (length(readdf[readdf["length"] > length]))
    }
   
} 
