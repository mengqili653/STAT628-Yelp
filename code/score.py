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

from pandas.core.frame import DataFrame
def show_words(classifier,outcome,current_id):
        # Determine the most relevant features, and display them.
    cpdist = classifier._feature_probdist
    a=[]
    b=[]
    c=[]
    d=[]
    for (fname, fval) in outcome:

        def labelprob(l):
            return cpdist[l, fname].prob(fval)

        labels = sorted(
            [l for l in classifier._labels if fval in cpdist[l, fname].samples()],
            key=lambda element: (-labelprob(element), element),
            reverse=True
        )
        if len(labels) == 1:
            continue
        l0 = labels[0]
        l1 = labels[-1]
        if cpdist[l0, fname].prob(fval) == 0:
            ratio = "INF"
        else:
            ratio = "%8.1f" % (
                cpdist[l1, fname].prob(fval) / cpdist[l0, fname].prob(fval)
            )
        a.append(current_id)
        b.append(fname)
        c.append([l1,l0])
        d.append(ratio)
    e={"id": a,
       "word": b,
       "pos/neg": c,
       "ratio": d}
    data=DataFrame(e)
    return(data)

def words_score(current_doc,current_id):
    pos_t=current_doc.text[current_doc['p_n']=="positive"]
    neg_t=current_doc.text[current_doc['p_n']=="negative"]
    labeled=([(features(text),'pos') for text in pos_t]+[(features(text),'neg') for text in neg_t])
    classifier = nltk.NaiveBayesClassifier.train(labeled)
    outcome=classifier.most_informative_features(500)
    id_words=show_words(classifier,outcome,current_id)
    return(id_words)

words = pd.DataFrame()
for name in names:
    current_id=name
    current_doc=new_document[new_document['business_id']==current_id]
    words=words.append(words_score(current_doc,current_id))
words.to_csv("words_score.csv",index=False,header=True)   
 
