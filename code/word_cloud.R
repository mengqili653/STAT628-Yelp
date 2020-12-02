library(tm)
library(wordcloud2)
library(tidyverse)
library(dplyr)

word = read.csv("../Data/dessert_clean.csv",header = T, sep = ",", row.names = 1)
pos = word %>% filter(stars_x >= 4) %>% select(text)
text = paste(unlist(pos), collapse = " ")
myCorpus = Corpus(VectorSource(text))
myCorpus = tm_map(myCorpus, content_transformer(tolower))
myCorpus = tm_map(myCorpus, removePunctuation)
myCorpus = tm_map(myCorpus, removeNumbers)
#myCorpus = tm_map(myCorpus, removeWords, c('good'))
#myCorpus = tm_map(myCorpus, removeWords,
#                  c( "thy", "thou", "thee", "the", "and", "but"))
DTM <- TermDocumentMatrix(myCorpus)
mat <- as.matrix(DTM)
f <- sort(rowSums(mat),decreasing=TRUE)
dat <- data.frame(word = names(f),freq=f)
dat = dat[order(dat$freq, decreasing = TRUE)]
dat = dat[1:150,]

wordcloud2(dat, color = "random-light", backgroundColor = "white")
