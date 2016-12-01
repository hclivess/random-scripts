from threading import Thread
import threading
lock = threading.Lock()
import glob
import os.path
import cookielib
import re
import time
import datetime
from datetime import date
import socket
import requests
global run_length
global i_controller
global matches_id_controller
import urllib


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

month = raw_input('month --> ') #"07"
year = raw_input('year --> ') #"2014"
#min 06/2009

#if month = "00":
#    month = "12"
#    year = str(year - 1)

request = requests.get("https://commons.wikimedia.org/wiki/Template:Motd/"+str(year)+"-"+str(month)+"", headers=hdr)
print request

geturl_readable = request.text
geturl_readable_matches = re.findall("(https:\/\/upload.wikimedia.org\/wikipedia\/commons\/[\%\/\.\d\w\-]+)", geturl_readable)

#print list(set(geturl_readable_matches))
#print len(list(set(geturl_readable_matches)))

filtered = []
for item in geturl_readable_matches:
    if "transcoded" not in item and ".jpg" not in item and ".gif" not in item and ".png" not in item and ".ogg" not in item:
        #print item
        filtered.append(item)

unique = list(set(filtered))
print len(list(set(filtered)))

for item in unique:
    print "retrieving: "+str(item)
    urllib.urlretrieve(item)
    testfile = urllib.URLopener()
    filename = re.findall (".*\/(.*)",item)
    try:
        testfile.retrieve(item,year+"_"+month+"_"+filename[0])
    except Exception as e:
            print str(e)
            pass
