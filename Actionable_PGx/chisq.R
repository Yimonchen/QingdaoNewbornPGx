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

pvalue<-vector(mode = "numeric", length = nrow(data))
for (i in 1:nrow(data)){
  dat<-as.vector(unlist(data[i,2:ncol(data)]))
  chiq<-chisq.test(matrix(dat,nrow=2,byrow=F),correct=FALSE)
  expect<-chiq$expected
  #pvalue[i]<-chiq$p.value
  if(sum(expect) < 40 || min(expect) < 1 ){
    pvalue[i]<-fisher.test(matrix(dat,nrow=2,byrow=F))$p.value
  }else if(min(expect)<5 ){
    pvalue[i]<-chisq.test(matrix(dat,nrow=2,byrow=F),correct=TRUE)$p.value
  }else{
    pvalue[i]<-chiq$p.value
  }
}

qvalue=p.adjust(pvalue,method=method)
data$Pvalue<-pvalue
data$Qvalue<-qvalue
write.table(data,file=outfile,sep="\t", quote=F, row.names=F)
