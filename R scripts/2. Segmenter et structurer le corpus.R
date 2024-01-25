# installer les packages #
# install.packages("readtext")
# install.packages("quanteda")
# install.packages("writexl")
# install.packages("tidyverse")
# install.packages("rvest")
# install.packages("readxl")

# charger les packages
library(readtext)
library(quanteda)
library(writexl)
library(tidyverse)
library(rvest)
library(readxl)

# Importer le corpus
data <- readtext::readtext("Corpus/Corpus à structurer.pdf") %>% corpus()

# Segmenter le corpus
corpus_split <- corpus_segment(
  data,
  pattern = "Certificat émis le 19 décembre 2022 à Université-de-Montréal",
  valuetype = "fixed",
  case_insensitive = TRUE,
  extract_pattern = TRUE,
  pattern_position = "after",
  use_docvars = TRUE
)

corpus_split %>% summary() %>% head()

# Créer dataframe
id <- seq(1:length(corpus_split))
df <- data.frame(doc_id = id)
df$text <- NA
df %>% head()

# Sélection des articles publiés dans les rubriques Actualités et Débats
for (i in 1:length(corpus_split)){
  if (kwic(corpus_split[[i]], pattern = c("actualités_*", "débats_*"), window = 1) %>% nrow() > 0){
    df$doc_id[i] <- paste0("article", i)
    df$text[i] <- corpus_split[[i]]
  }
}

# Retirer les rangées vides (NAs)
df <- na.omit(df)

# Nombre d'articles
df %>% nrow()

# Exporter les données
write_xlsx(df, "Corpus/Corpus structuré.xlsx")
