import re
import socket
import requests

###
#Script takes an average of last x volumes on localbitcoins and a percentage of that (starting from today and going to the past) to get a growth factor, adjust percentage to make more precise
###

backwards = 365 #past and future days to base the prediction on
percent = 10 #history percentage to take into consideration as growth factor

# timeout in seconds
timeout = 6
socket.setdefaulttimeout(timeout)
# timeout in seconds

# set header
hdr = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
       'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
       'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
       'Accept-Encoding': 'none',
       'Accept-Language': 'en-US,en;q=0.8',
       'Connection': 'keep-alive'}
# set header

i = 0
while i < backwards:
    request = requests.get("https://coin.dance/charts/ALL", headers=hdr)

    geturl_readable = request.text
    geturl_readable_matches = re.findall('value"\:"(\d+)"', geturl_readable)


    term = geturl_readable_matches [-i:] #number sets age
    avg = 0
    for x in term:
        avg=avg+int(x)
    avg=avg/len(term)

    predict = (int(i)*int(percent))/100
    print "predict:"+str(predict)

    last = (geturl_readable_matches[-int(predict):])
    #x percent average
    avg2 = 0
    for y in last:
        avg2=avg2+int(x)
    avg2=avg2/len(last)

    index = 100 * (int(avg2) - int(avg)) / int(avg)
    #wrong calc

    #x percent average

    print len(term)
    print len(last)

    #price

    request2 = requests.get("http://api.coindesk.com/v1/bpi/currentprice/btc.json", headers=hdr)
    geturl_readable2 = request2.text
    price = re.findall('rate":"(\d+\.\d+)', geturl_readable2)
    print price[0]
    print index
    #price

    if index > 0:
        print "BTC will rise "+str(index)+"% in the following "+str(i)+" days ("+str(i/365)+" year(s)) to $" +str((float(price[0])+(float(price[0])*float(index))/100)) + " from current $" +price[0]
    if index == 0:
        print "There will be no change"
    if index < 0:
        print "Bitcoin price will fall "+str(index)+"% in the following "+str(i)+" days ("+str(i/365)+" year(s)) to $" +str((float(price[0])+(float(price[0])*float(index))/100)) + " from current $" +price[0]


    logger = open("data.txt", 'a')
    logger.write(str((float(price[0])+(float(price[0])*float(index))/100)) +"\n")
    logger.close()
    
    i = i+1
