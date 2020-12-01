data<-read.csv("n_words_score.csv")
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

top20_score=data.frame()
names<-unique(data$id)
for (name in names){
  current_frame=data[data$id==name,]
  current_frame=current_frame[order(current_frame$score),]
  
  if (length(current_frame$score)<20){
    selected_20=current_frame
  } else{
    selected_20=current_frame[c(1:10,(nrow(current_frame)-9):nrow(current_frame)),]
  }
  top20_score<-rbind(top20_score,selected_20)
}


write.csv(top20_score,"n_data_with_score.csv")

