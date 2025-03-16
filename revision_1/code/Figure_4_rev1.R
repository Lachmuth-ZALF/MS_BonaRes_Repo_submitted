# Clear workspace
rm(list = ls())
gc()

wd <- "C:/"
setwd(wd)

# Load packages -----------------------------------------------------------
library(ggplot2)

# Read and summarize data ---------------------------------------------------------------
dat<-read.table("~/reuse_type.txt",
               header = T, sep = "\t", stringsAsFactors = T )
str(dat)
summary(dat)

# Reorder by Sum value
dat <- dat[order(dat$Sum, decreasing = TRUE), ]


# Plot Figure 4 -----------------------------------------------------------
ggplot(dat, aes(x = reorder(Reuse_purpose, Sum), y = Sum)) +
  geom_bar(stat = "identity", 
           fill = "#00a7c7",
           width = 0.75) +
  theme_minimal() + theme(aspect.ratio = .7)+
  coord_flip() +  
  labs(
    title = "Reuse type",
    x = "",
    y = "Count") +
  theme(axis.text.y = element_text(size = 12, margin = margin(r = 10)),
    axis.text.x = element_text(size = 11),
    plot.title = element_text(hjust = 0.5, size = 14),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    plot.margin = margin(20, 3, 20, 3),
    axis.line.x = element_line(color = "grey92", size = 0.5)) +
  scale_y_continuous(expand = c(0, 0))  


# Save Figure 4 -----------------------------------------------------------
ggsave("Figure_4.png", 
       width = 8,      # width in inches
       height = 4,     # height in inches
       bg = "white",
       dpi = 300)  




