# Qingdao Newborn Cohort PGx Study

This folder contains information, scripts and data files that generated from and support the Qingdao Newborn Cohort pharmacogenomics study.

## Important Comments
1. This study does not provide any individual level genotype data for public access. VCF file containing population level genetic variation frequency data have been stored in the GVM database under accession number GVM000600.
2. Population level variation data and coresponding model prediction data have also been stored and presented in the Qingdao Newborn Cohort PGx database (https://db.cngb.org/QDPGx) via the CNGBdb (China National GeneBank database) platform.
3. The reference genome assembly untillized in this study is hg38/GRCh38.

## Brief Findings in our PGx Study
The QDnewborn cohort study was approved by the Research Ethics Committee of Qingdao Women and Children's Hospital (ethical permit ID: QFELL-KY-2020-29) and the Instituted Review Board of Bioethics and Biosafety of BGI (BGI-IRB, ethical permit ID: BGI-IRB 20064). 

7,140 individuals were recruited from 9,992 newborn children at Maternal and Child Health Hospital of Huangdao District, and Maternal and Child Health and Family Planning Service Center of Huangdao District in Qingdao, China. Written informed consent was obtained from the parents. Heel blood samples were obtained and whole genome sequencing were performed. Self-reported demographic information was collected from the parents.

After QC, 6,442 Han Chinese individuals (48.93% females) were retained. The sequencing depth of 6,442 participants distributed within the range from 30.89X to 206.08X with the median of 61.75X. According to the paternal place of origin, 97% of the participants were Northern Chinese. 84% of them originated from Shandong province.

<img src="https://github.com/Yimonchen/QingdaoNewbornPGx/images/map.png" width="50">

To comprehensively profiling the pharmacogenetic pattern of our QDnewborn cohort, we designed an analysis pipeline consisting of five main parts, illustrated as the flowchart. These five main parts were:
(1) genetic variants characterization of 257 pharmacogenes; 
(2) functional prediction model construction for PGx variation; 
(3) Web-based database development; 
(4) known actionable PGx variation investigation within the PharmGKB annotation level 1-2; 
(5) genotype to drug dosage influence evaluation based on the CPIC guideline.

![image](images/analysis_flowchart.png | width=50)

Of note, we developed a functional prediction model for PGx variation based on machine learning and knowledge graph, and the overall process is presented as the flowchart below.

![image](images/MLKG_PGx_framework.png | width=50)

* For the binary classification module performance of MLKG_PGx model, three models soft voting algorithm (average possibility of XGBoost, LightGBM and random forest, ROC AUC=0.9814) outperformed other algorithms based on full annotation features of training pharmacogenetic variation dataset.

* For the multiclassification module performance of MLKG_PGx model, LightGBM presented a slightly better overall performance when using both full annotation feature set (ROC AUC=0.9557) and key annotation feature set (ROC AUC=0.9508).
