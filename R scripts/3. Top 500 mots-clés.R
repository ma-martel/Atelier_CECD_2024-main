# charger les packages
library(readtext)
library(quanteda)
library(quanteda.textstats)
library(quanteda.corpora)
library(writexl)
library(tidyverse)

# importer le corpus structuré et diviser en tokens
data <- readxl::read_xlsx("Corpus/Corpus structuré.xlsx") %>% 
  corpus() %>% 
  tokens()

# créer un vecteur de mots à retirer
vecteur <- c(stopwords("fr"),"a", "presse", "+", "lois", "conventions")

# transformer le corpus en dfm et retirer les stopwords
data_dfm <- tokens(data, 
                   remove_numbers = TRUE, 
                   remove_punct = TRUE) %>%
  tokens_remove(vecteur) %>%
  dfm()

# 500 mots les plus fréquents
topfeatures(data_dfm, 500) %>% head()

# convertir en df
results <- dfm_sort(data_dfm) %>% convert(to = "data.frame")

# sélectionner les 500 mots les plus fréquents
top_500 <- results[2:501]

# additionner les lignes de chaque colonne pour obtenir le nombre total d'occurrences de chaque mot
top_500 <- colSums(top_500)

# transformer en df
top_500 <- as.data.frame(top_500)

# ajouter une colonne avec mots
top_500$mot <- rownames(top_500)

# déplacez la colonne 'mot' en première position
top_500 <- top_500[, c(ncol(top_500), 1:(ncol(top_500)-1))]

# supprimer les noms de lignes
rownames(top_500) <- NULL

# exporter en Excel
write_xlsx(top_500, "Résultats/Top 500 mots-clés.xlsx")


# syntagmes (groupes de mots) #

# importer le corpus
corp_news <- readxl::read_xlsx("Corpus/Corpus structuré.xlsx") %>% 
  corpus() %>% 
  tokens()

corp_news

# We remove punctuation marks and symbols in tokens() and stopwords in tokens_remove() with padding = TRUE to keep the original positions of tokens.
toks_news <- tokens(corp_news, remove_punct = TRUE, remove_symbols = TRUE, padding = TRUE) %>% 
  tokens_remove(stopwords("fr"), padding = TRUE)

tstat_col_cap <- textstat_collocations(toks_news, min_count = 5, tolower = T)

# exporter les données
write_xlsx(tstat_col_cap, "Résultats/Top synagmes.xlsx")
