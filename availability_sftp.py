import paramiko
import time  
#paramiko.util.log_to_file('/tmp/paramiko.log')


try:
    # Open a transport

    host = "192.168.0.1"
    port = 22
    transport = paramiko.Transport((host, port))

    # Auth

    username = "username"
    password = "password"
    transport.connect(username = username, password = password)

    # Go!

    sftp = paramiko.SFTPClient.from_transport(transport)
    current = time.time()
    # Upload

    filepath = '/path/in/test.txt'
    localpath = 'c://test.txt'
    sftp.put(localpath, filepath)
    #sftp.rename('/path/in/test.txt','/path/out/test.txt')

    # Download
    found = 0
    while found == 0:
        ls = sftp.listdir(path='/path/out')
        time.sleep(0.1)
        if "test.txt" in ls:
            #print "File found"
            found = 1
    filepath = '/path/out/test.txt'
    localpath = 'c://test.txt'
    sftp.get(filepath, localpath)
    sftp.remove('/path/out/test.txt')
    end = time.time()
    # Close

    sftp.close()
    transport.close()
    print '%.5f' % (end - current)

    print "OK"
    
except Exception as e:
    print e
    print "Fail"
    
