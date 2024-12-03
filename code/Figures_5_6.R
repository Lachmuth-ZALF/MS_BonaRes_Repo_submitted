# Clear workspace
rm(list = ls())
gc()


# Load packages -----------------------------------------------------------
# Install packages from GitHub (remove #s if you need this section)
#install.packages("remotes")
#library(remotes)
#install_github("elizagrames/litsearchr", ref="main")
library(litsearchr)
library(bibliometrix)  
library(bibliometrixData)
library(dplyr)
library(ggplot2)
library(ggraph)


# Settings ----------------------------------------------------------------
### Set working directory
wd <- "C:/"
setwd(wd)


# Package litsearchr ----------------------------------------------------------------
## Import WoS records ------------------------------------------------------------
naive_import<-
  litsearchr::import_results(
    file = "savedrecs.bib",
    verbose = TRUE
  )

## Define stopwords --------------------------------------------------------
stopwords_SL <-c("assess", "assessed", "assesses", "assessing",  "based", #,"assessment", "assessments"
                 "follow", "followed", "following", "follows", "primary", "versus", "that is", "e.g.", 
                 "however", "in particular", "versus", "follow", "followed", "following", "follows", "potential", "study")

all_stopwords <- c(get_stopwords("English"), stopwords_SL)


## Extract author keywords -------------------------------------------------
real_keywords<-extract_terms(keywords=naive_import[, "keywords"], method="tagged", min_n=1,max_n=3, min_freq=2)


## Extract  keywords from abstracts and titles -----------------------------------------------------
titles_abstracts <- paste(naive_import$abstract,naive_import$title,  collapse = "; ")

### Extract terms using "fakerake" method -----------------------------------
raked_keywords <- 
  extract_terms(
    text = naive_import[, c("title","abstract")], 
    method = "fakerake",
    min_freq = 2, 
    ngrams = TRUE,
    min_n = 2,
    max_n = 3,
    stopwords = all_stopwords, 
    language = "English"
  )
 
raked_keywords

### Concatenate (all) real keywords and raked keywords
all_keywords <- unique(append(real_keywords, raked_keywords))



# Network analysis --------------------------------------------------------
dfm<-
  create_dfm(elements = paste(naive_import[, "title"], naive_import[, "abstract"]), #
             features = unique(all_keywords))#[-81]



## Summarize keywords with similar meaning ---------------------------------
# (I am sure there is a more elegant way of doing this)
df <- as.data.frame(dfm)

# Reformat column names to able to address columns by name
colnames(df)[26]<-"Alley-cropping agroforestry"# required for next line to work
df<-df %>% dplyr::rename_all(make.names)

### LTE
df <- mutate(df, long.term.experiments.new = 
                    sum(long.term.experiments, long.term.field, 
                        long.term.field.experiments,long.term.field.experiment,
                        agricultural.long.term,agricultural.long.term.field)) 
# Rename and make binary
df$LTE<-ifelse(df$long.term.experiments.new==0,0,1)

df<-select(df,-c(long.term.experiments, long.term.field, 
                           long.term.field.experiments,long.term.field.experiment,
                           agricultural.long.term,agricultural.long.term.field,long.term.experiments.new))


###"agricultural experimental", "agricultural experimental field"
df <- mutate(df, agricultural.exp = 
                    sum(agricultural.experimental, agricultural.experimental.field)) 
# Rename and make binary
df$agricultural.experimental.field<-ifelse(df$agricultural.exp==0,0,1)

df<-select(df,-c(agricultural.exp, agricultural.experimental))

###"agricultural landscape", "agricultural landscapes"        
df <- mutate(df, agricultural.land = 
                    sum(agricultural.landscape, agricultural.landscapes)) 
# Rename and make binary
df$agricultural.landscape<-ifelse(df$agricultural.land==0,0,1)

df<-select(df,-c(agricultural.land, agricultural.landscapes))

