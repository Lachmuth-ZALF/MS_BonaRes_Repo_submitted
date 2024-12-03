# Clear workspace
rm(list = ls())
gc()


# Load packages -----------------------------------------------------------
library(ggplot2)
library(dplyr)
library(scales)


# Plot settings -----------------------------------------------------------
a<-as.numeric(14)#axis.title.x 
b<-as.numeric(14)#axis.text.x and y
c<-as.numeric(0)#axis.title.y 
d<-as.numeric(14)#legend.text
e<-as.numeric(16)#legend.title
f<-as.numeric(14)#axis title margin

# Colors and shapes
cols<-c("#00a7c7","#fe5e31","gray","#FBE362" )#""#CAD01D","#FBE362"(gelb)


# Read and summarize data ---------------------------------------------------------------
dat<-read.table("~/repo_statistics.txt", header = T, sep = "\t", stringsAsFactors = T )
str(dat)
summary(dat)

# Year and type as factor
dat$type<-factor(dat$type, levels = c("published","DOIs","downloads","reuse"))
dat$year.fact<-factor(as.factor(dat$year), levels = c("before 2018","2018",
                                                  "2019","2020","2021",
                                                  "2022","2023","2024"))
# Barplot  --------------------------------------------
barplot <- ggplot(dat, aes(fill=type, y=number, x=year.fact)) + geom_bar(position="dodge", stat="identity")+
  scale_fill_manual(values=cols,name="", labels = c("Published datasets","DOIs assigned","Downloads", "Data reuse"))+
  scale_x_discrete(labels=c("before 2018" ,"2018","2019","2020","2021","2022","2023","2024"))+ 
  scale_y_sqrt(breaks =  c(0,5,10,50,100,200,400,600,800,1000)) +
  ylab("Count")+ 
  theme_minimal()+
  theme(
    axis.ticks.x = element_line(linewidth = 1, colour = "gray"), 
    axis.ticks.y = element_line(linewidth = 1, colour = "gray"),
    axis.ticks.length = unit(8, "pt"),
    axis.text.x = element_text(family="sans",size=b),
    axis.text.y = element_text(family="sans",size=b),
    axis.title.x = element_blank(),
    axis.title.y = element_text(family = "sans", size = a, margin = margin (t=f+20)),
    legend.text = element_text(family="sans",size=d),
    legend.title = element_text(family="sans",size=e),
    axis.line = element_line(linetype=1,color="gray"),
    plot.margin = unit(c(5, 5, 5, 10) * 2, "points"))+
  theme(legend.position="bottom")
barplot

