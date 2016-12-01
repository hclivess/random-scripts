import os
import datetime
import shutil
import re

file_1 = "domains1.xml"#"//server1/e$/domains.xml"
file_2 = "domains2.xml"#"//server1/g$/domains.xml"
file_3 = "domains3.xml"#"//server2/d$/domains.xml"
file_4 = "domains4.xml"#"//server2/d$/domains.xml"

file_list = []
file_list.append(file_1)
file_list.append(file_2)
file_list.append(file_3)
file_list.append(file_4)

now = str(datetime.datetime.now()).replace(":","_").rstrip(".")[:-7]

if not os.path.exists("backup"):
    os.makedirs("backup")
shutil.copyfile(file_1, "backup/domains_backup_prod1"+now+".xml")
shutil.copyfile(file_2, "backup/domains_backup_prod2"+now+".xml")
shutil.copyfile(file_3, "backup/domains_backup_test1"+now+".xml")
shutil.copyfile(file_4, "backup/domains_backup_test2_"+now+".xml")

f = open('users.txt')
data = f.readlines()


for x in file_list:
    with open (x, "r") as myfile:
        domains=myfile.read().replace('    </SuperDomain>', '').replace('</domains>','')


    output = open (x,'w')
    output.write (domains[:-2])
    for x in data:
        if x.rstrip() not in domains:
            print x+" added to ..."
            output.write ('\n        <grant user="'+x.rstrip()+'" permission="read"/>\n')
            output.write ('        <grant user="'+x.rstrip()+'" permission="run_tracer"/>')
    output.write('\n    </SuperDomain>\n</domains>')
    output.close()        
        
    f.close()
