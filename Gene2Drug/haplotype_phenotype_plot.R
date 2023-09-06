
library(ggplot2)
library(RColorBrewer)
library(ggmap) # 为了引用主题theme_nothing
library(forcats)
library(ggpubr)


#---------------- CYP2D6 -----------------#
myGdata <- read.table("CYP2D6_genotype_freq.tsv", header = T, sep = "\t")
myGdata <- myGdata[myGdata$Frequency>0.008,]
myGdata <- myGdata[order(myGdata$Frequency),]

CYP2D6p1 <- ggplot(data = myGdata) +
  geom_bar(aes(x=Gene,y=Frequency,fill=fct_rev(fct_reorder(Haplotype, Frequency))), stat = "identity", width = 0.19) +
  scale_fill_manual(values = c("#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C", "#FB9A99", "#E31A1C", "#FDBF6F", "#FF7F00", 
                                        "#CAB2D6", "#6A3D9A", "#FFFF99", "#B15928", "grey", "black")) +
                                          theme_bw() +
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        legend.position = c(-0.18,0.5),
        legend.background = element_rect(colour = 'black', fill = 'transparent', linetype='blank'),
        plot.margin = margin(1.5,1,1.5,3, "cm"),
        axis.text.x = element_text(size = 10),
        axis.ticks.x = element_blank(),
        axis.title.y =  element_text(size = 8, face = "bold"),
        axis.text.y = element_text(size = 8),
        plot.title = element_text(hjust = 0.1, size = 11, face = "bold")) + 
  labs(x="", y="Allele Frequency", title = "CYP2D6 Haplotype") +
  scale_x_discrete(expand = expansion(add=c(0.12,0.5)), labels = c("n = 5986")) +
  guides(fill = guide_legend(title = "Haplotypes", title.position = "top", label.position = "left", label.hjust = 1))

CYP2D6p1

myPdata <- read.table("CYP2D6_phenotype_raw.txt", header = T, sep = "\t")
myPdata <- myPdata[order(myPdata$Frequency),]

CYP2D6p2 <- ggplot(data = myPdata) +
  geom_bar(aes(x=Gene,y=Frequency,fill=fct_rev(fct_reorder(Phenotype, Frequency))), stat = "identity", width = 0.21) +
  scale_fill_manual(values = c("#1F78B4", "#33A02C", "#FDBF6F", "#E31A1C", "#6A3D9A")) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        panel.background = element_rect(fill = "transparent"),
        legend.position = c(1.3,0.5),
        legend.background = element_rect(colour = 'black', fill = 'transparent', linetype='blank'),
        plot.background = element_rect(fill='transparent', color=NA),
        plot.margin = margin(1.5,5,1.5,1, "cm"),
        axis.text.x = element_text(size = 10),
        axis.ticks.x = element_blank(),
        axis.title.y =  element_text(size = 8, face = "bold"),
        axis.text.y = element_text(size = 8),
        plot.title = element_text(hjust = 0.93, size = 11, face = "bold")) + 
  scale_y_continuous(position = "right") +
  labs(x="", y="Frequency in QDcohort" , title = "CYP2D6 Phenotype") +
  scale_x_discrete(expand = expansion(add=c(0.5,0.12)), labels = c("n = 5986")) +
  guides(fill = guide_legend(title = "Phenotypes", title.position = "top"))

CYP2D6p2

CYP2D6p3 <- ggarrange(CYP2D6p1, NULL, CYP2D6p2, ncol = 3, nrow = 1, widths = c(1,-0.9,1), labels = "A")
CYP2D6p3



#---------------- CYP2B6 -----------------#
myGdata <- read.table("CYP2B6_genotype_freq.tsv", header = T, sep = "\t")
myGdata <- myGdata[order(myGdata$Frequency),]

