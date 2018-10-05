import base64
import math
import random
import socket
from ftplib import FTP
#from StringIO import StringIO
import os
import time
pc = os.getenv('COMPUTERNAME')
version = "1.66 Sadist Edition (11/2012)"
base64.b64encode("1C915F4D2C")

if not os.path.exists('log.txt'):
    f = open('log.txt', 'w')
    f.write('Nove spusteni aplikace, verze '+str(version))
    f.close()
else:
    f = open('log.txt', 'a')
    f.write('\nNove spusteni aplikace, verze '+str(version))
    f.close()    

socket.setdefaulttimeout(10)

class Postava(object):
    def __init__(self, hp, exp, jmeno, timer, zabitych, equip):
        self.hp = 100
        self.exp = 100
        self.jmeno = "bulik"
        self.timer = 20
        self.zabitych = 0
        self.equip = 1
    def kill(self):
        del self
        
hrac_postava = Postava(100,100,"bulik",20,0,1)

def ftp():
    localtime = time.asctime( time.localtime(time.time()) )
    
    loopftp = 1
    while loopftp == 1:           
        try:
            print ('Zkousim se pripojit na server...')
            ftp = FTP('mamec.php5.cz')   # connect to host, default port
            print ('Zkousim pasivni prenos...')
            
            ftp.set_pasv(True)
            ftp.login('czmamec',base64.b64decode("*"))

            try:
                ftp.delete('score.temp')
            except Exception,e:
                print ("Docasny soubor na serveru nenalezen")
                pass
            
            ftp.rename('score.csv', 'score.temp')
            ftp.retrbinary('RETR score.temp', open('score.csv', 'wb').write)

            upload = str(version)+'	'+localtime+'	'+pc+'	'+hrac_postava.jmeno+'	'+str(hrac_postava.zabitych)+'	'+str(hrac_postava.exp)+'\n'

            f = open('score.csv', 'a')
            f.write (upload)
            f.close()
            ftp.storbinary("STOR score.csv", open("score.csv", "rb"))
            ftp.storbinary("STOR log.txt", open("log.txt", "rb"))
            ftp.rename("log.txt",pc+"_log.txt")
            print ('Nahrani skore probehlo OK')
            loopftp = 0

        except Exception,e:
            loopftp = raw_input ("Pripojeni na server se nezdarilo, vase score nebylo zaznamenano. Zkusit znova nahrat?\n\n1. Ano\n2. Ne\nZadej svou volbu: ")
            if (loopftp.isdigit() == False) or (int(loopftp)!= 2):
                loopftp = 1
            loopftp = int(loopftp)
            pass
        
    print ('\nPeklo te odvrhlo zpatky na zem!')

def equipment():
    hrac_postava.equip = raw_input ("Cim nizsi cislo, tim vyssi ucinnost brneni a nizsi ucinnost zbrane.\nCim vyssi cislo, tim vyssi ucinnost zbrane a nizsi ucinnost brneni.\nVlozte faktor vybaveni cislem od 1 do 100: ")
    if (hrac_postava.equip.isdigit() == False) or (int(hrac_postava.equip) < 1) or (int(hrac_postava.equip) > 100):
        hrac_postava.equip = 1
        print ("Zmeneno na 1\n")
    f = open('log.txt', 'a')
    f.write("\nvybava: "+str(hrac_postava.equip))
    f.close()
        
