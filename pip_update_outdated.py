import os, sys
from subprocess import check_output, call

file = check_output(["pip",  "list", "--outdated"])
print file
line = str(file).split()

for distro in line:
    print "updating: " + str(distro)
    call("pip install --upgrade " + distro, shell=True)
    print "updated: " + str(distro)
