library(dplyr)
library(tidyr)
library(ggplot2)
library(ggnewscale)
library(ggpubr)
library(RColorBrewer)

#setwd("~/")

#—————————————————— Pediatric&Adult ——————————————————#
# drug usage table
mydata_usage <- read.table("data_pediatric_usage_modified.tsv", header = T, sep = "\t")
mydata_usage <- mydata_usage[mydata_usage$percentage>0,]
mydata_usage$label = paste0(sprintf("%.2f", mydata_usage$percentage*100), "%")
mydata_usage$drug <- factor(mydata_usage$drug, levels = unique(mydata_usage$drug))
mydata_usage$usage <- factor(mydata_usage$usage, levels = unique(mydata_usage$usage))
mydata_usage$label <- factor(mydata_usage$label, levels = unique(mydata_usage$label))

#test plot
ggplot(mydata_usage,aes(x=drug,y=percentage*10,fill=usage)) +
  ylim(0,11) +
  geom_bar(position = position_stack(reverse = TRUE),stat="identity") +
  geom_text(aes(label = label), position = position_stack(reverse = TRUE,vjust = 0.5), size = 2) +
  scale_x_discrete(limits = rev(levels(mydata_usage$drug))) +
  theme(axis.text.y = element_text(vjust = 0.5, hjust=0.5)) +
  coord_flip()

# drug associated gene table
mydata_gene <- read.table("data_pediatric_gene_modified.tsv", header = T, sep = "\t")
mydata_gene$drug <- factor(mydata_gene$drug, levels = unique(mydata_gene$drug))
mydata_gene$gene <- factor(mydata_gene$gene, levels = unique(mydata_gene$gene))

#test plot
ggplot(mydata_gene,aes(x=drug,y=percentage,fill=gene)) +
  geom_bar(position = position_stack(),stat="identity") +
  geom_text(aes(label = gene), position = position_stack(vjust = 0.5), size = 2) +
  scale_x_discrete(limits = rev(levels(mydata_gene$drug))) +
  scale_y_continuous(limits = c(0, 6 * max(mydata_gene$percentage))) +
  theme(axis.text.y = element_text(vjust = 0.5, hjust=0.5)) +
  coord_flip()

# drug in China national drug reimbursement level table
mydata_level <- read.table("data_pediatric_level_modified.tsv", header = T, sep = "\t")
mydata_level$drug <- factor(mydata_level$drug, levels = unique(mydata_level$drug))
mydata_level$level <- factor(mydata_level$level, levels = unique(mydata_level$level))

# drug diease treatment category table
mydata_category <- read.table("data_pediatric_category_modified.tsv", header = T, sep = "\t")
mydata_category$drug <- factor(mydata_category$drug, levels = unique(mydata_category$drug))
mydata_category$ATC1stLabel <- factor(mydata_category$ATC1stLabel, levels = unique(mydata_category$ATC1stLabel))

p11 <- ggplot() +
  geom_bar(data=mydata_usage,aes(x=drug,y=percentage,fill=usage),
           position = position_stack(reverse = F),stat="identity") +
  scale_fill_manual(values = c("#1F78B4", "#33A02C", "#FDBF6F", "#E31A1C", "#6A3D9A"),
                    name = "Drug Usage",
                    guide = guide_legend(ncol = 2, title.position = "top")) +
  scale_x_discrete(limits = rev(levels(mydata_usage$drug)),position = "top") +
  scale_y_continuous(limits = c(0, 1.01 * max(mydata_gene$percentage))) +
  theme_classic() +
  theme(axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.text = element_text(size = 8,face = "bold"),
        legend.title = element_text(face = "bold",size = 8),
        legend.key.size = unit(0.5, 'cm'),
        legend.position = "bottom",
        legend.justification = c(0),
        plot.title = element_text(hjust = 0.5),
        #plot.caption = element_text(hjust = 0.1,size = 7),
        axis.text.y.right = element_text(face = "bold.italic",size = 10,colour = "black",vjust = 0.5, hjust=0.5)) +
  coord_flip()
p11

ggsave("p1.pdf", width = 4, height = 8, dpi = 300, units = c("in"))

p12 <- ggplot() +
  geom_bar(data=mydata_level,aes(x=drug,y=0.001,fill=level), 
           position = position_stack(),stat="identity", show.legend=T) +
  scale_fill_manual(values = c("grey20","grey50","grey"),
                    breaks = c("A", "B", "/"),
                    name = "China National Drug\nReimbursement Level",
                    guide = guide_legend(nrow = 1, title.position = "top")) +
  geom_text(data=mydata_level,aes(x=drug,y=0.001,fill=level,label=level),
            position = position_stack(reverse = T,vjust = 0.5),size = 3,fontface="bold",color="black") +
  scale_x_discrete(limits = rev(levels(mydata_usage$drug))) +
  theme_classic() +
  theme(axis.text.x = element_blank(),
        axis.title = element_blank(),
        axis.line = element_blank(),
        axis.ticks = element_blank(),
        legend.text = element_text(size = 8,face = "bold"),
        legend.title = element_text(face = "bold",size = 8),
        legend.key.size = unit(0.5, 'cm'),
        legend.position = "bottom",
        legend.justification = "right",
        plot.title = element_text(hjust = -0.4),
        axis.text.y = element_text(face = "bold.italic",size = 10,colour = "black",vjust = 0.5, hjust=0.5)) +
  coord_flip()
p12

ggsave("p2.pdf", width = 2, height = 8, dpi = 300, units = c("in"))

p13 <- ggplot() +
  geom_bar(data=mydata_category,aes(x=drug,y=0.1,fill=ATC1stLabel), 
           position = position_stack(),stat="identity", show.legend=T) +
  scale_fill_manual(#values = brewer.pal(n = 11, name = "Set3"), 
                    values = rep("white", times=11),
                    name = "Drug Category\n(ATC 1st Level)",
                    guide = guide_legend(nrow = 1, title.position = "top")) +
  geom_text(data=mydata_category,aes(x=drug,y=0.2,fill=ATC1stLabel,label=ATC1st),
            position = position_stack(reverse = T,vjust = 0.58),size = 3,fontface="bold",color="black") +
  scale_x_discrete(limits = rev(levels(mydata_usage$drug))) +
  theme_classic() +
  theme(axis.text.x = element_blank(),
        axis.title = element_blank(),
        axis.line = element_blank(),
        axis.ticks = element_blank(),
        legend.text = element_text(size = 6,face = "bold"),
        legend.title = element_text(face = "bold",size = 8),
        legend.key.size = unit(0.5, 'cm'),
        legend.position = "bottom",
        #legend.position = c(0.8,0.5),
        #legend.justification = "left",
        plot.title = element_text(hjust = -0.4),
        #plot.caption = element_text(hjust = 0.1,size = 7),
        axis.text.y = element_text(face = "bold.italic",size = 10,colour = "black",vjust = 0.5, hjust=0.5)) +
  coord_flip()
p13

ggsave("p3.pdf", width = 3, height = 8, dpi = 300, units = c("in"))
