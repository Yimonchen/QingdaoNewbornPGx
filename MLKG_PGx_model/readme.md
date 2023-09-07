## The MLKG_PGx model development

### Stage 1: Anotation scores abd features used for feature engineering

Main features：

```
LoFtool
variant_type (16 types)
```

Other feature importance ranking：

```
['DEOGEN2_score', 0.455324387891]
['M-CAP_score', 0.2543073624640703]
['Polyphen2_HVAR_score', 0.1835486937791109]
['integrated_fitCons_score', 0.134777592587471]
['FATHMM_score', 0.12771460489481688]
['MPC_score', 0.12699167339652777]
['SIFT4G_score', 0.11619652743523394]
['VEST4_score', 0.11617277889713645]
['GenoCanyon_score', 0.10970855285972357]
['PROVEAN_score', 0.1072015303403139]
```

feature used in APF model：

```
LRT
MutationAssessor
PROVEAN
VEST4
CADD
```

### Stage 2: Binary classification model traning and validation


Pharmacogenes involved in this model development：

```
ABCC2  CYP17A1  CYP1A2  CYP1B1  CYP21A2
CYP2A13  CYP2A6  CYP2B6  CYP2C19  CYP2C9  
CYP2D6  DPYD FMO3  G6PD  GSTP1  
HNMT  NAT1  NAT2  NR1I2  NUDT15
PNMT  RYR1  SLC22A12  SLC2A9  SLC47A1
SLCO1B1  TPMT  UGT1A1  UGT1A10  UGT1A4
UGT1A8  UGT1A9
```

There were 535 genetic variation for tarining，which were well annotated as following：

| function  | count  |
|---|---|
| deleterious | 385 |
| neutral | 150 |

Cross-validation results：

[clicking](https://docs.google.com/spreadsheets/d/1OjNUSJCpq-zSgRpkbbU8y7dn0QOxd4ga96unZVNt00M/edit#gid=0)


### Stage 3: Multi-classification model training and validation


Pharmacogenes involved in this model development：

```
CYP2B6  CYP2C19  CYP2C9  CYP2D6  DPYD  NUDT15
RYR1  SLCO1B1  TPMT  UGT1A1  D6PD
```

There were total 377 genetic variation for training, and well annotated as following:

| function | count |
|---|---|
| decreased function | 75 |
| increased function | 45 |
| no function | 192 |
| normal function | 65 |

Cross-validation results：

[clicking](https://docs.google.com/spreadsheets/d/1OjNUSJCpq-zSgRpkbbU8y7dn0QOxd4ga96unZVNt00M/edit#gid=917227294)