CYP2B6p1 <- ggplot(data = myGdata) +
  geom_bar(aes(x=Gene,y=Frequency,fill=fct_rev(fct_reorder(Haplotype, Frequency))), stat = "identity", width = 0.19) +
  scale_fill_manual(values = c("#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C", "#FB9A99", "#E31A1C", "#FDBF6F", "#FF7F00", 
                                        "#CAB2D6", "#6A3D9A", "#FFFF99", "#B15928", "grey", "black")) +
                                          theme_bw() +
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        legend.position = c(-0.18,0.5),
        legend.background = element_rect(colour = 'black', fill = 'transparent', linetype='blank'),
        plot.margin = margin(1.5,1,1.5,3, "cm"),
        axis.text.x = element_text(size = 10),
        axis.ticks.x = element_blank(),
        axis.title.y =  element_text(size = 8, face = "bold"),
        axis.text.y = element_text(size = 8),
        plot.title = element_text(hjust = 0.1, size = 11, face = "bold")) + 
  labs(x="", y="Allele Frequency", title = "CYP2B6 Haplotype") +
  scale_x_discrete(expand = expansion(add=c(0.12,0.5)), labels = c("n = 6442")) +
  guides(fill = guide_legend(title = "Haplotypes", title.position = "top", label.position = "left", label.hjust = 1))

myPdata <- read.table("CYP2B6_phenotype_raw.txt", header = T, sep = "\t")
myPdata <- myPdata[order(myPdata$Frequency),]

CYP2B6p2 <- ggplot(data = myPdata) +
  geom_bar(aes(x=Gene,y=Frequency,fill=fct_rev(fct_reorder(Phenotype, Frequency))), stat = "identity", width = 0.21) +
  scale_fill_manual(values = c("#1F78B4", "#33A02C", "#FDBF6F", "#E31A1C", "#6A3D9A", "#B15928")) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        panel.background = element_rect(fill = "transparent"),
        legend.position = c(1.3,0.5),
        legend.background = element_rect(colour = 'black', fill = 'transparent', linetype='blank'),
        plot.background = element_rect(fill='transparent', color=NA),
        plot.margin = margin(1.5,5,1.5,1, "cm"),
        axis.text.x = element_text(size = 10),
        axis.ticks.x = element_blank(),
        axis.title.y =  element_text(size = 8, face = "bold"),
        axis.text.y = element_text(size = 8),
        plot.title = element_text(hjust = 0.93, size = 11, face = "bold")) + 
  scale_y_continuous(position = "right") +
  labs(x="", y="Frequency in QDcohort" , title = "CYP2B6 Phenotype") +
  scale_x_discrete(expand = expansion(add=c(0.5,0.12)), labels = c("n = 6442")) +
  guides(fill = guide_legend(title = "Phenotypes", title.position = "top"))

CYP2B6p3 <- ggarrange(CYP2B6p1, NULL, CYP2B6p2, ncol = 3, nrow = 1, widths = c(1,-0.9,1), labels = "B")
CYP2B6p3



#---------------- CYP3A5 -----------------#
myGdata <- read.table("CYP3A5_genotype_freq.tsv", header = T, sep = "\t")
myGdata <- myGdata[order(myGdata$Frequency),]

CYP3A5p1 <- ggplot(data = myGdata) +
  geom_bar(aes(x=Gene,y=Frequency,fill=fct_rev(fct_reorder(Haplotype, Frequency))), stat = "identity", width = 0.19) +
  scale_fill_manual(values = c("#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C", "#FB9A99", "#E31A1C", "#FDBF6F", "#FF7F00", 
                                        "#CAB2D6", "#6A3D9A", "#FFFF99", "#B15928", "grey", "black")) +
                                          theme_bw() +
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        legend.position = c(-0.18,0.5),
        legend.background = element_rect(colour = 'black', fill = 'transparent', linetype='blank'),
        plot.margin = margin(1.5,1,1.5,3, "cm"),
        axis.text.x = element_text(size = 10),
        axis.ticks.x = element_blank(),
        axis.title.y =  element_text(size = 8, face = "bold"),
        axis.text.y = element_text(size = 8),
        plot.title = element_text(hjust = 0.1, size = 11, face = "bold")) + 
  labs(x="", y="Allele Frequency", title = "CYP3A5 Haplotype") +
  scale_x_discrete(expand = expansion(add=c(0.12,0.5)), labels = c("n = 6442")) +
  guides(fill = guide_legend(title = "Haplotypes", title.position = "top", label.position = "left", label.hjust = 1))

