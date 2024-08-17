#!/usr/bin/env python3 
# Author: Gaurav Sablok
# Universitat Potsdam
# Date 2024-3-19
def plotvisual(cov, 
                 lengthparameter,file = None, 
                     plot = None, ):
    import pandas as pd
    import searborn as sns
    sns.set_theme()
    """"
    a coverage plot for the verkko pacbio hifi reads. 
    makes a bar plot to see the filtered coverage and length
    for the assembled genome. 
    Author: Gaurav Sablok
    Universitat Potsdam
    2024-3-7
    """
    if file is not None and plot is not None:
        readfile = pd.read_csv(file, sep = "\t")
        filteredcov = readfile[readfile["coverage"] > cov]
        filteredlength = readfile[readfile["length"] > lengthparameter]
        coveragefiltered = filteredcov.to_list()
        lengthfiltered = filteredlength.to_list()
        sns.barplot(filteredlength, x = "node", y = "length")
        sns.barplot(filteredcov, x= "node", y = "coverage" )
    return coveragefiltered, lengthfiltered
