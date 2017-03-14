#architecture is not very good

import datetime, calendar, glob, fnmatch, os, functools, ftplib, time, logging, sys, csv
from shutil import copyfile
from logging.handlers import RotatingFileHandler

# logging settings start
log_formatter = logging.Formatter('%(asctime)s %(levelname)s %(funcName)s(%(lineno)d) %(message)s')
logFile = "ftp.log"
my_handler = RotatingFileHandler(logFile, mode='a', maxBytes=5 * 1024 * 1024, backupCount=2, encoding=None, delay=0)
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
# logging settings end


try:
    month = str(datetime.datetime.now().strftime("%m"))  # month number
    last_month = str(int(month) - 1 if int(month) > 1 else 12)
    month_abbreviated = calendar.month_abbr[int(month)]  # month abbreviation
    year = str(datetime.datetime.now().year)  # year

    report = ("*_Service_Availability*Month-10*" + month_abbreviated + "*" + year + "*pdf")  # filter for seaching gateways, 10th of month in filename
    gateways = ["server1", "server2", "server3", "server4"]  # list of gateways

    session = ftplib.FTP('ip', 'user', 'password')  # open ftp session already now
    session.cwd("/Reports/")  # enter /reports directory

    with open('customers.csv', 'r') as csvfile:
        reader = csv.reader(csvfile, delimiter=',', quotechar='|')
        customer_list = []
        for row in reader:
            customer_list.append(row)

    for gateway in gateways:  # perform on each gateway
        names = [os.path.basename(x) for x in glob.glob("\\\\" + gateway + "\\reports\\" + report)]  # look for files which match filter

        for name in names:
            customer = name.split("_")[1]  # get customer from filename

            for tuple in customer_list:
                if tuple[0] == customer:
                    name2 = name  # start replacing file names in a separate variable
                    name2 = name2[:-30] + "_" + last_month + "_" + year + ".pdf"  # cut ending, add new format, rename to previous month
                    name2 = name2.replace("Report_", "").replace("_Service", " Service")  # remove some underscores
                    name2.replace(tuple[0], tuple[1])

                    app_log.info("Copying " + name2 + " to local drive")
                    copyfile("\\\\" + gateway + "\\reports\\" + name, "c:\\reports_dir\\" + customer + "\\" + year + "\\" + last_month + "\\" + name2)  # copy files to new location, under previously redefined names

                    file = open("c:\\reports_dir\\" + customer + "\\" + year + "\\" + last_month + "\\" + name2, "rb")  # open file for upload
                    app_log.info("Uploading " + name2 + " to FTP")
                    session.storbinary("STOR " + name2, file)  # copy to FTP server
                    app_log.info("Uploading finished")
                    file.close()

    session.quit()
except Exception as e:
    app_log.info("Error: " + str(e))
    raise