myPdata <- read.table("CYP3A5_phenotype_raw.txt", header = T, sep = "\t")
myPdata <- myPdata[order(myPdata$Frequency),]

CYP3A5p2 <- ggplot(data = myPdata) +
  geom_bar(aes(x=Gene,y=Frequency,fill=fct_rev(fct_reorder(Phenotype, Frequency))), stat = "identity", width = 0.21) +
  scale_fill_manual(values = c("#1F78B4", "#33A02C", "#FDBF6F", "#E31A1C", "#6A3D9A", "#B15928")) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        panel.background = element_rect(fill = "transparent"),
        legend.position = c(1.3,0.5),
        legend.background = element_rect(colour = 'black', fill = 'transparent', linetype='blank'),
        plot.background = element_rect(fill='transparent', color=NA),
        plot.margin = margin(1.5,5,1.5,1, "cm"),
        axis.text.x = element_text(size = 10),
        axis.ticks.x = element_blank(),
        axis.title.y =  element_text(size = 8, face = "bold"),
        axis.text.y = element_text(size = 8),
        plot.title = element_text(hjust = 0.93, size = 11, face = "bold")) + 
  scale_y_continuous(position = "right") +
  labs(x="", y="Frequency in QDcohort" , title = "CYP3A5 Phenotype") +
  scale_x_discrete(expand = expansion(add=c(0.5,0.12)), labels = c("n = 6442")) +
  guides(fill = guide_legend(title = "Phenotypes", title.position = "top"))

CYP3A5p3 <- ggarrange(CYP3A5p1, NULL, CYP3A5p2, ncol = 3, nrow = 1, widths = c(1,-0.9,1), labels = "C")
CYP3A5p3



#---------------- CYP2C9 -----------------#
myGdata <- read.table("CYP2C9_genotype_freq.tsv", header = T, sep = "\t")
myGdata <- myGdata[order(myGdata$Frequency),]

CYP2C9p1 <- ggplot(data = myGdata) +
  geom_bar(aes(x=Gene,y=Frequency,fill=fct_rev(fct_reorder(Haplotype, Frequency))), stat = "identity", width = 0.19) +
  scale_fill_manual(values = c("#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C", "#FB9A99", "#E31A1C", "#FDBF6F", "#FF7F00", 
                                        "#CAB2D6", "#6A3D9A", "#FFFF99", "#B15928", "grey", "black")) +
                                          theme_bw() +
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        legend.position = c(-0.18,0.5),
        legend.background = element_rect(colour = 'black', fill = 'transparent', linetype='blank'),
        plot.margin = margin(1.5,1,1.5,3, "cm"),
        axis.text.x = element_text(size = 10),
        axis.ticks.x = element_blank(),
        axis.title.y =  element_text(size = 8, face = "bold"),
        axis.text.y = element_text(size = 8),
        plot.title = element_text(hjust = 0.1, size = 11, face = "bold")) + 
  labs(x="", y="Allele Frequency", title = "CYP2C9 Haplotype") +
  scale_x_discrete(expand = expansion(add=c(0.12,0.5)), labels = c("n = 6442")) +
  guides(fill = guide_legend(title = "Haplotypes", title.position = "top", label.position = "left", label.hjust = 1))

myPdata <- read.table("CYP2C9_phenotype_raw.txt", header = T, sep = "\t")
myPdata <- myPdata[order(myPdata$Frequency),]

CYP2C9p2 <- ggplot(data = myPdata) +
  geom_bar(aes(x=Gene,y=Frequency,fill=fct_rev(fct_reorder(Phenotype, Frequency))), stat = "identity", width = 0.21) +
  scale_fill_manual(values = c("#1F78B4", "#33A02C", "#FDBF6F", "#E31A1C", "#6A3D9A", "#B15928")) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        panel.background = element_rect(fill = "transparent"),
        legend.position = c(1.3,0.5),
        legend.background = element_rect(colour = 'black', fill = 'transparent', linetype='blank'),
        plot.background = element_rect(fill='transparent', color=NA),
        plot.margin = margin(1.5,5,1.5,1, "cm"),
        axis.text.x = element_text(size = 10),
        axis.ticks.x = element_blank(),
        axis.title.y =  element_text(size = 8, face = "bold"),
        axis.text.y = element_text(size = 8),
        plot.title = element_text(hjust = 0.93, size = 11, face = "bold")) + 
  scale_y_continuous(position = "right") +
  labs(x="", y="Frequency in QDcohort" , title = "CYP2C9 Phenotype") +
  scale_x_discrete(expand = expansion(add=c(0.5,0.12)), labels = c("n = 6442")) +
  guides(fill = guide_legend(title = "Phenotypes", title.position = "top"))