### "alley-cropping agroforestry", "alley cropping", "alley cropping agroforestry"    
df <- mutate(df, alley = 
                    sum(Alley.cropping.agroforestry, alley.cropping, alley.cropping.agroforestry   
                    )) 
# Rename and make binary
df$alley.cropping.agroforestry<-ifelse(df$alley==0,0,1)

df<-select(df,-c(alley, Alley.cropping.agroforestry, alley.cropping, alley.cropping.agroforestry))


### "bayesian sequential", "bayesian sequential updating"     
df <- mutate(df, bayes = 
                    sum(bayesian.sequential, bayesian.sequential.updating)) 
# Rename and make binary
df$bayesian.sequential.updating<-ifelse(df$bayes==0,0,1)

df<-select(df,-c(bayes, bayesian.sequential))


###"change impacts", "climate change impacts"          
df <- mutate(df, CCimp = 
                    sum(change.impacts, climate.change.impacts)) 
# Rename and make binary
df$climate.change.impacts<-ifelse(df$CCimp==0,0,1)

df<-select(df,-c(CCimp, change.impacts))


### "experimental field", "experimental field plots"                 
df <- mutate(df, expField = 
                    sum(experimental.field, experimental.field.plots)) 
# Rename and make binary
df$experimental.field.plots<-ifelse(df$expField==0,0,1)

df<-select(df,-c(expField, experimental.field))


### "language processing", "natural language", "natural language processing"                
df <- mutate(df, langProc = 
                    sum(language.processing, natural.language, natural.language.processing)) 
# Rename and make binary
df$natural.language.processing<-ifelse(df$langProc==0,0,1)

df<-select(df,-c(langProc, language.processing, natural.language))


### "multivariate water", "multivariate water quality"                   
df <- mutate(df, watQ = 
                    sum(multivariate.water, multivariate.water.quality, water.quality)) 
# Rename and make binary
df$water.quality<-ifelse(df$watQ==0,0,1)

df<-select(df,-c(watQ, multivariate.water, multivariate.water.quality))


### organic carbon", "organic carbon stocks"           
df <- mutate(df, orgC = 
                    sum(organic.carbon, organic.carbon.stocks)) 
# Rename and make binary
df$organic.carbon<-ifelse(df$orgC==0,0,1)

df<-select(df,-c(orgC, organic.carbon.stocks))


### "precision weighing", "precision weighing lysimeters"            
df <- mutate(df, precWeigh = 
                    sum(precision.weighing, precision.weighing.lysimeters)) 
# Rename and make binary
df$precision.weighing<-ifelse(df$precWeigh==0,0,1)

df<-select(df,-c(precWeigh, precision.weighing.lysimeters))

dfm_new <- as.matrix(df)


## Network graph (Figure 6) -----------------------------------------------------------
# Important terms are in the edge of the graph
graph<-
  create_network(search_dfm = dfm_new,
                 min_studies = 2,
                 min_occ = 2)


network_graph<-ggraph(graph, layout="stress") +
  coord_fixed() +
  expand_limits(x=c(-3.5, 4.5), y=c(-2, 2)) +
  geom_edge_link(aes(alpha=weight)) +
  geom_node_point(shape="circle filled", fill="white") +
  geom_node_text(aes(label=name), hjust="outward", check_overlap=F, size = 3.5) +
  guides(edge_alpha=FALSE)
network_graph
ggsave(plot = network_graph,paste0(wd,"network_graph.png"), width = 20, height = 12,units ="cm")



# Package bibliometrix ------------------------------------------------------------
## Import WoS records ------------------------------------------------------------
M <- convert2df(
  file = "savedrecs.bib", 
  dbsource = "isi",
  format = "bibtex",
  remove.duplicates = TRUE
)


# Sankey Plot (Figure 5) -------------------------------------------------------------
threeFieldsPlot(M, fields = c("AU_CO","SC", "ID"), n = c(25, 25, 25))


