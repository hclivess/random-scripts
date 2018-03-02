from threading import Thread
import threading
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
import urllib2
import logging
from logging.handlers import RotatingFileHandler
import sys
global thread_count
max_threads = 300

if not os.path.exists("temp"):
    os.makedirs("temp")

f = open('list.plist', 'r')
libraries = re.findall("(https\:\/\/.*)\<", f.read())
libraries = list(set(libraries))
#print libraries

#logging
log_formatter = logging.Formatter('%(asctime)s %(levelname)s %(funcName)s(%(lineno)d) %(message)s')
logFile = 'fmd.log'
my_handler = RotatingFileHandler(logFile, mode='a', maxBytes=5*1024*1024, backupCount=2, encoding=None, delay=0)
my_handler.setFormatter(log_formatter)
my_handler.setLevel(logging.INFO)
app_log = logging.getLogger('root')
app_log.setLevel(logging.INFO)
app_log.addHandler(my_handler)
ch = logging.StreamHandler(sys.stdout)
ch.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(asctime)s %(funcName)s(%(lineno)d) %(message)s')
ch.setFormatter(formatter)
app_log.addHandler(ch)
#logging
def remove_non_ascii(text):
    return ''.join(i for i in text if ord(i)<128)

def download_file(url,title,ext,i,album):
 
        try:
            title=remove_non_ascii(title)
            print(str(album+"\\"+title+ext))
            if not os.path.isfile(album+"\\"+title+ext):
                # NOTE the stream=True parameter
                r = requests.get(url, stream=True, headers=hdr)

                if os.path.isfile("temp\\"+album+"\\"+title+ext):
                    os.remove("temp\\"+album+"\\"+title+ext)
                    
                with open("temp\\"+album+"\\"+title+ext, 'wb') as f:
                    for chunk in r.iter_content(chunk_size=1024): 
                        if chunk: # filter out keep-alive new chunks
                            f.write(chunk)                        
                            #f.flush() commented by recommendation from J.F.Sebastian
                if not os.path.exists(album):
                    os.makedirs(album)
                os.rename("temp\\"+album+"\\"+title+ext,album+"\\"+title+ext)
            else:
                print(str(title) + " already downloaded")
                  
        except Exception, e:
            app_log.info(str(e)+" "+str(album)+" "+str(url)+" "+str(title)+" "+str(ext)+" "+str(i))
        
# timeout in seconds
timeout = 6
socket.setdefaulttimeout(timeout)
# timeout in seconds
# set header
hdr = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36',
       'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
       'Accept-Encoding': 'gzip, deflate, sdch',
       'Accept-Language': 'cs,sk;q=0.8,en;q=0.6,en-GB;q=0.4',
       'Connection': 'keep-alive'}
# set header



try:
    for root in libraries:

        passed = 0
        while passed != 1:
            try:
                request = requests.get(root, headers=hdr)
            except:
                pass
            passed = 1

        try:
            geturl_readable = request.text
            links = re.findall("enclosure url=\"(.*)\?", geturl_readable)
            titles = re.findall("\<title\>(.*)\<", geturl_readable)

            exts = re.findall("(\.\w+)\?", geturl_readable)
            album = titles[0].replace("|","_")
            titles.pop(0)


            print album

            if not os.path.exists("temp\\"+album):
                os.makedirs("temp\\"+album)

            print links
            print titles
            print exts

            i=0
            for x in links:
                try:
                    while threading.activeCount() >= max_threads:
                        print "waiting for free threads: " + str(threading.activeCount()) + " / " + str(max_threads)
                        time.sleep(1)

                    t = threading.Thread(target=download_file, args=(x,titles[i].replace(":"," ").replace("/"," ").replace("|"," ").replace("?"," "), exts[i], i, album))
                    t.start()
                    i = i+1
                except Exception, e:
                    app_log.info(str(e))
                    pass
        except Exception, e:
            app_log.info(str(e)+str(links)+str(titles)+str(geturl_readable))
            pass

except:
    pass
