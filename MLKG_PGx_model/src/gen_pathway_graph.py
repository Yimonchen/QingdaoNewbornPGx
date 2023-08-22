import os
import pandas as pd

folder = "d:/pgkb_graph/pathway"
update_date = ""

pathway_dict = {
    "from_entity": [],
    "from_type": [],
    "to_entity": [],
    "to_type": [],
    "reaction_type": [],
    "control_type": [],
    "controller": [],
    "cell_type": [],
    "PA_id": [],
    "pathway_name": [],
    "summary": []
}

for fn in os.listdir(folder):
    if "CREATED" in fn:
        update_date = fn.split("_")[-1].replace(".txt", "")
        continue

    if fn.startswith("PA") and fn.endswith(".tsv"):
        pa_id, pathway_name = fn.split("-")
        pathway_name = pathway_name.replace("_", " ").replace(".tsv", "")
        df_fn = pd.read_csv(os.path.join(folder, fn), sep="\t", dtype=str).fillna("")

        for index, row in df_fn.iterrows():
            from_entity = row["From"].lower()
            to_entity = row["To"].lower()
            reaction_type = row["Reaction Type"]
            controller = row["Controller"]
            control_type = row["Control Type"]
            cell_type = row["Cell Type"]

            if from_entity in row["Genes"]:
                from_type = "gene"
            elif from_entity in row["Drugs"]:
                from_type = "drug"
            elif from_entity in row["Diseases"]:
                from_type = "disease"
            else:
                from_type = "compound"

            if to_entity in row["Genes"]:
                to_type = "gene"
            elif to_entity in row["Drugs"]:
                to_type = "drug"
            elif to_entity in row["Diseases"]:
                to_type = "disease"
            else:
                to_type = "compound"

            if from_entity == "" or to_entity == "":
                continue

            if "Summary" in df_fn.columns:
                summary = row["Summary"]
            else:
                summary = ""

            pathway_dict["from_entity"].append(from_entity)
            pathway_dict["from_type"].append(from_type)
            pathway_dict["to_entity"].append(to_entity)
            pathway_dict["to_type"].append(to_type)
            pathway_dict["reaction_type"].append(reaction_type)
            pathway_dict["control_type"].append(control_type)
            pathway_dict["controller"].append(controller)
            pathway_dict["cell_type"].append(cell_type)
            pathway_dict["PA_id"].append(pa_id)
            pathway_dict["pathway_name"].append(pathway_name)
            pathway_dict["summary"].append(summary)

            img_temp = "https://s3.pgkb.org/pathway/{}.png"

df_pathway = pd.DataFrame(pathway_dict)
df_pathway["update_date"] = [update_date] * len(df_pathway)

df_pathway.to_csv("processed/pathway_relation.csv", index=False)