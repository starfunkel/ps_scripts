# Check groups

whoami /groups

# or via gpresult
gpresult /r /scope user 
gpresult /r /scope computer

# clear kerberos ticket for system
klist.exe -li 0x3e7


# in rds ebiroments clear the tgts for all logged on users
Get-WmiObject Win32_LogonSession | Where-Object {$_.AuthenticationPackage -ne 'NTLM'} | ForEach-Object {klist.exe purge -li ([Convert]::ToString($_.LogonId, 16))}

# kill explorer.exe
taskkill /f /im explorer.exe

# start new explorer.exe instance
runas /user:$DOMAIN\$USERexplorer.exe

# check if new tgt is issued
klist tgt
