
setwd('~/Desktop/科研/青岛一万例PGx/分析/7140samples/ancestry/ADMIXTURE/QD6442Han')

library(ggplot2)
library(RColorBrewer)
col <- colorRampPalette(brewer.pal(12,'Set3'))(12)


#k2
pdf(file= "K2.pdf",width=12, height=6);

tbl<-read.table('QD6442Han.2.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V5))), 
        names.arg = c(rep("",90),rep("North",29),rep("",90),
                      rep("",35),rep("Central",27),rep("",35),
                      rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3]),border=NA,horiz=F,space=0,ylab="K=2")
abline(v = c(209,306,375),lty=1,lwd=2)

dev.off();


#k3
pdf(file= "K3.pdf",width=12, height=6);

tbl<-read.table('QD6442Han.3.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V6))), 
        names.arg = c(rep("",90),rep("North",29),rep("",90),
                      rep("",35),rep("Central",27),rep("",35),
                      rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2]),border=NA,horiz=F,space=0,ylab="K=3")
abline(v = c(209,306,375),lty=1,lwd=2)

dev.off();


#k4
pdf(file= "K4.pdf",width=12, height=6);

tbl<-read.table('QD6442Han.4.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V7))), 
        names.arg = c(rep("",90),rep("North",29),rep("",90),
                      rep("",35),rep("Central",27),rep("",35),
                      rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2],col[4]),border=NA,horiz=F,space=0,ylab="K=4")
abline(v = c(209,306,375),lty=1,lwd=2)

dev.off();


#k5
pdf(file= "K5.pdf",width=12, height=6);

tbl<-read.table('QD6442Han.5.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V8))), 
        names.arg = c(rep("",90),rep("North",29),rep("",90),
                      rep("",35),rep("Central",27),rep("",35),
                      rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2],col[4],col[5]),border=NA,horiz=F,space=0,ylab="K=5")
abline(v = c(209,306,375),lty=1,lwd=2)

dev.off();


#k6
pdf(file= "K6.pdf",width=12, height=6);

tbl<-read.table('QD6442Han.6.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V9))), 
        names.arg = c(rep("",90),rep("North",29),rep("",90),
                      rep("",35),rep("Central",27),rep("",35),
                      rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2],col[4],col[5],col[6]),border=NA,horiz=F,space=0,ylab="K=6")
abline(v = c(209,306,375),lty=1,lwd=2)

dev.off();


#k7
pdf(file= "K7.pdf",width=6, height=6);

tbl<-read.table('QD6442Han.7.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V10))), 
        names.arg = c(rep("",90),rep("North",29),rep("",90),
                      rep("",35),rep("Central",27),rep("",35),
                      rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2],col[4],col[5],col[6],col[7]),border=NA,horiz=F,space=0,ylab="K=7")
abline(v = c(209,306,375),lty=1,lwd=2)

dev.off();


#k8
pdf(file= "K8.pdf",width=12, height=6);

tbl<-read.table('QD6442Han.8.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V11))), 
        names.arg = c(rep("",90),rep("North",29),rep("",90),
                      rep("",35),rep("Central",27),rep("",35),
                      rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2],col[4],col[5],col[6],col[7],col[8]),border=NA,horiz=F,space=0,ylab="K=8")
abline(v = c(209,306,375),lty=1,lwd=2)

dev.off();


#k9
pdf(file= "K9.pdf",width=12, height=6);

tbl<-read.table('QD6442Han.9.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V12))), 
        names.arg = c(rep("",90),rep("North",29),rep("",90),
                      rep("",35),rep("Central",27),rep("",35),
                      rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2],col[4],col[5],col[6],col[7],col[8],col[10]),border=NA,horiz=F,space=0,ylab="K=9")
abline(v = c(209,306,375),lty=1,lwd=2)

dev.off();


#k10
pdf(file= "K10.pdf",width=12, height=6);

