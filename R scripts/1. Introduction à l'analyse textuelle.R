# install.packages("quanteda")
# install.packages("quanteda.textmodels")
# install.packages("quanteda.textstats")
# install.packages("quanteda.textplots")
# install.packages("readtext")
# install.packages("devtools") # get devtools to install quanteda.corpora
# devtools::install_github("quanteda/quanteda.corpora")
# install.packages("spacyr")
# install.packages("newsmap")
# install.packages("seededlda")
# install.packages("newsmap")
# install.packages("readxl")
# install.packages("writexl")

library(quanteda)
library(quanteda.textmodels)
library(quanteda.textstats)
library(quanteda.textplots)
library(readtext)
library(devtools)
library(quanteda.corpora)
library(spacyr)
library(newsmap)
library(seededlda)
library(newsmap)
library(readxl)
library(writexl)

# calculs / calculations
2 + 2

# attribuer une valeur à un objet / assign a value to an object
a <- 1

# imprimer l'objet / print object
a

b <- 2

a + b

# vérifier la classe de l'objet / check object class
class(a)

# objets textuels / character
mot <- "Bonjour :)"

# imprimer l'objet / print object
mot

# vérifier la classe de l'objet / check object class
class(mot)

# vecteur numérique / digital vector
vec_num <- c(1, 5, 6, 3)

# imprimer l'objet / print object
vec_num

# vecteur textuel / text vector
vec_char <- c("pomme", "banane", "mandarine", "melon")

# sélectionner des éléments / select items
vec_char[3]
vec_char[2:4]

# obtenir la longueur d'un vecteur / get the length of a vector
length(vec_num)

# importer un document ou un corpus (journal des débats de l'Assemblée nationale 15 septembre 2021) /
# import a document or corpus (journal of debates of the National Assembly September 15, 2021)
journal_debats <- readtext("Corpus/Exemple_journal_debats.txt", encoding = "UTF-8") %>% corpus()

# la fonction file.choose() permet d'obtenir le chemin vers un fichier sur votre disque /
# the file.choose() function allows you to get the path to a file on your disk

# pour obtenir le nombre de documents dans notre corpus
# to get the number of documents in our corpus
ndoc(journal_debats)

# premier niveau / first level
journal_debats[1]

# deuxième niveau / second level
journal_debats[[1]]

# corpus_reshape() permet de changer l'unité des textes entre les documents, les paragraphes et les phrases
# corpus_reshape() allows you to change the text unit between documents, paragraphs and sentences
journal_debats_phrases <- corpus_reshape(journal_debats, to = "sentences")
ndoc(journal_debats_phrases)
journal_debats_phrases[[2]]

# tokens() segmente les textes d'un corpus / tokens() segments the texts of a corpus
journal_debats_toks <- tokens(journal_debats)
journal_debats_toks[1]

# chercher un mot et lire les passages où il apparaît / search for a word and read the sentence where it appears
kwic(journal_debats_toks, pattern =  "duplessis", window = 10)[1]
kwic(journal_debats_toks, pattern =  "woke", window = 8)[1]

# trouver des expressions composées de plusieurs mots / find expressions made up of several words
kwic(journal_debats_toks, pattern = phrase("Québec solidaire")) %>% head()

# segmenter et retirer la ponctuation / segment and remove punctuation
toks_nopunct <- tokens(journal_debats_toks, remove_punct = TRUE)
toks_nopunct[1]

# retirer les stopwords (vecteur de mots qui ne sont pas d'intérêt)
# remove stopwords (vector of words that are not of interest)
stopwords("fr")
toks_nostop <- tokens_remove(toks_nopunct, pattern = stopwords("fr"))
toks_nostop[1]

# créer son propre dictionnaire / create your own dictionary
dict <- dictionary(list(pandémie = c("virus", "contagion", "covid", "confinement"),
                        économie = c("PIB", "emploi", "croissance économique")))

# premiers mots-clés identifiés par le dictionnaire, présentés dans leur contexte
# first keywords identified by the dictionary, presented in context
kwic(toks_nostop, dict, window = 5) %>% head()

kwic(toks_nostop, dict["pandémie"], window = 3) %>% head()

# getwd() renvoie un chemin sur votre ordinateur qui correspond à l'espace de travail actuel /
# getwd() returns an absolute filepath representing the current working directory of the R process
getwd()

# setwd() est utilisé pour définir l'espace de travail
# Placer le curseur après setwd("/ et appuyer sur la touche de tabulation (Tab) pour définir un chemin.

# setwd() is used to set the working directory
# Place the cursor after setwd("/ and press Tab to set a path.
# setwd("/")

# utiliser un dictionnaire préexistant (source: https://www.poltext.org/fr/donnees-et-analyses/lexicoder)
dict <- dictionary(file = "Dictionnaire/frlsd.cat")

# obtenir le nombre de catégories comprises dans le dictionnaire
length(dict)

# obtenir le nom des catégories
names(dict)

# voir les premiers mots positifs du corpus
kwic(toks_nostop, dict["POSITIVE"]) %>% head()

# construire un DFM (document-feature matrix)
dfmat_journal_debats <- dfm(toks_nostop)
dfmat_journal_debats

# les mots les plus utilisés peuvent être trouvées en utilisant topfeatures()
topfeatures(dfmat_journal_debats, 10)

# Comment produire des résultats préliminaires en créant un dataframe
data <- toks_nostop

# Définir categories
categories <- names(dict)

# Créer dataframe
df <- data.frame(categories = categories)
df$categories <- as.character(df$categories)
df

# Compter nombre de termes par categories
df$nbr <- NA
for (i in 1:length(df$categories)) {
  df$nbr[i] <- nrow(kwic(data, dict[df$categories[i]])[,1])
}
df

# Calculer pourcentage
df$pourcentage <- round(df$nbr/sum(df$nbr)*100, 2)
df

# Calculer total
df$categories <- as.character(df$categories)
total <- c("Total", sum(df$nbr), NA, NA)
df <- rbind(df, total)
df

# Exporter en fichier excel
write_xlsx(df, "Résultats/Résultats.xlsx")
