#!/usr/bin/env nextflow

params.outdir = "results"

process fastqc {
    container 'quay.io/biocontainers/fastqc:0.11.9--0'
    conda 'bioconda::fastqc=0.11.9'

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
    publishDir "${params.outdir}", mode: 'copy', pattern: "multiqc_report.html"
    conda 'bioconda::multiqc=1.14'

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
    reads = Channel.fromPath('https://raw.githubusercontent.com/nf-core/test-datasets/sarek/testdata/manta/normal/C097F_N_111207.1.AGTTGCTT_R1_xxx.fastq.gz')
    fastqc(reads)
    multiqc(fastqc.out[1])
}
