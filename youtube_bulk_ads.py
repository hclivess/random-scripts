import datetime

length_h = 12
length_m = length_h * 60
minutes_ads = 5
calc = length_m / minutes_ads
print "will insert: " +str(calc)

s = datetime.timedelta(seconds=0)
#print s
i = 0
timelist = []

while i < calc:
    s = s + datetime.timedelta(minutes=minutes_ads)
    #print s
    timelist.append(str(s))
    i = i + 1
    
#print timelist

readable = ","
for x in timelist:
    readable=readable+x+","

readable = readable.replace(",0:",",")
print readable
