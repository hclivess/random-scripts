from decimal import *
from threading import Lock
import web
import os
import re
#import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime
from pylab import *
#import matplotlib.dates as mdates
#license management
import urllib2

key = open("KEY.xml","r")
lic = urllib2.urlopen("license.xml")
key_read = key.read()
lic_read = lic.read()
matched_key=re.search("PUBLIC\>(.*)\<\/PUBLIC",key_read)
check_key = matched_key.group(1)
try:
    matched_license=re.search("KEY\>("+check_key+")\<\/KEY",lic_read)
    accepted = matched_license.group(1)
except:
    print "License invalid"
else:
    #print lic.read()
    matched_name=re.search("NAME\>(.*)\<\/NAME",lic_read)
    print "License accepted! Welcome, "+matched_name.group(1)+"."
#license management
urls = (
  '/', 'index',
  '/favicon.ico', 'icon'
)
path = 'CATSystem/Cryptsy/GainLogs/' #path
class icon:
    def GET(self):
        raise web.seeother("/static/favicon.ico")
class index:
    def GET(self):
        price = urllib2.urlopen("https://api.coindesk.com/v1/bpi/currentprice.json")
        price_read = price.read()
        matched_price=re.search("(\d{3}.\d{4})",price_read)
        check_price = matched_price.group(1)
        
        y = []
        total_gain = []
        plot_y = []
        plot_x = []
        ping_plot = []
        counted_list = []
        for file in os.listdir(path): #load all gain logs
                document = os.path.join(path, file)
                #print document
                f = open (document)
                for line in f:
                    y.append ([line]) #add every line
                    #out.write (line) #merge gain logs to file
                f.close()
        for item in y:
                for match in re.finditer(r"(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}).*Global Market Gain (.\d*.\d*)", str(item)):
                        total_gain.append(match.group(1))
                        plot_x.append(match.group(1))
                        total_gain.append(match.group(2))
                        plot_y.append(match.group(2))
                for match in re.finditer(r"\:\d{2}\s(\w*\/\w*)", str(item)):
                    ping_plot.append(match.group(1))
        uniques_pplot = list(set(ping_plot))#find unique matches of pairs
        #print uniques_pplot
        xi = 0
        xi_list = []
        for item in uniques_pplot:
            counted = ping_plot.count(item)#count uniques in list
            counted_list.append(counted)
            xi = xi+1
            xi_list.append(xi)
        #print counted_list
        #print xi_list
        #return_this = str(total_gain)#+"\n\n\n"+str(y)
        #return_this = return_this.replace("\\", "")
        #return_this = return_this.replace("\'", "")
        #return_this = return_this.replace("\"", "")
        
        try:
            factor = (Decimal(total_gain[-1])-Decimal(total_gain[-101]))*10000
        except:
            factor = "0"
        #print total_gain[-51]
        html="<!DOCTYPE html>"\
              "<html>"\
              "<head>"\
              "<meta http-equiv='refresh' content='60' >"\
              "</head>"\
              "<META http-equiv='cache-control' content='no-cache'>"\
              "<TITLE>"+total_gain[-1]+"("+str(factor)+")</TITLE>"\
              "<body>"\
              "<div style='width:800px; margin:0 auto;'>"\
              "<h3>CATweb 1.1</h3><img src='static/graph.png' alt='graph'>"\
              "<p>Your latest total gain:<br>Time: "+total_gain[-2]+"<br>Value: "+total_gain[-1]+"<br><br>Growth factor: "+str(factor)+"<br>Total gain in USD: $"+str(Decimal(check_price)*Decimal(total_gain[-1]))+"<br>Current price of 1 BTC: $"+str(check_price)+"</p>"\
              "<A HREF='javascript:history.go(0)'>Click to refresh the page</A>"\
              "</div>"\
              "</body>"\
              "</html>"\
        #
        #if (os.path.exists("static/graph.png")):
        #    os.unlink("static/graph.png")
        #    print ("deleted old graph")
        datetimes = [datetime.datetime.strptime(t, "%Y-%m-%d %H:%M:%S") for t in plot_x]
        #fig = plt.figure()
        #plt.suptitle('CATweb 1.0')
        plt.subplot(2,1,1)
        plt.title('Total Gain')
        plt.plot(datetimes, plot_y, color="blue")
        plt.xlabel('time')
        plt.ylabel('total gain')
        plt.setp(plt.xticks()[1], rotation=30, ha='right')
        plt.subplot(2,1,2)
        plt.title('Total Trades')
        plt.bar(xi_list,counted_list, color="red")
        plt.xticks(xi_list, uniques_pplot)
        plt.xlabel('cryptocurrency')
        plt.ylabel('trades')
        plt.setp(plt.xticks()[1], rotation=30, ha='right') #fig.autofmt_xdate() for subplots
        plt.tight_layout()
        #plt.subplots_adjust(top=0.9)
        plt.savefig("static/graph.png")
        plt.cla()
        return (html)
        #time.sleep(1)
def mutex_processor():
    mutex = Lock()
    def processor_func(handle):
        mutex.acquire()
        try:
            return handle()
        finally:
            mutex.release()
    return processor_func
app = web.application(urls, globals())
app.add_processor(mutex_processor())
if __name__ == "__main__":
    app.run()
