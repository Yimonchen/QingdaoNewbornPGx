## 罕见新发变异功能预测模型

### Stage 1: 基因变异注释打分

主要注释信息：

```
LoFtool
variant_type (16 types)
```

其余注释分数相关性排名：

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

APF涉及到的特征：

```
LRT
MutationAssessor
PROVEAN
VEST4
CADD
```

### Stage 2: 基因变异药物功能影响预测

功能影响二分类模型

二分类模型训练集中使用到的基因：

```
ABCC2  CYP17A1  CYP1A2  CYP1B1  CYP21A2
CYP2A13  CYP2A6  CYP2B6  CYP2C19  CYP2C9  
CYP2D6  DPYD FMO3  G6PD  GSTP1  
HNMT  NAT1  NAT2  NR1I2  NUDT15
PNMT  RYR1  SLC22A12  SLC2A9  SLC47A1
SLCO1B1  TPMT  UGT1A1  UGT1A10  UGT1A4
UGT1A8  UGT1A9
```

总有有535个基因变异做训练集，标签统计如下：

| function  | count  |
|---|---|
| deleterious | 385 |
| neutral | 150 |

交叉验证效果：

[点击链接](https://bgitech-my.sharepoint.com/:x:/g/personal/zhangke1_genomics_cn/ESiRWdziYVVDnLmvuhzZ4bgBFKDlap-YPUoKGMNuo3cO-Q?e=NWyg2O)


### Stage 3: 变异代谢功能推理

对于在以下基因范围内的突变，可以基于图谱，运用变异功能代谢型推理：

```
CYP2B6  CYP2C19  CYP2C9  CYP2D6  DPYD  NUDT15
RYR1  SLCO1B1  TPMT  UGT1A1  D6PD
```

代谢影响四分类中，总共有377个基因变异做训练集

| function | count |
|---|---|
| decreased function | 75 |
| increased function | 45 |
| no function | 192 |
| normal function | 65 |

交叉验证结果：

[点击链接](https://bgitech-my.sharepoint.com/:x:/g/personal/zhangke1_genomics_cn/EdQ-XZabn6NNmWhsBMn2wwcBIYw9thRRXZD73jSoMdta8w?e=q2IS61)
