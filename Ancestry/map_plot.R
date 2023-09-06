
library(maps)
library(plyr)
library(maptools)
library(rgdal)
library(ggplot2)
library(sp)
library(colorspace)


#fork 九段线
l9 <- rgdal::readOGR("~/Desktop/R中国地图模板/SouthSea/九段线.shp")
#data reading
china_map <- rgdal::readOGR("~/Desktop/R中国地图模板/china/bou2_4p.shp", encoding =  "latin1")


ggplot(china_map,aes(x=long,y=lat,group=group)) +
  
  geom_polygon(fill="white",colour="grey") +
  
  coord_map("polyconic")


x <- china_map@data #读取行政信息

xs <- data.frame(x,id=seq(0:924)-1) #含岛屿共925个形状

china_map1 <- fortify(china_map) #转化为数据框

china_map_data <- join(china_map1, xs, type = "full") #合并两个数据框

mydata <- read.csv("ProvinceCount.csv", header = T, stringsAsFactors = F, fileEncoding = "latin1")

china_data <- join(china_map_data, mydata, type="full") #合并两个数据框

china_data$ratio <- cut(china_data$Level,breaks=c(1,2,3,4,5,6),labels=c('0','1-10','10-100','100-1000','>1000'),right=FALSE,order=TRUE)

province_city <- read.csv("chinaprovincecity2.csv", header = T, stringsAsFactors = F, fileEncoding = "latin1") #省会坐标


# plot base map
p1 <- ggplot(china_data, aes(x = long, y = lat)) +
  geom_polygon(aes(group = group, fill = ratio), colour="grey40", size=0.2) + #绘制分省图
  scale_fill_discrete_sequential(palette = "YlOrRd") +
  guides(fill=guide_legend(title='Number of individuals')) +
  coord_map("polyconic") +
  geom_text(data=province_city, aes(x = jd,y = wd,label = province), size=2) + #添加省会标签
  theme(  #清除不必要的背景元素
    panel.grid = element_blank(),
    panel.background = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    legend.position = c(0.2, 0.3),
    legend.background=element_blank()
  )
p1 


# plot upper layer map
p2 <- ggplot(china_data, aes(x = long, y = lat))+
  geom_polygon(aes(group = group, fill = ratio), colour="grey40", size=0.2) + #绘制分省图
  scale_fill_discrete_sequential(palette = "YlOrRd") +
  geom_line(data=l9,aes(x=long,y=lat,group=group),color="darkgrey",size=0.5)+ #绘制九段线
  coord_cartesian(xlim=c(107,123),ylim=c(3,25))+ #缩小显示范围在南部区域
  theme(
    aspect.ratio = 1.5, #调节长宽比
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    panel.background = element_blank(),
    panel.border = element_rect(fill=NA,color="grey20",linetype=1,size=0.8),
    plot.margin=unit(c(0,0,0,0),"mm"),
    legend.position = "none"
  )
p2


# integarte 2 maps
library(grid) 
vie <- viewport(width=0.15,height=0.10,x=0.68,y=0.25) #定义小图的绘图区域
p1 #绘制大图
print(p2,vp=vie) #在p1上按上述格式增加小图