tbl<-read.table('QD6442Han.10.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V13))), 
        names.arg = c(rep("",90),rep("North",29),rep("",90),
                      rep("",35),rep("Central",27),rep("",35),
                      rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2],col[4],col[5],col[6],col[7],col[8],col[10],col[9]),border=NA,horiz=F,space=0,ylab="K=10")
abline(v = c(209,306,375),lty=1,lwd=2)

dev.off();


#k11
pdf(file= "K11.pdf",width=12, height=6);

tbl<-read.table('QD6442Han.11.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V14))), 
        names.arg = c(rep("",90),rep("North",29),rep("",90),
                      rep("",35),rep("Central",27),rep("",35),
                      rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2],col[4],col[5],col[6],col[7],col[8],col[10],col[9],"dodgerblue"),border=NA,horiz=F,space=0,ylab="K=11")
abline(v = c(209,306,375),lty=1,lwd=2)

dev.off();



#-----------------------------------------------------------------------------------------------------#

setwd('~/Desktop/科研/青岛一万例PGx/分析/7140samples/ancestry/ADMIXTURE/QD6442Han')

library(ggplot2)
library(RColorBrewer)

pdf(file= "ADMIXTURE_plot_QD6442Han_K3to11.pdf",width=12, height=12)

#df <- data.frame(K=c(2,3,4,5,6,7,8,9,10,11),
                 #CVerror=c(0.39087,0.39064,0.39059,0.36625,0.34323,0.30444,0.30538,0.32967,0.39676,0.42213),
                 #gp=c(0,0,0,0,0,1,0,0,0,0))

df <- data.frame(K=c(3,4,5,6,7,8,9,10,11),
                 CVerror=c(0.39064,0.39059,0.36625,0.34323,0.30444,0.30538,0.32967,0.39676,0.42213),
                 gp=c(0,0,0,0,1,0,0,0,0))

p <- ggplot(df, aes(x=K, y=CVerror)) +
  geom_point(aes(group=gp, color=factor(gp)), show.legend = F) + scale_color_manual(values = c("black","red")) + 
  geom_line(linetype=5) + labs(x="K", y="Cross Validation Error") + theme_classic() +
  theme(axis.title = element_text(face = "bold", size = 12),
        axis.text = element_text(face = "bold", size = 10),
        panel.background = element_rect(fill=alpha('white', 0.3)),
        plot.background = element_rect(fill=alpha('white', 0.3)))
p

col <- colorRampPalette(brewer.pal(12,'Set3'))(12)

par(mar = c(0.1, 5, 0.5, 0.2))
#par(mfrow=c(11,1))
par(mfrow=c(10,1))


#tbl<-read.table('QD6442Han.2.Q.sample.pop.final.Norththin.txt',sep='\t')
#barplot(t(as.matrix(subset(tbl, select=V4:V5))), axisnames=F, font.axis=2, cex.axis=0.7, font.lab=2, cex.lab=2,
        #names.arg = c(rep("",90),rep("North",29),rep("",90),
                      #rep("",35),rep("Central",27),rep("",35),
                      #rep("",20),rep("South",29),rep("",20)),
#        col=c(col[1],col[3]),border=NA,horiz=F,axes=T,ylim = c(0,1.0),space=0,ylab="K=2")
#abline(v = c(209,306,375),lty=1,lwd=2)