def boj():
    pocetnepratel = raw_input ("Zadej pocet nepratel: ")
    if (pocetnepratel.isdigit() == False) or (int(pocetnepratel) < 1):
        pocetnepratel = 1
        print ("Zmeneno na 1")

    f = open('log.txt', 'a')
    f.write("\npocet nepratel: "+str(pocetnepratel))
    f.close()
    
    hrac_postava.novehp = (((int(hrac_postava.hp) - int(pocetnepratel)*2) + (int(hrac_postava.exp)/20)) - (int(hrac_postava.equip)/2))  - (random.randint(1, 2))
    hrac_postava.noveexp = int(pocetnepratel) + (int(hrac_postava.exp) + ((int(pocetnepratel)* 4)) * math.fabs(int(hrac_postava.hp)-100)/80) + ((int(hrac_postava.equip)*(hrac_postava.zabitych))/60)
    hrac_postava.zabitych = int(hrac_postava.zabitych) + int(pocetnepratel)
    hrac_postava.timer = int(hrac_postava.timer) - 1

    if (hrac_postava.novehp > hrac_postava.hp) or (hrac_postava.novehp == hrac_postava.hp):
        print "Protivnik byl tak snadno zdolan, ze ti nezpusobil skoro zadna zraneni."
        hrac_postava.novehp = (int(hrac_postava.hp)) - (random.randint(1, 2)) #zabranuje leceni behem boje

    if (hrac_postava.novehp > 0):
        print ("Zabil jsi "+str(pocetnepratel)+" protivniku, celkem "+str(hrac_postava.zabitych)+". Ziskal jsi "+str(int(hrac_postava.noveexp) - int(hrac_postava.exp))+" zkusenosti.")
    else:
        print (str(pocetnepratel)+" protivniku te udolalo. Kdybys prezil, ziskal bys "+str(int(hrac_postava.noveexp) - int(hrac_postava.exp))+" zkusenosti ("+str(hrac_postava.noveexp)+").")
       
    hrac_postava.hp = hrac_postava.novehp
    hrac_postava.exp = hrac_postava.noveexp

    if (hrac_postava.hp < 50) and (hrac_postava.hp > 25):
        print ("V dusledku zraneni v tobe roste zloba a stavas se silnejsim.")
    elif (hrac_postava.hp < 25) and (hrac_postava.hp > 0):
        print ("Utrzena zraneni privadeji tvou krev do bodu varu, ziskavas nadlidskou silu!")
        
    
    if (hrac_postava.hp < 1):
        print ("Byl jsi zabit! (" +str(hrac_postava.hp)+" hp). Peklo te vyplivlo zpatky na zem.")

        f = open('log.txt', 'a')
        f.write("\n-smrt-")
        f.close()
            
        hrac_postava.hp = 100
        hrac_postava.exp = 100
        hrac_postava.timer = 20
        hrac_postava.zabitych = 0
        
    else:
        if hrac_postava.hp > 100:
            hrac_postava.hp = 100
        print("Mas "+str(hrac_postava.hp)+"/100 zivotu a "+str(hrac_postava.exp)+" zkusenosti. Zbyva "+str(hrac_postava.timer)+"/20 utoku. Zbroj/zbran: "+str(100-int(hrac_postava.equip))+"/"+str(hrac_postava.equip))
        if (hrac_postava.timer < 1):
            hodnost = str(None)
            print ("Tve uspechy ti prinesly titul panovnika! Dosahls " +str(hrac_postava.exp)+ " bodu zkusenosti.\n")
            f = open('log.txt', 'a')
            f.write("\n-dohrano- ("+str(hrac_postava.exp)+") zkusenosti")
            f.close()
            if (hrac_postava.exp<1000):
                hodnost = "nevolnik (uroven 1/10)\n"            
            if (hrac_postava.exp>1000) and (hrac_postava.exp<5000):
                hodnost = "paze (uroven 2/10)\n"
            if (hrac_postava.exp>5000) and (hrac_postava.exp<10000):
                hodnost = "rytir (uroven 3/10)\n"
            if (hrac_postava.exp>10000) and (hrac_postava.exp<20000):
                hodnost = "feudal (uroven 4/10)\n"
            if (hrac_postava.exp>20000) and (hrac_postava.exp<40000):
            	hodnost = "aristokrat (uroven 5/10)\n"
            if (hrac_postava.exp>40000) and (hrac_postava.exp<80000):
                hodnost = "lord (uroven 6/10)\n"
            if (hrac_postava.exp>80000) and (hrac_postava.exp<160000):
                hodnost = "baron (uroven 7/10)\n"
            if (hrac_postava.exp>160000) and (hrac_postava.exp<320000):
                hodnost = "vevoda (uroven 8/10)\n"
            if (hrac_postava.exp>320000) and (hrac_postava.exp<640000):
                hodnost = "kral (uroven 9/10)\n"
            if (hrac_postava.exp>640000) and (hrac_postava.exp<12800000):
                hodnost = "polobuh (uroven 10)\n"
            if (hrac_postava.exp>12800000):
                hodnost = "pan tvorstva\n"

            print ("Ziskal jsi hodnost "+hodnost)
  
            ftp()
            
            hrac_postava.hp = 100
            hrac_postava.exp = 100
            hrac_postava.timer = 20
            hrac_postava.zabitych = 0
            
            
def odpocivej():
    pridanehp = raw_input ("Zadej delku odpocinku (1 minuta = +1 zivot, stoji zkusenosti): ")
    f = open('log.txt', 'a')
    f.write("\nodpocinek: "+str(pridanehp))
    f.close()
    if (pridanehp.isdigit() == False) or (int(pridanehp) < 0):
        pridanehp = 0
        print ("Zmeneno na 0")
    
    hrac_postava.hp = int(hrac_postava.hp) + int(pridanehp)
    hrac_postava.exp = int(hrac_postava.exp) - int(pridanehp) - int((hrac_postava.exp)/20)
    
    if (hrac_postava.hp > 99):
        hrac_postava.hp = 100
        print ("Zbytecnym odpocinkem zapominas zkusenosti!")

    if (hrac_postava.exp < 1):
        hrac_postava.exp = 0

    print("Mas "+str(hrac_postava.hp)+"/100 zivotu a "+str(hrac_postava.exp)+" zkusenosti.")

def zjisteniJmena ():
    print ("Tva postava se jmenuje: "+hrac_postava.jmeno)

def nabidka():
    #print("Nabidka")
    print("\n1. Zadat jmeno")
    print("2. Zjistit jmeno")
    print("3. Zbrojnice")
    print("4. Bojiste")
    print("5. Hostinec")
    print("0. Konec\n")
    global volba
    
    volba = raw_input("Zadej svou volbu: ")

    try:
        volba = int(volba)
    except ValueError:
        print ("Neplatny vstup!")        

def ZadatJmeno():
    while True:
        hrac_postava.jmeno = raw_input("Zadejte jmeno: ")
        if not "	" in hrac_postava.jmeno: break
        print ("Neplatny znak, zadejte prosim znova.")
    print ("Nove jmeno je: "+str(hrac_postava.jmeno))

def main():
    print ("Vitejte ve hre\n+Matematicky mec+ v."+str(version)+"\nUkolem je ziskat co nejvice zkusenosti behem " +str(hrac_postava.timer)+ " utoku")
    f = open('log.txt', 'a')  
    while (hrac_postava.timer > 0) and (hrac_postava.hp > 0):
        nabidka()
        if (volba < 0) or (volba > 5):
            print ("Mimo rozsah nabidky, vyber znova!")
        elif (volba == 0):
            f = open('log.txt', 'a')
            f.write("\n-ukonceno-")
            f.close()
            break
        elif (volba == 1):
            ZadatJmeno()
        elif (volba == 2):
            zjisteniJmena()
        elif (volba == 3):
            equipment()          
        elif (volba == 4):
            boj()
        elif (volba == 5):
            odpocivej()

main ()
hrac_postava.kill()
print ("Bye!")

