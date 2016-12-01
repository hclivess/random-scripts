import time
import ftplib
import os
import re
import io

try:
    ftp = ftplib.FTP("192.168.0.1")
    ftp.login("username", "password")
except Exception, e:
    print "Cannot connect"
    raise

current = time.time()

bio = io.BytesIO('test')
ftp.storbinary('STOR in/globals.h', bio)

found = 0

while found == 0:
    ls = []
    ftp.retrlines('LIST out/', ls.append)
    for entry in ls:
        find = re.findall ("globals\.h",entry)
        time.sleep(0.1)
        if find != []:
            end = time.time()
            print '%.5f' % (end - current)
            print "OK"
            found = 1

if found != 1:
    print "Not found"

ftp.delete("out/globals.h")



ftp.quit()
ftp.close()
