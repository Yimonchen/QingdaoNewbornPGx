
library(ggplot2)
library(RColorBrewer)
library(pheatmap)

# G1K diff SNPs and InDels
mydata <- read.csv('G1K_freq_diff_table.tsv', row.names = 1, header = T, sep = '\t')
data_matrix<-as.matrix(mydata[,4:9])
annotation_col = data.frame(
  Evidence = factor(mydata[,2]))
rownames(annotation_col) = row.names(mydata)
ann_colors = list(Evidence = c("1A" = "#A6CEE3", "1A/2A" = "#1F78B4", "1B" = "#B2DF8A", "1B/2A" = "#33A02C", 
                               "1B/2A/NMPA" = "#FB9A99", "2A" = "#E31A1C", "2B" = "#FDBF6F", 
                               "2B/NMPA" = "#FF7F00", "NMPA" = "#6A3D9A"))

p1 <- pheatmap(t(data_matrix*100), border = F, cluster_rows=T,cluster_cols=F,,border_color=NA,cellheight=20,cellwidth=20,
               annotation_col = annotation_col, annotation_colors = ann_colors,
               display_numbers = TRUE,angle_col=270,number_format = "%.2f",number_color = "black",fontsize_number = 5,
               legend = T, legend_breaks = c(0, 20, 40, 60, 80, max(data_matrix*100)), 
               legend_labels = c("0", "20", "40", "60", "80", "Allele Frequency\n"))

ggsave(plot = p1, filename = "G1K_freq_diff_heatmap.pdf", height=6, width=20, units='in', dpi=300)


# PharmGKB diff haplotype
mydata <- read.csv('PharmGKB_freq_diff_table.tsv', row.names = 1, header = T, sep = '\t')
data_matrix<-as.matrix(mydata[,4:13])
annotation_col = data.frame(Evidence = factor(mydata[,2]))
rownames(annotation_col) = row.names(mydata)
annotation_row = data.frame(Data_scources = factor(c("QDcohort PGx",rep("PharmGKB",9))))
rownames(annotation_row) = colnames(mydata[,4:13])
ann_colors = list(Evidence = c("1A" = "#E31A1C", "1A/2A" = "#33A02C"), Data_scources =c("QDcohort PGx"="#FF7F00","PharmGKB"="#6A3D9A"))
labels_row = c("QDnewborn_MAF","African American/Afro-Caribbean","American","Central/South Asian",
               "East Asian","European","Latin","Near Estern","Oceanian","Sub-Saharan African")

p1 <- pheatmap(t(data_matrix*100), border = F, cluster_rows=T,cluster_cols=F,,border_color=NA,cellheight=20,cellwidth=20,
               annotation_col = annotation_col, annotation_row = annotation_row, annotation_colors = ann_colors, labels_row = labels_row,
               display_numbers = TRUE,angle_col=270,number_format = "%.2f",number_color = "black",fontsize_number = 5,
               legend = T, legend_breaks = c(0, 15, 30, 45, 60, max(data_matrix*100)), 
               legend_labels = c("0", "15", "30", "45", "60", "Allele Frequency\n"))

ggsave(plot = p1, filename = "PharmGKB_freq_diff_heatmap.pdf", height=5, width=11, units='in', dpi=300)
