import pandas as pd
import os
import json
import requests
import yaml

def get_apf_feat():
    gene_range_list = os.listdir("gene_range")

    df_apf = pd.read_csv("data/apf_dataset.csv", dtype=str).fillna("")

    match_list = []

    not_include_gene = []
    for gene, content in df_apf.groupby(["Gene"]):
        if "{}_variant.tsv".format(gene) not in gene_range_list:
            not_include_gene.append(gene)
            continue

        df_var = pd.read_csv("gene_range/{}_variant.tsv".format(gene), sep="\t", dtype=str).fillna("")
        df_list = []
        for index, row in content.iterrows():
            pos = row["Start"]
            ref = row["Ref"]
            alt = row["Alt"]
            function = row["Functionality"]

            _df = df_var[(df_var["hg19_pos(1-based)"] == pos) & (df_var["ref"] == ref) & (df_var["alt"] == alt)]
            if len(_df) > 0:
                _df["function"] = [function] * len(_df)
                df_list.append(_df)

        if len(df_list) > 0:
            df_match = pd.concat(df_list, axis=0)
            df_match["gene"] = [gene] * len(df_match)
            match_list.append(df_match)

    print(not_include_gene)

    df_match_all = pd.concat(match_list, axis=0)

    columns = list(pd.read_csv("output/selected_column.csv", dtype=str)["column"].values)

    df_match_all = df_match_all[["#chr", "pos(1-based)", "ref", "alt", "gene", "function"] + columns]

    df_match_all.to_csv("output/apf_feat.csv", index=False)


def apf_clean():
    df_feat = pd.read_csv("output/apf_feat.csv", dtype=str).fillna("")
    df_lof = pd.read_csv("data/LoFtool_scores.txt", sep="\t")

    lof_dict = dict(zip(
        df_lof["Gene"].values,
        df_lof["LoFtool_percentile"].values
    ))


    def is_float(value):
        try:
            float(value)
            return True
        except:
            return False

    for index, row in df_feat.iterrows():
        for col in df_feat.columns:
            if row[col] == '.':
                row[col] = ""

            if ";" in row[col]:
                val_str = row[col].strip().split(";")
                val_str = list(filter(lambda x: x != "" and x != "." and is_float(x), val_str))
                if len(val_str) > 0:
                    row[col] = str(min([float(x) for x in val_str]))
                else:
                    row[col] = ""

    chr_list = df_feat["#chr"].values
    variant_start_list = df_feat["pos(1-based)"].values
    reference_allele_list = df_feat["ref"].values
    variant_allele_list = df_feat["alt"].values
    gene_symbol_list = df_feat["gene"].values

    gene_lof_list = [lof_dict.get(x, "") for x in gene_symbol_list]
    df_feat["LoFtool"] = gene_lof_list

    notations = [
        "{}:g.{}{}>{}".format(x[0], x[1], x[2], x[3]) for x in
        zip(chr_list, variant_start_list, reference_allele_list, variant_allele_list)
    ]
    df_feat["variant"] = notations

    path = "https://rest.ensembl.org/vep/human/hgvs/"
    headers = {"Content-Type": "application/json", "Accept": "application/json"}

    batch = 100

    notation_list = []

    for i in range(int(len(notations) / batch) + 1):
        print(i)
        r = requests.post(
            path,
            headers=headers,
            json={
                "hgvs_notations": notations[i * batch: (i + 1) * batch]
            },
            timeout=30
        )
        resp_list = json.loads(r.text)
        notation_list.extend(resp_list)

    notat_dict = {}
    for x in notation_list:
        ct_list = []
        for y in x["transcript_consequences"]:
            ct_list.extend(y["consequence_terms"])
        ct_list = list(set(ct_list))
        notat_dict[x["id"]] = {"consequence_terms": ct_list, "most_severe_consequence": x["most_severe_consequence"]}

    all_notations = list(pd.read_csv("output/snp_variant_type.csv", dtype=str).columns)
    all_notations.remove("variant")

    not_df_dict = {}
    not_df_dict["variant"] = []
    for key in set(all_notations):
        not_df_dict[key] = []

    for key, value in notat_dict.items():
        exist_cons = value["consequence_terms"]
        not_exist_cons = list(set(all_notations) - set(exist_cons))
        for ec in exist_cons:
            if ec in not_df_dict.keys():
                not_df_dict[ec].append(1)
        for ec in not_exist_cons:
            if ec in not_df_dict.keys():
                not_df_dict[ec].append(0)
        not_df_dict["variant"].append(key)

    df_notation = pd.DataFrame(not_df_dict)

    df_feat = pd.merge(df_feat, df_notation, how="left", on=["variant"])

    df_feat.to_csv("output/apf_feat_clean.csv", index=False)


def add_apf():
    df_feat = pd.read_csv("output/apf_feat_clean.csv")
    with open("threshold.yml", "r") as f:
        thres_dict = yaml.safe_load(f)

    apf_score_list = []
    for index, row in df_feat.iterrows():
        cur_list = []
        for key, value in thres_dict.items():
            score = row[key]
            if not score:
                continue

            if (value["type"] == "lt" and score < value["threshold"]) or \
                    (value["type"] == "gt" and score > value["threshold"]):
                cur_list.append(1)
            else:
                cur_list.append(0)

        if len(cur_list) == 0:
            apf_score_list.append(None)

        else:
            apf_score_list.append(round(sum(cur_list) / len(thres_dict.keys()), 3))

    df_feat["APF_score"] = apf_score_list

    try:
        df_feat[['chr', 'variant_start', 'reference_allele', 'variant_allele']] = \
            df_feat[['#chr', 'pos(1-based)', 'ref', 'alt']]

        for x in ['#chr', 'pos(1-based)', 'ref', 'alt']:
            df_feat.pop(x)
    except:
        pass

    df_feat["haplotype_name"] = [""] * len(df_feat)
    df_feat.to_csv("output/apf_feat_clean.csv", index=False)


if __name__ == "__main__":
    get_apf_feat()
    apf_clean()
    add_apf()