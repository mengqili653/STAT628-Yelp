data<-read.csv("words_score.csv")
score=c(NULL)
for (i in 1:length(data$ratio)){
  if (is.na(data$ratio[i])==T){ 
    data$ratio[i]=1
    }
  if (data$ratio[i] > 10){
    temp=10
    } else{
    temp=data$ratio[i]
    }
  if (data$pos.neg[i] == "['neg', 'pos']"){
    t_score=5-5*log10(temp)
    } else{
    t_score=5+5*log10(temp)
    }
  score=c(score,t_score)
    
}
data$score<-score
write.csv(data,"data_with_score.csv")