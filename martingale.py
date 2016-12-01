#cmd example: martingale.py 100000 2500 1000000 100 1


import random
import time
f = open ("martingale.txt", 'w')

import argparse

parser =argparse.ArgumentParser(description='Checking parameters')
parser.add_argument('Balance',metavar='B',help='Your starting balance')
parser.add_argument('Initial_bet',metavar='I',help='Your starting bet')
parser.add_argument('Betting_limit',metavar='L',help='Limit defined by the casino')
parser.add_argument('Rounds',metavar='R',type=int,help='Maximum number of rounds')
parser.add_argument('Pause',metavar='P',type=int,help='Pause between rounds')
param=parser.parse_args()

balance = int(param.Balance)
bet_ini = int(param.Initial_bet)
limit = int(param.Betting_limit)
rounds = int(param.Rounds)
pause = int(param.Pause)

bet = bet_ini
run = 0
streak = 0
max_streak = 0

while balance > 0 and bet < limit and run < rounds:
    run = run +1
    roll = random.randrange (0, 2, 1)

    print "round: "+str(run)        

    if streak == 3:
        bet = bet_ini

    if roll == 0:
        streak = streak + 1
        balance = balance - bet
        print "bet: "+str(bet)
        if bet*2 < balance:
            bet = bet*2
        else:
            print "roll: "+str(roll)        
            print "balance: "+str(balance)
            print "need to bet "+str(bet*2)+", balance too low to continue!"
            break
        
    else:
        streak = 0
        balance = balance + bet        
        print "bet: "+str(bet)
        bet = bet_ini
    
    print "roll: "+str(roll)        
    print "balance: "+str(balance)
    print "lose streak: "+str(streak)
    print ""

    f.write (str(run)+";"+str(bet)+";"+str(roll)+";"+str(balance)+"\n")
    time.sleep(pause)
    if max_streak < streak:
        max_streak = streak

f.close()
print "game over"
print "max lose streak: "+str(max_streak)

#raw_input('Press Enter to exit')

        
