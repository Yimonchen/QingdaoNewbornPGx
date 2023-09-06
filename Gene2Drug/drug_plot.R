
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggnewscale)
library(ggpubr)
library(RColorBrewer)

#—————————————————— Pediatric&Adult ——————————————————#
# drug usage table
mydata_usage <- read.table("data_pediatric_usage_modified.tsv", header = T, sep = "\t")
mydata_usage <- mydata_usage[mydata_usage$percentage>0,]
mydata_usage$label = paste0(sprintf("%.2f", mydata_usage$percentage*100), "%")
mydata_usage$drug <- factor(mydata_usage$drug, levels = unique(mydata_usage$drug))
mydata_usage$usage <- factor(mydata_usage$usage, levels = unique(mydata_usage$usage))
mydata_usage$label <- factor(mydata_usage$label, levels = unique(mydata_usage$label))


# drug associated gene table
mydata_gene <- read.table("data_pediatric_gene_modified.tsv", header = T, sep = "\t")
mydata_gene$drug <- factor(mydata_gene$drug, levels = unique(mydata_gene$drug))
mydata_gene$gene <- factor(mydata_gene$gene, levels = unique(mydata_gene$gene))


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
           position = position_stack(reverse = T),stat="identity") +
  scale_fill_manual(values = c("grey30","red3","darkred","tomato","pink2"), 
                    name = "\nDrug Usage",guide = guide_legend(ncol = 1, title.position = "top")) +
  scale_x_discrete(limits = rev(levels(mydata_usage$drug)),position = "top") +
  geom_text(data=mydata_usage,aes(x=drug,y=percentage,fill=usage,label=label),
            position = position_stack(reverse = T,vjust = 0.6),size = 2.5,fontface="bold",color="white") +
  scale_y_continuous(limits = c(0, 1.01 * max(mydata_gene$percentage))) +
  labs(title = "Drug Usage Influence") +
  theme_classic() +
  theme(axis.text.x = element_blank(),
        axis.title = element_blank(),
        axis.line = element_blank(),
        axis.ticks = element_blank(),
        legend.text = element_text(size = 6,face = "bold"),
        legend.title = element_text(face = "bold",size = 8),
        legend.key.size = unit(0.5, 'cm'),
        legend.position = "bottom",
        legend.justification = "right",
        plot.title = element_text(hjust = 0.5),
        axis.text.y.right = element_text(face = "bold.italic",size = 10,colour = "black",vjust = 0.5, hjust=0.5)) +
  coord_flip()
p11


p12 <- ggplot() +
  geom_bar(data=mydata_category,aes(x=drug,y=0.2,fill=ATC1stLabel), 
           position = position_stack(),stat="identity") +
  scale_fill_manual(values = brewer.pal(n = 11, name = "Set3"), 
                    name = "Drug Category\n(ATC 1st Level)",
                    guide = guide_legend(ncol = 2, title.position = "top")) +
  geom_text(data=mydata_category,aes(x=drug,y=0.3,fill=ATC1stLabel,label=ATC1st),
            position = position_stack(reverse = T,vjust = 0.58),size = 2.5,fontface="bold",color="white") +
  new_scale_fill() + # Define scales before initiating a new one
  geom_bar(data=mydata_level,aes(x=drug,y=0.15,fill=level), 
           position = position_stack(),stat="identity") +
  scale_fill_manual(values = c("grey50","grey20","grey"), 
                    name = "China National Drug\nReimbursement Level",
                    guide = guide_legend(ncol = 1, title.position = "top")) +
  geom_text(data=mydata_level,aes(x=drug,y=0.25,fill=level,label=level),
            position = position_stack(reverse = T,vjust = 0.5),size = 2.5,fontface="bold",color="white") +
  new_scale_fill() + # Define scales before initiating a new one
  geom_bar(data=mydata_gene,aes(x=drug,y=percentage*0.1,fill=gene),
           position = position_stack(),stat="identity",show.legend=F) +
  scale_fill_manual(values = colors()[5:23], name = "Associated Gene", 
                    guide = guide_legend(ncol = 3, title.position = "top")) +
  scale_x_discrete(limits = rev(levels(mydata_gene$drug)),position = "top") +
  geom_text(data=mydata_gene,aes(x=drug,y=percentage*0.1,fill=gene,label=gene,fontface="bold.italic"), 
            position = position_stack(vjust = 0.5), size = 2.5,fontface="bold.italic") +
  scale_x_discrete(limits = rev(levels(mydata_usage$drug))) +
  labs(title = "Drugs                              Genes                        CNDR              ATCcode") +
  theme_classic() +
  theme(axis.text.x = element_blank(),
        axis.title = element_blank(),
        axis.line = element_blank(),
        axis.ticks = element_blank(),
        legend.text = element_text(size = 6,face = "bold"),
        legend.title = element_text(face = "bold",size = 8),
        legend.key.size = unit(0.5, 'cm'),
        legend.position = "bottom",
        legend.justification = "left",
        plot.title = element_text(hjust = -0.4),
        axis.text.y = element_text(face = "bold.italic",size = 10,colour = "black",vjust = 0.5, hjust=0.5)) +
  coord_flip()
p12


ggarrange(p11, NULL, p12, ncol = 3, nrow = 1, widths = c(0.8,-0.125,1))
ggsave("drug_usage_stat_Pediatric&Adult_modified_0621.pdf", width = 15, height = 8, dpi = 300, units = c("in"))
