import os
import pandas as pd

os.chdir("d:/pgkb_graph")

df_guide = pd.read_csv("static/pgkb_guideline.csv", dtype=str).fillna("")
df_guide = df_guide[["drug", "drug_chn", "gene", "metabolizer", "genotype_translate", "genotype"]]
df_guide = df_guide[df_guide["gene"] != "HLA_B"]


meta_list = [
    "Normal Metabolizer", "Poor Metabolizer", "Intermediate Metabolizer",
    "Rapid Metabolizer", "Ultrarapid Metabolizer"
]

gene_list = sorted(set(df_guide["gene"].values))

for key, content in df_guide.groupby(["gene"]):
    print(key)

# gene_meta_dict = {
#     "gene": [],
#     "metabolizer": []
# }
#
# for gene in gene_list:
#     for meta in meta_list:
#         gene_meta_dict["metabolizer"].append(meta)
#     gene_meta_dict["gene"].extend([gene] * len(meta_list))
#
# df_gm = pd.DataFrame(gene_meta_dict)
# df_gm["json_str"] = [""] * len(df_gm)
#
# os.chdir("d:/functional-prediction")
#
# df_gm.to_excel("data/metabolizer_function.xlsx", index=False)