tbl<-read.table('QD6442Han.3.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V6))), axisnames=F, font.axis=2, cex.axis=0.7, font.lab=2, cex.lab=2,
        #names.arg = c(rep("",90),rep("North",29),rep("",90),
                      #rep("",35),rep("Central",27),rep("",35),
                      #rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2]),border=NA,horiz=F,axes=T,space=0,ylab="K=3")
abline(v = c(209,306,375),lty=1,lwd=2)


tbl<-read.table('QD6442Han.4.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V7))), axisnames=F, font.axis=2, cex.axis=0.7, font.lab=2, cex.lab=2,
        #names.arg = c(rep("",90),rep("North",29),rep("",90),
                      #rep("",35),rep("Central",27),rep("",35),
                      #rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2],col[4]),border=NA,horiz=F,axes=T,space=0,ylab="K=4")
abline(v = c(209,306,375),lty=1,lwd=2)


tbl<-read.table('QD6442Han.5.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V8))), axisnames=F, font.axis=2, cex.axis=0.7, font.lab=2, cex.lab=2,
        #names.arg = c(rep("",90),rep("North",29),rep("",90),
                      #rep("",35),rep("Central",27),rep("",35),
                      #rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2],col[4],col[5]),border=NA,horiz=F,axes=T,space=0,ylab="K=5")
abline(v = c(209,306,375),lty=1,lwd=2)


tbl<-read.table('QD6442Han.6.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V9))), axisnames=F, font.axis=2, cex.axis=0.7, font.lab=2, cex.lab=2,
        #names.arg = c(rep("",90),rep("North",29),rep("",90),
                      #rep("",35),rep("Central",27),rep("",35),
                      #rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2],col[4],col[5],col[6]),border=NA,horiz=F,axes=T,space=0,ylab="K=6")
abline(v = c(209,306,375),lty=1,lwd=2)


tbl<-read.table('QD6442Han.7.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V10))), axisnames=F, font.axis=2, cex.axis=0.7, font.lab=2, cex.lab=2,
        #names.arg = c(rep("",90),rep("North",29),rep("",90),
                      #rep("",35),rep("Central",27),rep("",35),
                      #rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2],col[4],col[5],col[6],col[7]),border=NA,horiz=F,axes=T,space=0,ylab="K=7")
abline(v = c(209,306,375),lty=1,lwd=2)


tbl<-read.table('QD6442Han.8.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V11))), axisnames=F, font.axis=2, cex.axis=0.7, font.lab=2, cex.lab=2,
        #names.arg = c(rep("",90),rep("North",29),rep("",90),
                      #rep("",35),rep("Central",27),rep("",35),
                      #rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2],col[4],col[5],col[6],col[7],col[8]),border=NA,horiz=F,axes=T,space=0,ylab="K=8")
abline(v = c(209,306,375),lty=1,lwd=2)


tbl<-read.table('QD6442Han.9.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V12))), axisnames=F, font.axis=2, cex.axis=0.7, font.lab=2, cex.lab=2,
        #names.arg = c(rep("",90),rep("North",29),rep("",90),
                      #rep("",35),rep("Central",27),rep("",35),
                      #rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2],col[4],col[5],col[6],col[7],col[8],col[10]),border=NA,horiz=F,axes=T,space=0,ylab="K=9")
abline(v = c(209,306,375),lty=1,lwd=2)


tbl<-read.table('QD6442Han.10.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V13))), axisnames=F, font.axis=2, cex.axis=0.7, font.lab=2, cex.lab=2,
        #names.arg = c(rep("",90),rep("North",29),rep("",90),
                      #rep("",35),rep("Central",27),rep("",35),
                      #rep("",20),rep("South",29),rep("",20)),
        col=c(col[1],col[3],col[2],col[4],col[5],col[6],col[7],col[8],col[10],col[9]),border=NA,horiz=F,axes=T,space=0,ylab="K=10")
abline(v = c(209,306,375),lty=1,lwd=2)


tbl<-read.table('QD6442Han.11.Q.sample.pop.final.Norththin.txt',sep='\t')
barplot(t(as.matrix(subset(tbl, select=V4:V14))), font.axis=2, cex.axis=0.7, font.lab=2, cex.lab=2,
        names.arg = c(rep("",100),rep("North",9),rep("",100),
                      rep("",44),rep("Central",9),rep("",44),
                      rep("",30),rep("South",9),rep("",30)),
        col=c(col[1],col[3],col[2],col[4],col[5],col[6],col[7],col[8],col[10],col[9],"dodgerblue"),border=NA,horiz=F,axes=T,space=0,ylab="K=11")
abline(v = c(209,306,375),lty=1,lwd=2)


library(grid) #ggplot也是grid图

vie <- viewport(width=0.3,height=0.3,x=0.2,y=0.88) #x从左往右增大,y从下往上增大

print(p,vp=vie) #按上述格式vie,增加小图p

dev.off()
