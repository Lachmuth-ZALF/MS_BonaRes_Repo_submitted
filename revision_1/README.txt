README

Open code and data for „Facilitating Effective Reuse of Soil Research Data: The BonaRes Repository” (Lachmuth et al., resubmitted)

Description of the published files:

1) Text files
File repo_statistics.txt
- type: published, datasets published; downloads, datasets downloaded; DOIs, Digital Object Identifiers (DOIs) assigned; 
	reuse, publications reusing datasets 
- year: year (CE)
- number: count

File repo_statistics.txt
- Reuse_purpose: data reuse purposes encountered in the literature review 
- Sum: Count of publications reusing data for the listed purpose

File savedrecs.bib
Full Web of Science (WoS) BibTex records for a subset of 46 publications reusing data from the BonaRes Repository that are listed in WoS  


2) R scripts used in R version 4.4.1, R Core Team 2024
For R packages used see scripts.

R-Script Figure_3:
Script reads repo_statistics.txt and creates the Barplot shown in Figure 3 of the manuscript:
Publication statistics of the BonaRes Repository as of March 13, 2025. The figure shows the number of datasets published, 
Digital Object Identifiers (DOIs) assigned, datasets downloaded, and publications reusing datasets since the repository's inception. 
Bars show individual counts per year while lines indicate cumulative numbers.

R-Script Figure_4:
Script reads reuse_type.txt and creates the Barplot shown in Figure 4 of the manuscript:
Bar plot of data reuse type as recorded in Table S1. More than one reuse type is possible for each reuse of a dataset. 
If a publication reused more than one dataset, each data set has been considered separately.

R-Script Figure_5_6:
Script reads savedrecs.bib and creates first the network graph shown in Figure 6 and then the Sankey diagram shown in Figure 5 of the manuscript:
Figure 5: Three-Field Sankey Diagram created using the R package bibliometrix, illustrating the connections between Author Country (all authors, AU), 
Web of Science Subject Category (SC), and Web of Science Keywords (ID). This visualization includes 44 of the 62 papers that reused data from the BonaRes Repository, 
specifically those listed in ISI Web of Science (WoS) with associated WoS keywords
Figure 6: : Network graph of keyword analysis, combining author-provided and RAKE-extracted keywords (generated using the R package litsearchr). 
This visualization includes 46 of the 62 papers that reused data from the BonaRes Repository, specifically those listed in ISI Web of Science. 
Closely related, i.e., co-occuring terms representing key topics are positioned near each other and are connected by darker lines, while peripheral terms, 
connecting with faint lines, indicate less related concepts.



References:
R Core Team (2024) R: A Language and Environment for Statistical Computing. https://www.R-project.org/.