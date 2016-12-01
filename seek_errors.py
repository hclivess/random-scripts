import os
import subprocess

f = open('errorseek.txt', 'w')

thedir = '.'
for file in os.listdir(thedir):
    document = os.path.join(thedir, file)
    print file
    f.write('\n'+file)
    for line in open(document):
        if 'ERROR' in line:
            print line
            f.write(line)
f.close()
