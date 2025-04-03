sc config trustedinstaller start=auto
net stop bits
net stop wuauserv
net stop msiserver
net stop cryptsvc
net stop appidsvc
Rename-Item -Path C:\windows\SoftwareDistribution -NewName SoftwareDistribution.old
Rename-Item -Path c:\windows\System32\catroot2 -NewName catroot2.old
regsvr32.exe /s atl.dll
regsvr32.exe /s urlmon.dll
regsvr32.exe /s mshtml.dll
netsh winsock reset
netsh winsock reset proxy
rundll32.exe pnpclean.dll,RunDLL_PnpClean /DRIVERS /MAXCLEAN
dism /Online /Cleanup-image /ScanHealth
dism /Online /Cleanup-image /CheckHealth
dism /Online /Cleanup-image /RestoreHealth
dism /Online /Cleanup-image /StartComponentCleanup
Sfc /ScanNow
net start bits
net start wuauserv
net start msiserver
net start cryptsvc
net start appidsvc