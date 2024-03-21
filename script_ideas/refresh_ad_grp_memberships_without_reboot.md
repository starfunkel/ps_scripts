# clear kerberos ticket for system
klist.exe -li 0x3e7

# kill explorer.exe
taskkill /f /im explorer.exe

# start new explorer.exe instance
runas /user:$DOMAIN\$USERexplorer.exe

# check if new tgt is issued
klist tgt
