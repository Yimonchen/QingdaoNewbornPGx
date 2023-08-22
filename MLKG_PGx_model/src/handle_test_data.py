import pandas as pd
import os
import pickle
import yaml
import json
import requests
from tqdm import tqdm


def gen_test_data():
    columns = ["variant", "type", "gene", "maf"]

    df_map001 = pd.read_csv(
        "test_data/snp.vep.mut.var.gene.af.filtered.MAF0.01.tsv",
        sep="\t",
        names=columns,
        header=None
    )

    gene_set_1 = set(df_map001["gene"].values)

    df_map005 = pd.read_csv(
        "test_data/snp.vep.mut.var.gene.af.filtered.MAF0.05.tsv",
        sep="\t",
        names=columns,
        header=None
    )

    gene_set_2 = set(df_map005["gene"].values)

    df_novel = pd.read_csv(
        "test_data/snp.vep.mut.var.gene.af.filtered.novel2dbSNP.tsv",
        sep="\t",
        names=columns,
        header=None
    )

    gene_range = set([x.split("_")[0] for x in os.listdir("gene_range")])
    name_map = {"UGT1Agroup": ["UGT1A1"] + ["UGT1A{}".format(x) for x in range(3, 11)]}
    range_map = {x: [x] for x in gene_range}
    name_map.update(range_map)

    df_map005["data_type"] = ["rare"] * len(df_map005)
    df_novel["data_type"] = ["novel"] * len(df_novel)

    df_all = pd.concat([df_map005, df_novel])

    rare_count_dict = {
        "total": 0,
        "matched": 0
    }

    novel_count_dict = {
        "total": 0,
        "matched": 0
    }

    match_list = []

    gb = df_all.groupby(["gene"])
    for key, content in tqdm(gb, total=gb.ngroups):
        gene = key
        genes = name_map[gene]
        df_list = []
        for g in genes:
            _df = pd.read_csv("gene_range/{}_variant.tsv".format(g), dtype=str, sep="\t")
            _df["gene"] = [g] * len(_df)
            df_list.append(_df)
        df_variant = pd.concat(df_list, axis=0, ignore_index=True).drop_duplicates()

        novel_content = content[content["data_type"] == "novel"]
        rare_content = content[content["data_type"] == "rare"]

        if len(df_variant) == 0:
            novel_count_dict["total"] += len(novel_content)
            rare_count_dict["total"] += len(rare_content)
            continue

        df_variant = df_variant.assign(
            variant=df_variant.apply(
                lambda row: "chr{}.{}.{}.{}".format(
                    row["#chr"], row["pos(1-based)"],
                    row["ref"], row["alt"]
                ),
                axis=1
            )
        )

        df_variant_novel = df_variant[df_variant["variant"].isin(list(novel_content["variant"].values))]
        df_variant_rare = df_variant[df_variant["variant"].isin(list(rare_content["variant"].values))]

        match_list.append(df_variant_rare)
        match_list.append(df_variant_novel)

        novel_count_dict["total"] += len(novel_content)
        novel_count_dict["matched"] += len(df_variant_novel)

        rare_count_dict["total"] += len(rare_content)
        rare_count_dict["matched"] += len(df_variant_rare)


    print(novel_count_dict)
    print(rare_count_dict)

    pd.concat(match_list, axis=0).to_csv("test_data/match.csv", index=False)


def clean_match_file():
    # 加载lof
    df_lof = pd.read_csv("data/LoFtool_scores.txt", sep="\t")
    lof_dict = dict(zip(
        df_lof["Gene"].values,
        df_lof["LoFtool_percentile"].values
    ))

    # 数据项
    columns = list(pd.read_csv("output/selected_column.csv", dtype=str)["column"].values)

    # 标注变异类型
    all_notations = list(pd.read_csv("output/snp_variant_type.csv", dtype=str).columns)
    all_notations.remove("variant")

    df_match = pd.read_csv("test_data/match.csv", dtype=str).fillna("")
    df_match = df_match[["gene", "#chr", "pos(1-based)", "ref", "alt"] + columns]

    def is_float(value):
        try:
            float(value)
            return True
        except:
            return False

    for index, row in df_match.iterrows():
        for col in df_match.columns:
            if row[col] in ['.', '-']:
                row[col] = ""

            if ";" in row[col]:
                val_str = row[col].strip().split(";")
                val_str = list(filter(lambda x: x != "" and x != "." and is_float(x), val_str))
                if len(val_str) > 0:
                    row[col] = str(min([float(x) for x in val_str]))
                else:
                    row[col] = ""

    chr_list = df_match["#chr"].values
    variant_start_list = df_match["pos(1-based)"].values
    reference_allele_list = df_match["ref"].values
    variant_allele_list = df_match["alt"].values
    gene_symbol_list = df_match["gene"].values

    gene_lof_list = [lof_dict.get(x, "") for x in gene_symbol_list]
    df_match["LoFtool"] = gene_lof_list

    notations = [
        "{}:g.{}{}>{}".format(x[0], x[1], x[2], x[3]) for x in
        zip(chr_list, variant_start_list, reference_allele_list, variant_allele_list)
    ]
    df_match["variant"] = notations

    path = "https://rest.ensembl.org/vep/human/hgvs/"
    headers = {"Content-Type": "application/json", "Accept": "application/json"}

    batch = 100

    notation_list = []

    for i in tqdm(range(int(len(notations) / batch) + 1)):
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

    df_match = pd.merge(df_match, df_notation, how="left", on=["variant"]).fillna(0)

    df_match.to_csv("test_data/match_clean.csv", index=False)