CYP2C9p3 <- ggarrange(CYP2C9p1, NULL, CYP2C9p2, ncol = 3, nrow = 1, widths = c(1,-0.9,1), labels = "D")
CYP2C9p3



#---------------- CYP2C19 -----------------#
myGdata <- read.table("CYP2C19_genotype_freq.tsv", header = T, sep = "\t")
myGdata <- myGdata[order(myGdata$Frequency),]

CYP2C19p1 <- ggplot(data = myGdata) +
  geom_bar(aes(x=Gene,y=Frequency,fill=fct_rev(fct_reorder(Haplotype, Frequency))), stat = "identity", width = 0.19) +
  scale_fill_manual(values = c("#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C", "#FB9A99", "#E31A1C", "#FDBF6F", "#FF7F00", 
                                        "#CAB2D6", "#6A3D9A", "#FFFF99", "#B15928", "grey", "black")) +
                                          theme_bw() +
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        legend.position = c(-0.18,0.5),
        legend.background = element_rect(colour = 'black', fill = 'transparent', linetype='blank'),
        plot.margin = margin(1.5,1,1.5,3, "cm"),
        axis.text.x = element_text(size = 10),
        axis.ticks.x = element_blank(),
        axis.title.y =  element_text(size = 8, face = "bold"),
        axis.text.y = element_text(size = 8),
        plot.title = element_text(hjust = 0.1, size = 11, face = "bold")) + 
  labs(x="", y="Allele Frequency", title = "CYP2C19 Haplotype") +
  scale_x_discrete(expand = expansion(add=c(0.12,0.5)), labels = c("n = 6442")) +
  guides(fill = guide_legend(title = "Haplotypes", title.position = "top", label.position = "left", label.hjust = 1))

myPdata <- read.table("CYP2C19_phenotype_raw.txt", header = T, sep = "\t")
myPdata <- myPdata[order(myPdata$Frequency),]

CYP2C19p2 <- ggplot(data = myPdata) +
  geom_bar(aes(x=Gene,y=Frequency,fill=fct_rev(fct_reorder(Phenotype, Frequency))), stat = "identity", width = 0.21) +
  scale_fill_manual(values = c("#1F78B4", "#33A02C", "#FDBF6F", "#E31A1C", "#6A3D9A", "#B15928")) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        panel.background = element_rect(fill = "transparent"),
        legend.position = c(1.3,0.5),
        legend.background = element_rect(colour = 'black', fill = 'transparent', linetype='blank'),
        plot.background = element_rect(fill='transparent', color=NA),
        plot.margin = margin(1.5,5,1.5,1, "cm"),
        axis.text.x = element_text(size = 10),
        axis.ticks.x = element_blank(),
        axis.title.y =  element_text(size = 8, face = "bold"),
        axis.text.y = element_text(size = 8),
        plot.title = element_text(hjust = 0.93, size = 11, face = "bold")) + 
  scale_y_continuous(position = "right") +
  labs(x="", y="Frequency in QDcohort" , title = "CYP2C19 Phenotype") +
  scale_x_discrete(expand = expansion(add=c(0.5,0.12)), labels = c("n = 6442")) +
  guides(fill = guide_legend(title = "Phenotypes", title.position = "top"))

CYP2C19p3 <- ggarrange(CYP2C19p1, NULL, CYP2C19p2, ncol = 3, nrow = 1, widths = c(1,-0.9,1), labels = "E")
CYP2C19p3



#---------------- CYP4F2 -----------------#
myGdata <- read.table("CYP4F2_genotype_freq.tsv", header = T, sep = "\t")
myGdata <- myGdata[order(myGdata$Frequency),]

