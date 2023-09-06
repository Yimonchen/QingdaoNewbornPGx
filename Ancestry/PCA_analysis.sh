#!/bin/bash

### PCA for QDnewborn 6442 individuals with 1000 Genome Porject 2504 individuals

plink --threads 8 \
	--vcf QD6442Han_G1K2504.hwe.maf.vcf.gz \
	--set-missing-var-ids @:#:\$1:\$2 \
	--indep-pairwise 50 10 0.5 \
	--out QD6442Han_G1K2504

plink --threads 8 \
	--vcf QD6442Han_G1K2504.hwe.maf.vcf.gz \
	--set-missing-var-ids @:#:\$1:\$2 \
	--extract QD6442Han_G1K2504.prune.in \
	--make-bed --pca \
	--out QD6442Han_G1K2504

### PCA for QDnewborn 6442 individuals with 1000 Genome Porject East Asian 504 individuals 

plink --threads 8 \
	--vcf QD6442Han_G1KEAS504.hwe.maf.vcf.gz \
	--set-missing-var-ids @:#:\$1:\$2 \
	--indep-pairwise 50 10 0.5 \
	--out QD6442Han_G1KEAS504

plink --threads 8 \
	--vcf QD6442Han_G1KEAS504.hwe.maf.vcf.gz \
	--set-missing-var-ids @:#:\$1:\$2 \
	--extract QD6442Han_G1KEAS504.prune.in \
	--make-bed --pca \
	--out QD6442Han_G1KEAS504

	### PCA for QDnewborn 6442 individuals

plink --threads 8 \
	--vcf QD6442Han.hwe.maf.vcf.gz \
	--set-missing-var-ids @:#:\$1:\$2 \
	--indep-pairwise 50 10 0.5 \
	--out QD6442Han

plink --threads 8 \
	--vcf QD6442Han.hwe.maf.vcf.gz \
	--set-missing-var-ids @:#:\$1:\$2 \
	--extract QD6442Han.prune.in \
	--make-bed --pca \
	--out QD6442Han