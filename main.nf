#!/usr/bin/env nextflow

params.outdir = "results"

process fastqc {
    container 'quay.io/biocontainers/fastqc:0.11.9--0'

    input:
    path reads

    output:
    path "*.html"
    path "*.zip"


    script:
    """
    fastqc $reads
    """
}

process multiqc {
    container 'quay.io/biocontainers/multiqc:1.14--pyhdfd78af_0'
    
    input:
    path fastqc_results

    output:
    path "multiqc_report.html"


    script:
    """
    multiqc . 
    """
}

workflow {
    reads = Channel.fromPath('https://raw.githubusercontent.com/nextflow-io/training/master/data/fastq/ERR458493_1.fastq.gz')
    fastqc(reads)
    multiqc(fastqc.out.collect())
}
