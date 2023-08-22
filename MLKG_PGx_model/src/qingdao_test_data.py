import pandas as pd
import os
import pickle
import yaml
import numpy as np
from tqdm import tqdm
import time

def clean_file(file_path):
    score_mapping = {
        "GenoCanyon_score": "GenoCanyon_score",
        "M-CAP_score": "M-CAP_score",
        "MPC_score": "MPC_score",
        "MutationAssessor_score": "MutationAssessor_score",
        "Polyphen2_HVAR_scroe": "Polyphen2_HVAR_score",
        "CADD_score": "CADD_raw",
        "DEOGEN2_score": "DEOGEN2_score",
        "FATHMM_score": "FATHMM_score",
        "Integrated_fitCons_score": "integrated_fitCons_score",
        "LRT_score": "LRT_score",
        "Provean_score": "PROVEAN_score",
        "SIFT4G_score": "SIFT4G_score",
        "VEST4_score": "VEST4_score",
    }

    # 模型中的16种变异类型
    variant_list = [
        "upstream_gene_variant",
        "splice_donor_variant",
        "NMD_transcript_variant",
        "non_coding_transcript_variant",
        "synonymous_variant",
        "splice_acceptor_variant",
        "5_prime_UTR_variant",
        "incomplete_terminal_codon_variant",
        "non_coding_transcript_exon_variant",
        "splice_region_variant",
        "splice_polypyrimidine_tract_variant",
        "intron_variant",
        "missense_variant",
        "downstream_gene_variant",
        "coding_sequence_variant",
        "3_prime_UTR_variant"
    ]

    feat_columns = list(pd.read_csv("output/variant_feat_clean.csv").columns)
    for x in [
        "gene", "haplotype_name", "chr", "variant_start",
        "reference_allele", "variant_allele",
        "function", "variant", "type"
    ]:
        feat_columns.remove(x)

    df_qingdao = pd.read_csv(file_path, sep="\t").fillna("_")
    for key, values in score_mapping.items():
        df_qingdao[[values]] = df_qingdao[[key]]

    # 加载阈值
    with open("APF_threshold.yml", "r") as f:
        thres_dict = yaml.safe_load(f)

    # 加载loftool
    df_lof = pd.read_csv("data/LoFtool_scores.txt", sep="\t")
    lof_dict = dict(zip(
        df_lof["Gene"].values,
        df_lof["LoFtool_percentile"].values
    ))

    all_feat = []
    for index, row in df_qingdao.iterrows():
        gene_name = row["Gene"]
        variant_type = row["Variant_type"]

        feat_dict = {x: np.nan for x in feat_columns}

        if gene_name == "UGT1Agroup":
            gene_name = "UGT1A1"

        lof_score = lof_dict.get(gene_name, np.nan)
        feat_dict["LoFtool"] = lof_score

        for value in score_mapping.values():
            feat_dict[value] = row[value]

        if variant_type in variant_list:
            feat_dict[variant_type] = 1

        for vl in variant_list:
            if vl != variant_type:
                feat_dict[vl] = 0

        feat_dict["APF_score"] = gen_apf(thres_dict, row)


        assert len(feat_dict) == 106

        all_feat.append(feat_dict)

    df_f_feat = pd.DataFrame(all_feat)
    df_f_feat = df_f_feat.replace("_", np.nan)
    df_f_feat = df_f_feat.replace("?", np.nan)

    df_f_feat[["gene"]] = df_qingdao[["Gene"]]
    df_f_feat[["variant"]] = df_qingdao[["Variant"]]

    output_path = "output/" + file_path.split("_")[3] + ".csv"
    df_f_feat.to_csv(output_path, index=False)
    print("done")


def gen_apf(thres_dict, row):
    cur_list = []
    for key, value in thres_dict.items():
        score = row[key]
        if not score or score == "_":
            continue

        score = float(score)

        if (value["type"] == "lt" and score < value["threshold"]) or \
                (value["type"] == "gt" and score > value["threshold"]):
            cur_list.append(1)
        else:
            cur_list.append(0)

    if len(cur_list) == 0:
        apf_score = np.nan
    else:
        apf_score = round(sum(cur_list) / len(cur_list), 3)

    return apf_score


