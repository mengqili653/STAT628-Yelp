baodata = read.csv("word_cloud.csv",header = T, sep = ",", row.names = 1)
names = as.vector(data$name, mode = 'character')
mylist = as.list(data$name)
names(mylist) = data$name
options(shiny.sanitize.errors = TRUE)

sentiment = read.csv("sentiment.csv",header = T, sep = ",", row.names = 1)

options(shiny.sanitize.errors = TRUE)
library(memoise)


getTermMatrix <- memoise(function(selection) {
  
  text = data[data["name"] == selection][2]
  
  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but"))
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})
