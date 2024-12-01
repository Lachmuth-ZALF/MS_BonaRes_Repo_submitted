# Clear workspace
rm(list = ls())
gc()

# Load packages -----------------------------------------------------------
library(ggplot2)


# Read and summarize data ---------------------------------------------------------------
dat<-read.table("~/reuse_type.txt",
                header = T, sep = "\t", stringsAsFactors = T )
str(dat)
summary(dat)
# Reorder by Sum value
dat <- dat[order(dat$Sum, decreasing = TRUE), ]


# Barplot  --------------------------------------------
ggplot(dat, aes(x = reorder(Reuse_purpose, Sum), y = Sum)) +
  geom_bar(stat = "identity", fill = "#00a7c7") +
  coord_flip() +  # Flip coordinates for horizontal bars
  theme_minimal() +
  labs(
    title = "Reuse type",
    x = "",
    y = "Count"
  ) +
  theme(
    axis.text.y = element_text(size = 10),
    plot.title = element_text(hjust = 0.5)
  )


# prep --------------------------------------------------------------------

# Create data frame
data <- data.frame(
  Reuse_purpose = c("Crop modeling", "Agro-ecosystem modeling", "Scenario development or application",
                    "Model calibration", "Model evaluation", "Citation of data or results",
                    "Study site metadata or covariates", "Metadata extraction or processing",
                    "Method development or evaluation", "Metadata analysis",
                    "Re-analysis with new objectives", "Meta(data) collection"),
  Sum = c(12, 4, 10, 19, 10, 5, 19, 10, 30, 11, 42, 7)
)

write.table(data, "C:/Users/Lachmuth/OneDrive - Leibniz-Zentrum für Agrarlandschaftsforschung (ZALF) e.V/Dokumente/BONARES_Repository/paper/reuse_type.txt", sep = "\t", row.names = F, quote = F)

