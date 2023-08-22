import pandas as pd
from tqdm import tqdm
import os


def gen_variant_file(chromosome, start, end, gene_name):
    total_str = ""
    chr_path = "d:/download/dbNSFP4.2a_variant.chr{}".format(chromosome)

    if os.path.exists("gene_range/{}_variant.tsv".format(gene_name)):
        return

    with open(chr_path, "r") as f:
        total_str += f.readline()
        line = f.readline()
        while line:
            position = int(line.split("\t")[1])

            if start - 300 <= position <= end + 300:
                total_str += line

            if position > end + 300:
                break

            line = f.readline()

    with open("gene_range/{}_variant.tsv".format(gene_name), "w") as f:
        f.write(total_str)


def gen_variant_by_csv(chromosome):
    df_range = pd.read_csv("data/han_gene_range.csv", dtype=str).fillna("")[["Gene", "chromosome", "start", "stop"]]
    df_chr_range = df_range.groupby(["chromosome"])["Gene"].apply(lambda x: " ".join(x)).reset_index(name="gene")
    chr_dict = dict(zip(
        list(df_chr_range["chromosome"].values),
        list(df_chr_range["gene"].values)
    ))

    gene_dict = dict(zip(
        list(df_range["Gene"].values),
        list(zip(
            list(df_range["chromosome"].values),
            list(df_range["start"].values),
            list(df_range["stop"].values)
        ))
    ))

    gene_list = chr_dict[chromosome].split(" ")

    print("chromosome: {}".format(chromosome))
    print("gene: {}".format(chr_dict[chromosome]))

    for gene_name in tqdm(gene_list):
        start = gene_dict[gene_name][1]
        end = gene_dict[gene_name][2]
        gen_variant_file(chromosome, int(start), int(end), gene_name)


if __name__ == "__main__":
    # 由于文件过大，分三次处理完所有基因
    gen_variant_by_csv("1")
    gen_variant_by_csv("2")
    gen_variant_by_csv("3")
    gen_variant_by_csv("4")
    gen_variant_by_csv("5")
    gen_variant_by_csv("6")

    gen_variant_by_csv("7")
    gen_variant_by_csv("8")
    gen_variant_by_csv("9")
    gen_variant_by_csv("10")
    gen_variant_by_csv("11")
    gen_variant_by_csv("12")
    gen_variant_by_csv("13")
    gen_variant_by_csv("14")
    gen_variant_by_csv("15")

    gen_variant_by_csv("16")
    gen_variant_by_csv("17")
    gen_variant_by_csv("18")
    gen_variant_by_csv("19")
    gen_variant_by_csv("20")
    gen_variant_by_csv("21")
    gen_variant_by_csv("22")
    gen_variant_by_csv("X")
    gen_variant_by_csv("M")