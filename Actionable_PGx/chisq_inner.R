# ----------------------------------------------------------------------#
# This R programme is for chi-square test, need two parameters
# the 1st parameter: input file
# the 2nd parameter: output file
# the 3rd parameter: correct method
#
#-----------------------------------------------------------------------#
options <- commandArgs(trailingOnly = T)
infile = options[1];
outfile = options[2];
method  = options[3];

if( length(options) < 3 ){
	method="BH";
}
data<-read.table(infile,header=T,sep="\t")

pvalue1<-vector(mode = "numeric", length = nrow(data))
pvalue2<-vector(mode = "numeric", length=nrow(data))
pvalue3<-vector(mode = "numeric", length=nrow(data))
for (i in 1:nrow(data)){
  dat1<-as.vector(unlist(data[i,2:5]))
  chiq<-chisq.test(matrix(dat1,nrow=2,byrow=F),correct=FALSE)
  expect<-chiq$expected
  #pvalue[i]<-chiq$p.value
  if(sum(expect) < 40 || min(expect) < 1 ){
    pvalue1[i]<-fisher.test(matrix(dat1,nrow=2,byrow=F))$p.value
  }else if(min(expect)<5 ){
    pvalue1[i]<-chisq.test(matrix(dat1,nrow=2,byrow=F),correct=TRUE)$p.value
  }else{
    pvalue1[i]<-chiq$p.value
 }
  dat2<-as.vector(unlist(data[i,c(2,3,6,7)]))
  chiq<-chisq.test(matrix(dat2,nrow=2,byrow=F),correct=FALSE)
  expect<-chiq$expected
  #pvalue[i]<-chiq$p.value
  if(sum(expect) < 40 || min(expect) < 1 ){
    pvalue2[i]<-fisher.test(matrix(dat2,nrow=2,byrow=F))$p.value
  }else if(min(expect)<5 ){
    pvalue2[i]<-chisq.test(matrix(dat2,nrow=2,byrow=F),correct=TRUE)$p.value
  }else{
    pvalue2[i]<-chiq$p.value
 }

  dat3<-as.vector(unlist(data[i,6:9]))
  chiq<-chisq.test(matrix(dat3,nrow=2,byrow=F),correct=FALSE)
  expect<-chiq$expected
  #pvalue[i]<-chiq$p.value
  if(sum(expect) < 40 || min(expect) < 1 ){
    pvalue3[i]<-fisher.test(matrix(dat3,nrow=2,byrow=F))$p.value
  }else if(min(expect)<5 ){
    pvalue3[i]<-chisq.test(matrix(dat3,nrow=2,byrow=F),correct=TRUE)$p.value
  }else{
    pvalue3[i]<-chiq$p.value
 }
}

#qvalue=p.adjust(pvalue,method=method)
data$CentralvsNorth<-pvalue1
data$CentralvsSouth<-pvalue2
data$NorthvsSouth<-pvalue3
#data$Qvalue<-qvalue
write.table(data,file=outfile,sep="\t", quote=F, row.names=F)
