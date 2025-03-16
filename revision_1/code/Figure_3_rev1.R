# Clear workspace
rm(list = ls())
gc()

wd <- "C:/"
setwd(wd)



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


# Colors 
cols <- c(
  "published" = "#00a7c7",
  "DOIs" = "#fe5e31",
  "downloads" = "gray",
  "reuse" = "#FBE362"
)


# Read and summarize data ---------------------------------------------------------------
dat<-read.table("repo_statistics_rev1.txt", header = T, sep = "\t", stringsAsFactors = T )
str(dat)
summary(dat)


# Transform data as required for plotting ---------------------------------
# Year and type as factor
dat$type<-factor(dat$type, levels = c("published","DOIs","downloads","reuse"))
dat$year.fact<-factor(as.factor(dat$year), levels = c("before 2018","2018",
                                                  "2019","2020","2021",
                                                  "2022","2023","2024","2025"))

# Add cumulative numbers
dat2 <- dat %>%
  group_by(type) %>%
  mutate(cumulative_sum = cumsum(number))

# Overwrite old data
dat<-as.data.frame(dat2)

# Remove zeros for log 10 plotting
# Replaced with 1, no visual difference in plot
dat$number <- ifelse(dat$number==0,1,dat$number)
dat$cumulative_sum <- ifelse(dat$cumulative_sum==0,1,dat$cumulative_sum)

# Create filtered datasets for lines 
dat_lines_early <- dat[dat$type %in% c("DOIs", "reuse"), ]
dat_lines_late <- dat[dat$type %in% c("published", "downloads") & dat$year.fact != "before 2018", ]



# Plot Figure 3 -----------------------------------------------------------
ggplot(dat, aes(fill=type, y=number, x=year.fact)) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_manual(values=cols, name="", 
                    labels = c("Published datasets","DOIs assigned","Downloads", "Data reuse")) +
  scale_x_discrete(labels=c("before 2018" ,"2018","2019","2020","2021","2022","2023","2024","2025")) + 
  scale_y_continuous(
    trans = "log10",
    breaks = c(1, 5, 10, 50, 100, 500, 1000, 5000))+
  ylab(expression(paste("Number (log"[10], " scale)")))+
  theme_minimal() + 
  theme(
    axis.text.y = element_text(size = 13),
    axis.text.x = element_text(size = 13),
    axis.title.y = element_text(size = 14),
    legend.text = element_text(size = 12),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    plot.margin = margin(20, 3, 20, 3),
    axis.line.x = element_line(color = "grey92", size = 0.5),
    legend.position = "bottom",
    axis.title.x = element_blank()
  ) +
  geom_line(data = dat_lines_early, 
            aes(group = type, color = type, y = cumulative_sum, x = year.fact),
            position = position_dodge(width = 0.9),
            linewidth = 1) +
  geom_line(data = dat_lines_late, 
            aes(group = type, color = type, y = cumulative_sum, x = year.fact),
            position = position_dodge(width = 0.9),
            linewidth = 1) +
  scale_color_manual(values = cols, guide = FALSE)


ggsave("Figure_3.png", 
       width = 8,      # width in inches
       height = 10,     # height in inches
       bg = "white",
       dpi = 300)  




