import pymqi
from pymqi import CMQC
import time
import re
import argparse

parser =argparse.ArgumentParser(description='Checking parameters')

parser.add_argument('WQ_Manager',metavar='WQM',help='')
parser.add_argument('WQ_Channel',metavar='WQC',help='')
parser.add_argument('Write_Host',metavar='WH',help='')
parser.add_argument('Write_Port',metavar='WP',help='')
parser.add_argument('Write_Queue',metavar='WQ',help='')

parser.add_argument('RQ_Manager',metavar='RQM',help='')
parser.add_argument('RQ_Channel',metavar='RQC',help='')
parser.add_argument('Read_Host',metavar='RH',help='')
parser.add_argument('Read_Port',metavar='RP',help='')
parser.add_argument('Read_Queue',metavar='RQ',help='')

parser.add_argument('snet_sender',metavar='snet_sender',help='')
parser.add_argument('snet_messagetype',metavar='snet_messagetype',help='')
parser.add_argument('snet_receiver',metavar='snet_receiver',help='')

param=parser.parse_args()

write = 1
read = 1

timestamp = int(time.time())
print timestamp

try:
    if write == 1:
        #put message

        queue_manager = param.WQ_Manager
        channel = param.WQ_Channel
        host = param.Write_Host
        port = param.Write_Port
        queue_name = param.Write_Queue
        conn_info = "%s(%s)" % (host, port)
        #print conn_info

        #header options
        put_mqmd = pymqi.md()
        put_mqmd["Format"] = CMQC.MQFMT_RF_HEADER_2
        put_mqmd["Encoding"] = 273
        put_mqmd["CodedCharSetId"] = 1208

        put_opts = pymqi.pmo()

        put_rfh2 = pymqi.RFH2()
        put_rfh2["StrucId"] = CMQC.MQRFH_STRUC_ID
        put_rfh2["Version"] = CMQC.MQRFH_VERSION_2
        put_rfh2["StrucLength"] = 188
        put_rfh2["Encoding"] = 273
        put_rfh2["CodedCharSetId"]= 1208
        put_rfh2["Format"] =  CMQC.MQFMT_STRING
        put_rfh2["Flags"] = 0
        put_rfh2["NameValueCCSID"] = 819

        #header options

        #put folders
        put_rfh2.add_folder("<mcd><Msd>none</Msd></mcd>")
        put_rfh2.add_folder("<usr><snet_messagetype>none</snet_messagetype><snet_sender>"+param.snet_sender+"</snet_sender><snet_receiver>"+param.snet_receiver+"</snet_receiver><snet_messageId>"+str(timestamp)+"</snet_messageId></usr>")
        #put folders
        
        put_msg = "none "+str(timestamp) #define message

        qmgr = pymqi.connect(queue_manager, channel, conn_info)

        queue = pymqi.Queue(qmgr, queue_name)
        queue.put_rfh2(put_msg, put_mqmd, put_opts, [put_rfh2])
        print "Message "+str(timestamp)+" saved to the input queue"
        queue.close()

        qmgr.disconnect()
    else:
        print "Not configured for writing"

    if read == 1:   
        queue_manager = param.RQ_Manager
        channel = param.RQ_Channel
        host = param.Read_Host
        port = param.Read_Port
        queue_name = param.Read_Queue
        conn_info = "%s(%s)" % (host, port)
        #print conn_info

        i = 1
        lookup = []
        while lookup == [] and i < 5:
            print "Attempt "+str(i)

            md = pymqi.MD()
            gmo = pymqi.GMO()
            gmo.Options = pymqi.CMQC.MQGMO_WAIT | pymqi.CMQC.MQGMO_FAIL_IF_QUIESCING
            gmo.WaitInterval = 5000 # 5 seconds
            qmgr = pymqi.connect(queue_manager, channel, conn_info)
            queue = pymqi.Queue(qmgr, queue_name)            
            message = queue.get(None, md, gmo)
            queue.close()
            qmgr.disconnect()
            
            
            lookup = re.findall (str(timestamp), message)
            if lookup != []:            
                print "Correct message found "+str(lookup[0])
                print "OK"
            else:
                print "Match not found, reading the next message"
                i += 1
                
    else:
        print "Not configured for reading"


except Exception as e:
    print e
    raise