def train_binary(file_path):
    with open("model/imputer_dict.pkl", "rb") as f:
        imputer_dict = pickle.load(f)

    with open("model/normalizer_dict.pkl", "rb") as f:
        normalizer_dict = pickle.load(f)

    with open("model/xgb_binary_0105.pkl", "rb") as f:
        xgb_model = pickle.load(f)

    with open("model/lgb_binary_0105.pkl", "rb") as f:
        lgb_model = pickle.load(f)

    with open("model/rf_binary_0105.pkl", "rb") as f:
        rf_model = pickle.load(f)

    with open("model/col_list_binary_0105.pkl", "rb") as f:
        col_list = pickle.load(f)


    df_feat = pd.read_csv(file_path)

    # 通过非空数值过滤得到的数组
    feat_count_list = [
        "_", 'DEOGEN2_score', 'M-CAP_score', 'MPC_score', 'MutationAssessor_score',
        'LRT_score', 'FATHMM_score', 'PROVEAN_score',
        'Polyphen2_HVAR_score', 'integrated_fitCons_score', 'VEST4_score',
        'SIFT4G_score'
    ]

    full_score_list = ['LoFtool', 'GenoCanyon_score', 'CADD_raw', 'APF_score',]

    gene_list = df_feat.pop("gene")
    variant_list = df_feat.pop("variant")

    score_dict = {
        "gene": gene_list,
        "variant": variant_list,
    }

    for key in imputer_dict.keys():
        df_feat[key] = imputer_dict[key].transform(df_feat[key].values.reshape(-1, 1))
        df_feat[key] = normalizer_dict[key].transform(df_feat[key].values.reshape(-1, 1))

    df_feat = df_feat.fillna(0)

    df_feat = df_feat[col_list]

    for i, x in enumerate(feat_count_list):
        # 删除分数项
        if x == "_":
            pass
        else:
            df_feat[x] = [np.nan] * len(df_feat)
            df_feat[x] = imputer_dict[x].transform(df_feat[x].values.reshape(-1, 1))
            df_feat[x] = normalizer_dict[x].transform(df_feat[x].values.reshape(-1, 1))

        xgb_pred = xgb_model.predict_proba(df_feat.values)[:, 0]
        lgb_pred = lgb_model.predict_proba(df_feat.values)[:, 1]

        pred_list = list(map(lambda x: sum(x) / 2, zip(xgb_pred, lgb_pred)))

        score_dict["score_eliminate_{}".format(i)] = pred_list

    df_score = pd.DataFrame(score_dict)

    df_score.to_csv("output/qd_binary_score.csv", index=False)
    print("done")


def train_multi(file_path):
    with open("model/xgb_multi_0105.pkl", "rb") as f:
        xgb_model = pickle.load(f)

    with open("model/lgb_multi_0105.pkl", "rb") as f:
        lgb_model = pickle.load(f)

    with open("model/col_list_multi_0105.pkl", "rb") as f:
        col_list = pickle.load(f)

    multi_applied_genes = [
        "CYP2B6", "CYP2C19", "CYP2C9",
        "CYP2D6", "DPYD", "NUDT15",
        "RYR1", "SLCO1B1", "TPMT",
        "UGT1A1", "D6PD"
    ]

    _df = pd.read_csv("output/qd_binary_score.csv")
    _df = _df[_df["gene"].isin(multi_applied_genes)]

    df_feat = pd.read_csv(file_path)
    df_feat = df_feat[df_feat["gene"].isin(multi_applied_genes)]

    # 通过非空数值过滤得到的数组
    feat_count_list = [
        "_", 'DEOGEN2_score', 'M-CAP_score', 'MPC_score', 'MutationAssessor_score',
        'LRT_score', 'FATHMM_score', 'PROVEAN_score',
        'Polyphen2_HVAR_score', 'integrated_fitCons_score', 'VEST4_score',
        'SIFT4G_score'
    ]

    full_score_list = ['LoFtool', 'GenoCanyon_score', 'CADD_raw', 'APF_score', ]

    gene_list = df_feat.pop("gene")
    variant_list = df_feat.pop("variant")

    score_dict = {
        "gene": gene_list,
        "variant": variant_list,
    }

    df_feat[["stop_gained"]] = df_feat[["stop_gained"]].fillna(0)
    df_feat[["start_lost"]] = df_feat[["start_lost"]].fillna(0)

    df_feat = df_feat[col_list]

    for i, x in enumerate(feat_count_list):
        # 删除分数项
        if x == "_":
            pass
        else:
            df_feat[x] = [np.nan] * len(df_feat)

        xgb_result = xgb_model.predict(df_feat.values)
        lgb_result = lgb_model.predict(df_feat.values)

        binary_result = _df["score_eliminate_{}".format(i)].values

        def most_common(lst):
            lst = list(lst)
            if lst[-1] <= 0.5:
                return "normal function"
                pass
            else:
                lst.pop(-1)
            return max(lst, key=lst.count)

        pred_list = [
        most_common(x) for x in list(zip(
            lgb_result,
            xgb_result,
            binary_result
        ))
    ]

        score_dict["score_eliminate_{}".format(i)] = pred_list

    df_score = pd.DataFrame(score_dict)
    df_score.to_csv("output/qd_multi_score.csv", index=False)
    print("done")


if __name__ == "__main__":
    # clean_file("qd_data/QDcohort_6442Han_NovelCommonSNP_annoScore.tsv")
    # clean_file("qd_data/QDcohort_6442Han_allSNP_annoScore.tsv")
    # clean_file("qd_data/QDcohort_6442Han_KnownRareSNP_annoScore.tsv")
    # clean_file("qd_data/QDcohort_6442Han_NovelRareSNP_annoScore.tsv")

    start_time = time.time()
    # train_binary("output/NovelCommonSNP.csv")
    train_binary("output/allSNP.csv")
    # train_binary("output/KnownRareSNP.csv")
    # train_binary("output/NovelRareSNP.csv")
    end_time = time.time()
    print(end_time - start_time) # 46.714s

    start_time = time.time()
    # thres 0.66
    # train_multi("output/NovelCommonSNP.csv")
    train_multi("output/allSNP.csv")
    # train_multi("output/KnownRareSNP.csv")
    # train_multi("output/NovelRareSNP.csv")
    end_time = time.time()
    print(end_time - start_time) # 9.121s