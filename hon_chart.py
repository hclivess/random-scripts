import re
#import matplotlib.pyplot
#from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import zipfile
import os
import urllib
import urllib2
data_dir = os.getcwd()+'\\data\\'


while True:

#figsize = 10, 10
plt.figure#(figsize=figsize) #create the graph


while True:
try:
replay_id = raw_input('Enter Match ID: ') 
response = urllib2.urlopen('http://www.honrec.com/match/'+replay_id+'/0000000')
break
except Exception,e:
print 'invalid or unindexed match ID, please re-enter or go index it on honrec.com'
continue

while True:
user_input = raw_input('Data Filter ("gold","gold lost","exp"): ')
if user_input == 'exp':
filter_seek = 'experience'
filter_y = 'EXP_EARNED'
break

elif user_input == 'gold':
filter_seek = 'gold'
filter_y = 'GOLD_EARNED'
break

elif user_input == 'gold lost':
filter_seek = 'gold'
filter_y = 'GOLD_LOST'
break


#elif user_input == 'kill':
# filter_seek = None
# filter_y = 'KILL'
# break 

else:
print 'Invalid filter'
continue







##DOWNLOAD##
response = urllib2.urlopen('http://www.honrec.com/match/'+replay_id+'/0000000')
html = response.read()
#onclick="download_replay('EUjjCa186/saves/replays/20121102/M104112519.honreplay')">Download Replay<
#print html


#data = re.search('(?<=download_replay\(\').*(?=\'\)\"\>Download Replay)', html)


data = re.search('(?<=download_replay\(\').*(?=\.honreplay\'\)\"\>Download Replay)', html)
#print data.group(0)


download = 'http://replaydl.heroesofnewerth.com/'+data.group(0)+'.zip'
#print download
#response2 = urllib2.urlopen (download)




try:
code = urllib2.urlopen(download)
except Exception,e:
print "The replay is too old or invalid, log not found."
else:
if not os.path.exists(data_dir):
os.makedirs(data_dir)
urllib.urlretrieve(download,data_dir+replay_id+'.z ip')

dest_dir = data_dir
zip_location = data_dir+replay_id+'.zip'
fzip = zipfile.ZipFile(zip_location, 'r')
members = [os.path.join(dest_dir, p) for p in fzip.namelist()]
fzip.extractall(path=dest_dir)
fzip.close()


##DOWNLOAD##






x_series = list()
y_series = list()




with open(data_dir+'m'+replay_id+'.log', 'r') as f:
read_data = f.read().decode(encoding='UTF-16',errors='ignore')
f.closed
match_id = re.search('(?<=TMM Match\s\#)\d*', read_data)
#print 'Match id: '+str(match_id.group(0))


entities = re.findall('player:\d name:".*"', read_data) #list all lines containing uniquely any player number and any player name
#print entities
for i in range(len(entities)):
#print i
c = str(entities[i])
f = open(data_dir+replay_id+'_'+str(i)+'.txt', 'w') #open log
#print c
f.write (str(c+'\n')) #write log
entity = str(re.findall('player:\d', entities[i])).strip('[u]\'') #strip list garbage #from every line containing uniquely any player number and any player name save the player name and the number
#print 'entity: '+str(entity)

#function gold per time
player = re.findall('\n.*'+entity+'.*\r\n', read_data) #from every line select the ones with unique player name and player number
#print player
#print 'player count: '+str(len(player))


add_gold = 0
gold = 0
for i in range(len(player)):
gold_earned = re.findall('(?<=\n)'+filter_y+'.*(?=\r\n)', player[i])#.strip('\n[u]\'') #still working with iteration + converting to str

time = re.findall('(?<=time:)\d*', str(gold_earned)) #find time


if filter_seek == None:
gold = [1 for x in list(time)] # in case there is no y value, the value is 1 per unit in time
else:
gold = re.findall('(?<='+filter_seek+':)\d*', str(gold_earned)) #find filter_y


gold = re.sub(r'[^\w]', ' ', str(gold))
gold = re.sub(r'(\s\s)*', '', str(gold))
time = re.sub(r'[^\w]', ' ', str(time))
time = re.sub(r'(\s\s)*', '', str(time))


if not (re.match(r'(^\s*$)', gold)):
add_gold = add_gold+int(gold)


y_series.append(add_gold) #graph


if not (re.match(r'(^\s*$)', gold)):
time = time




# gold_lost = re.findall('(?<=\n)GOLD_LOST.*(?=\r\n)', player[i])
# gold_lost_amount = re.findall('(?<=gold:)\d*', str(gold_lost))
# if not (re.match(r'(^\s*$)', gold_lost_amount)):
# substract_gold = substract_gold-int(gold_lost_amount)




x_series.append(int(time)/1000) #graph

output = (str(add_gold)+' '+str(time)) 
#print output
f.write (output+'\n') #write log


#plot data
#plt.axis('tight') #show all data
#plt.axis('image')
plt.plot(x_series, y_series, label=c, linewidth=2.0)
plt.rcParams.update({'legend.labelspacing':0.25})
y_series = list() #empty the list for another round
x_series = list() #empty the list for another round

#add_gold in labels and title 
plt.xlabel("Time (seconds)")
plt.ylabel(user_input)
plt.title("Match ID: "+str(match_id.group(0)))

#add limits to the x and y axis
#plt.xlim(0, 6)
#plt.ylim(-5, 80)

#create legend
plt.legend(loc="upper left")

#save figure to png
plt.savefig(data_dir+replay_id+".png")


plt.show()
f.close()


#raise SystemExit
