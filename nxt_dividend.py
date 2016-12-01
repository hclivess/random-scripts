import requests
import re
from datetime import date

today = str(date.today())

# set header
hdr = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
       'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
       'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
       'Accept-Encoding': 'none',
       'Accept-Language': 'en-US,en;q=0.8',
       'Connection': 'keep-alive'}
# set header

request = requests.get("http://nxt.cloudns.pro:7876/nxt?requestType=getAsset&asset=1345126331091090235", headers=hdr)
geturl_readable = request.text
geturl_readable_filter = re.search("\"numberOfAccounts\"\:(\d+)", geturl_readable)
accounts = geturl_readable_filter.group(1)
#print "Dividend distribution fees (holders): "+accounts
print "Fee: 1"

request2 = requests.get("http://nxt.cloudns.pro:7876/nxt?requestType=getAssetAccounts&asset=1345126331091090235", headers=hdr)
geturl_readable2 = request2.text
geturl_readable_filter2 = re.search("\"quantityQNT\"\:\"(\d+)\"", geturl_readable2)
quantity = geturl_readable_filter2.group(1)
print "Shares remaining: "+quantity
distributed = 10000000-int(quantity)
print "Shares distributed: "+str(distributed)

request3 = requests.get("http://nxt.cloudns.pro:7876/nxt?requestType=getTrades&asset=1345126331091090235&lastIndex=0", headers=hdr)
geturl_readable3 = request3.text
geturl_readable_filter3 = re.search("\"priceNQT\"\:\"(\d+)\"", geturl_readable3)
asset_price = (float(geturl_readable_filter3.group(1))/100000000)
print "Share price in NXT: "+str(asset_price)


request4 = requests.get("http://socialblade.com/youtube/user/hcgmg/monthly", headers=hdr)
geturl_readable4 = request4.text
geturl_readable_filter4 = re.search("views\/month\(\$(\d+)", geturl_readable4)
earnings = geturl_readable_filter4.group(1)
"""
earnings_realistic = float(earnings) + float(earnings)/9
print "Rough Estimate of Channel income: "+str(earnings_realistic)
one_percent = float(earnings_realistic)/100
"""

earnings = raw_input("Total channel income: ")
one_percent = float(earnings)/100 #comment this if you uncomment above
print "1% channel income: "+str(one_percent)

request5 = requests.get("https://www.coingecko.com/en/widget_component/ticker/nxt/usd", verify=False, headers=hdr)
geturl_readable5 = request5.text
geturl_readable_filter5 = re.search("\$(\d+\.\d+)", geturl_readable5)
nxt_price = geturl_readable_filter5.group(1)
print "NXT price in USD: "+nxt_price

one_percent_nxt = float(one_percent)/float(nxt_price)
print "1% channel income in NXT: "+str(one_percent_nxt)

one_percent_nxt_netto = float(one_percent_nxt)-1#-float(accounts) #choose between -1 and -float(accounts)
print "1% channel income in NXT minus fees: "+str(one_percent_nxt_netto)

dividend = float(one_percent_nxt_netto)/float(distributed)
print "Dividend per share in NXT: "+str(dividend)

roi = float(asset_price)/float(dividend)
print "100% ROI in months: "+str(roi)

logger = open("dividends.txt", 'w')
#logger.write("Dividend distribution fees (holders): "+accounts+"\n")
logger.write("Fee: 1\n")
logger.write("Shares remaining: "+quantity+"\n")
logger.write("Shares distributed: "+str(distributed)+"\n")
logger.write("Share price in NXT: "+str(asset_price)+"\n")
logger.write("Rough Estimate of Channel income: "+str(earnings)+"\n")#changed from earnings_realistic
logger.write("1% channel income: "+str(one_percent)+"\n")
logger.write("NXT price in USD: "+nxt_price+"\n")
logger.write("1% channel income in NXT: "+str(one_percent_nxt)+"\n")
logger.write("1% channel income in NXT minus fees: "+str(one_percent_nxt_netto)+"\n")
logger.write("Dividend per share in NXT: "+str(dividend)+"\n")
logger.write("100% ROI in months at current price an no growth: "+str(roi))
logger.close()