CYP4F2p1 <- ggplot(data = myGdata) +
  geom_bar(aes(x=Gene,y=Frequency,fill=fct_rev(fct_reorder(Haplotype, Frequency))), stat = "identity", width = 0.19) +
  scale_fill_manual(values = c("#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C", "#FB9A99", "#E31A1C", "#FDBF6F", "#FF7F00", 
                                        "#CAB2D6", "#6A3D9A", "#FFFF99", "#B15928", "grey", "black")) +
                                          theme_bw() +
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        legend.position = c(-0.18,0.5),
        legend.background = element_rect(colour = 'black', fill = 'transparent', linetype='blank'),
        plot.margin = margin(1.5,1,1.5,3, "cm"),
        axis.text.x = element_text(size = 10),
        axis.ticks.x = element_blank(),
        axis.title.y =  element_text(size = 8, face = "bold"),
        axis.text.y = element_text(size = 8),
        plot.title = element_text(hjust = 0.1, size = 11, face = "bold")) + 
  labs(x="", y="Allele Frequency", title = "CYP4F2 Haplotype") +
  scale_x_discrete(expand = expansion(add=c(0.12,0.5)), labels = c("n = 6442")) +
  guides(fill = guide_legend(title = "Haplotypes", title.position = "top", label.position = "left", label.hjust = 1))

myPdata <- read.table("CYP4F2_phenotype_raw.txt", header = T, sep = "\t")
myPdata <- myPdata[order(myPdata$Frequency),]

CYP4F2p2 <- ggplot(data = myPdata) +
  geom_bar(aes(x=Gene,y=Frequency,fill=fct_rev(fct_reorder(Phenotype, Frequency))), stat = "identity", width = 0.21) +
  scale_fill_manual(values = c("#1F78B4", "#33A02C", "#FDBF6F", "#E31A1C", "#6A3D9A", "#B15928")) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        panel.background = element_rect(fill = "transparent"),
        legend.position = c(1.3,0.5),
        legend.background = element_rect(colour = 'black', fill = 'transparent', linetype='blank'),
        plot.background = element_rect(fill='transparent', color=NA),
        plot.margin = margin(1.5,5,1.5,1, "cm"),
        axis.text.x = element_text(size = 10),
        axis.ticks.x = element_blank(),
        axis.title.y =  element_text(size = 8, face = "bold"),
        axis.text.y = element_text(size = 8),
        plot.title = element_text(hjust = 0.93, size = 11, face = "bold")) + 
  scale_y_continuous(position = "right") +
  labs(x="", y="Frequency in QDcohort" , title = "CYP4F2 Phenotype") +
  scale_x_discrete(expand = expansion(add=c(0.5,0.12)), labels = c("n = 6442")) +
  guides(fill = guide_legend(title = "Phenotypes", title.position = "top"))

CYP4F2p3 <- ggarrange(CYP4F2p1, NULL, CYP4F2p2, ncol = 3, nrow = 1, widths = c(1,-0.9,1), labels = "F")
CYP4F2p3



#------------------ final integrate -------------------#
ggarrange(ggarrange(CYP2D6p1, NULL, CYP2D6p2, ncol = 3, nrow = 1, widths = c(1,-0.9,1), labels = "A."),
          ggarrange(CYP2B6p1, NULL, CYP2B6p2, ncol = 3, nrow = 1, widths = c(1,-0.9,1), labels = "B."),
          ggarrange(CYP3A5p1, NULL, CYP3A5p2, ncol = 3, nrow = 1, widths = c(1,-0.9,1), labels = "C."),
          ggarrange(CYP2C9p1, NULL, CYP2C9p2, ncol = 3, nrow = 1, widths = c(1,-0.9,1), labels = "D."),
          ggarrange(CYP2C19p1, NULL, CYP2C19p2, ncol = 3, nrow = 1, widths = c(1,-0.9,1), labels = "E."),
          ggarrange(CYP4F2p1, NULL, CYP4F2p2, ncol = 3, nrow = 1, widths = c(1,-0.9,1), labels = "F."),
          ncol = 2, nrow = 3)

ggsave("Genotype_phenotype_CYP.PDF", width = 16, height = 18, dpi = 300, units = c("in"))
