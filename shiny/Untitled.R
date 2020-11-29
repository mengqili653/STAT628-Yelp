data = read.csv("../Data/word_cloud.csv",header = T, sep = ",", row.names = 1)
names = data['name']
text = data[data["name"] == "Sweet Freeze"][2]
text
