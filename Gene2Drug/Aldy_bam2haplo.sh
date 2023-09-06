#!/bin/bash

outdir=$1

while read line
do
	sample=$(echo $line|awk '{print $1}' );
	cram=$(echo $line |awk '{print $2}' );
	mkdir -p $outdir/$sample
	echo "/ldfssz1/ST_BIGDATA/USER/huangfei/software/miniconda3/bin/aldy genotype --simple --cn-neutral-region chr12:47841537-47905022 --reference hg38.fa --gene all -p wgs --genome hg38 --log $outdir/$sample/$sample.log --output $outdir/$sample/$sample.aldy $cram"
done < sample_cram.list
