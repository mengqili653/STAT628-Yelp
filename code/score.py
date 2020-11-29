#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov 28 13:38:53 2020

@author: cyc
"""

import pandas as pd
df=pd.read_csv("dessert_clean.csv")
print(df.head(5))
names=df['business_id'].drop_duplicates().values.tolist()
stars=df['stars_x'].tolist()
business_id=df['business_id'].tolist()

import nltk
comment = list(df.text)
import string
remove = str.maketrans('','',string.punctuation)
without_punctuation = [i.translate(remove) for i in comment]
tokenize = [nltk.word_tokenize(i) for i in without_punctuation]
from nltk.corpus import stopwords
stop = set(stopwords.words('english')) 
text = [[i for i in j if i not in stop] for j in tokenize]



#divide all reviews into positive and negative
p_n=[]
i=0
while i < len(stars):
    if stars[i] < 3.5:
        p_n.append('negative')
    else:
        p_n.append('positive')
    i=i+1


from pandas.core.frame import DataFrame
cc={"business_id":business_id,
    "text":text,
    "p_n":p_n
    }
new_document=DataFrame(cc)

def features(words):
    return dict([word,True] for word in words)

def words_score(current_doc,current_id):
    pos_t=current_doc.text[current_doc['p_n']=="positive"]
    neg_t=current_doc.text[current_doc['p_n']=="negative"]
    labeled=([(features(text),'pos') for text in pos_t]+[(features(text),'neg') for text in neg_t])
    classifier = nltk.NaiveBayesClassifier.train(labeled)
    classifier.show_most_informative_features(500)
    outcome=classifier.most_informative_features(500)
    type(outcome)
    i_d=current_id
    f=open(i_d+'.txt','w+')
    f.write(" ".join('%s'%id for id in outcome))
    f.close

for name in names:
    current_id=name
    current_doc=new_document[new_document['business_id']==current_id]
    words_score(current_doc,current_id)
    
# Train a Naive Bayes model and show the most informative features 
