#!/usr/bin/awk
# Author Gaurav Sablok
# Date 2024-3-15

# estimating the total of the aligned length based on the computed alignments
if [[ !aligned.paf ]]; then
    aligned.paf="https://github.com/sablokgaurav/genomeassembly_standards/blob/main/test_sample_code_files/sample.paf"
    echo "file for the analysis has been directly routed from the bucket"
fi

aligned.paf="https://github.com/sablokgaurav/genomeassembly_standards/blob/main/test_sample_code_files/sample.paf"
pafalignments="aligned.paf"
cat aligned.paf | awk '{ print  $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7" \
                                     \t"$8"\t"$9"\t"$10"\t"$11"\t"$12 }' | \
                                       awk '{ print $4-$3 }' | awk '{ print $1 }' | \
                                                             gawk '{ sum += $1 }; END { print sum }'
cat aligned.paf | awk '{ print  $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7" \
                                    \t"$8"\t"$9"\t"$10"\t"$11"\t"$12 }' | \
                                    awk '{ print $9-$8 }' | awk '{ print $1 }' | \
                                                      gawk '{ sum += $1 }; END { print sum }'

# query aligned genome fractions  percentage as compared to the genome length of the reference genome
pafalignments="aligned.paf"
genomelength=""genomelength
cat aligned.paf | awk '{ print  $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7" \
                                    \t"$8"\t"$9"\t"$10"\t"$11"\t"$12 }' | \
                                    awk '{ print $4-$3 }' | awk '{ print $1 }' | \
                                                      gawk '{ sum += $1 }; END { print sum }' | \
                                                                        awk '{ print $1/$genomelength*100 }'

# reference aligned genome fractions percentage as compared to the genome length of the reference genome
cat aligned.paf | awk '{ print  $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7" \
                                    \t"$8"\t"$9"\t"$10"\t"$11"\t"$12 }' | \
                                    awk '{ print $9-$8 }' | awk '{ print $1 }' | \
                                                      gawk '{ sum += $1 }; END { print sum }' | \
                                                                        awk '{ print $1/$genomelength*100 }'