def gen_apf():
    # 加载阈值
    with open("threshold.yml", "r") as f:
        thres_dict = yaml.safe_load(f)

    df_match = pd.read_csv("test_data/match_clean.csv")
    apf_score_list = []
    for index, row in df_match.iterrows():
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

    df_match["APF_score"] = apf_score_list

    try:
        df_match[['chr', 'variant_start', 'reference_allele', 'variant_allele']] = \
            df_match[['#chr', 'pos(1-based)', 'ref', 'alt']]

        for x in ['#chr', 'pos(1-based)', 'ref', 'alt']:
            df_match.pop(x)
    except:
        pass

    df_match.to_csv("test_data/match_clean.csv", index=False)


def gen_test_binary_label():
    df_feat = pd.read_csv("test_data/match_clean.csv")
    df_feat_ = df_feat.copy(deep=True)

    info_cols = ["gene", "chr", "variant_start", "reference_allele", "variant_allele", "variant"]
    df_feat_ = df_feat_[info_cols]
    for x in info_cols:
        df_feat.pop(x)

    with open("model/imputer_dict.pkl", "rb") as f:
        imputer_dict = pickle.load(f)

    with open("model/normalizer_dict.pkl", "rb") as f:
        normalizer_dict = pickle.load(f)

    with open("model/xgb_binary_0823.pkl", "rb") as f:
        xgb_model = pickle.load(f)

    with open("model/lgb_binary_0823.pkl", "rb") as f:
        lgb_model = pickle.load(f)

    with open("model/rf_binary_0823.pkl", "rb") as f:
        rf_model = pickle.load(f)

    for key in imputer_dict.keys():
        df_feat[key] = imputer_dict[key].transform(df_feat[key].values.reshape(-1, 1))
        df_feat[key] = normalizer_dict[key].transform(df_feat[key].values.reshape(-1, 1))

    xgb_pred = xgb_model.predict_proba(df_feat.values)[:, 0]
    lgb_pred = lgb_model.predict_proba(df_feat.values)[:, 1]
    rf_pred = rf_model.predict_proba(df_feat.values)[:, 1]

    def most_common(lst):
        return max(lst, key=lst.count)

    score = [
        round(sum(x) / 3, 4) for x in list(zip(
            xgb_pred,
            lgb_pred,
            rf_pred
        ))
    ]

    # result = [
    #     most_common(x) for x in list(zip(
    #         ["neutral" if x <= 0.5 else "deleterious" for x in xgb_pred],
    #         ["neutral" if x <= 0.5 else "deleterious" for x in lgb_pred],
    #         ["neutral" if x <= 0.5 else "deleterious" for x in rf_pred]
    #     ))
    # ]

    df_feat_["xgb_score"] = xgb_pred
    df_feat_["lgb_score"] = lgb_pred
    df_feat_["rf_score"] = rf_pred
    df_feat_["avg_score"] = score

    df_feat_["result"] = ["neutral" if x <= 0.5 else "deleterious" for x in score]

    print(df_feat_.groupby(["result"])["variant"].count().reset_index(name='count'))

    df_feat_.to_csv("test_data/test_data_pred_binary.csv", index=False)


def gen_test_multi_label():
    df_feat = pd.read_csv("test_data/match_clean.csv")
    df_feat_ = df_feat.copy(deep=True)

    info_cols = ["gene", "chr", "variant_start", "reference_allele", "variant_allele", "variant"]
    df_feat_ = df_feat_[info_cols]
    for x in info_cols:
        df_feat.pop(x)

    # with open("model/imputer_dict_multi.pkl", "rb") as f:
    #     imputer_dict = pickle.load(f)
    #
    # with open("model/normalizer_dict_multi.pkl", "rb") as f:
    #     normalizer_dict = pickle.load(f)

    with open("model/xgb_multi_0823.pkl", "rb") as f:
        xgb_model = pickle.load(f)

    with open("model/lgb_multi_0823.pkl", "rb") as f:
        lgb_model = pickle.load(f)

    # with open("model/rf_multi_0823.pkl", "rb") as f:
    #     rf_model = pickle.load(f)
    #
    # with open("model/lr_multi_0823.pkl", "rb") as f:
    #     lr_model = pickle.load(f)

    # df_norm = df_feat.copy(deep=True)
    # for key in imputer_dict.keys():
    #     df_norm[key] = imputer_dict[key].transform(df_norm[key].values.reshape(-1, 1))
    #     df_norm[key] = normalizer_dict[key].transform(df_norm[key].values.reshape(-1, 1))

    test_data = df_feat.values
    # test_data_fillna = df_norm.values

    xgb_result = xgb_model.predict(test_data)
    lgb_result = lgb_model.predict(test_data)
    # rf_result = rf_model.predict(test_data_fillna)
    # lr_result = lr_model.predict(test_data_fillna)

    def most_common(lst):
        lst = list(lst)
        if lst[-1] == "neutral":
            lst[-1] = "normal function"
            # lst.append("normal function")
        else:
            lst.pop(-1)

        return max(lst, key=lst.count)

    binary_result = pd.read_csv("test_data/test_data_pred_binary.csv", dtype=str).fillna("")["result"].values

    hard_vote = [
        most_common(x) for x in list(zip(
            xgb_result,
            lgb_result,
            # rf_result,
            # lr_result,
            binary_result
        ))
    ]

    df_feat_["result"] = hard_vote
    print(df_feat_.groupby(["result"])["variant"].count().reset_index(name='count'))
    df_feat_.to_csv("test_data/test_data_pred_multi.csv", index=False)


if __name__ == "__main__":
    # gen_test_data()
    # clean_match_file()
    # gen_apf()
    gen_test_binary_label()
    gen_test_multi_label()