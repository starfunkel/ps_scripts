<#
.SYNOPSIS
	This script repairs all Windows Update components
#>

# Set TrustedInstaller service to auto start
sc config trustedinstaller start=auto

# Stop necessary services
net stop bits
net stop wuauserv
net stop msiserver
net stop cryptsvc
net stop appidsvc

# Rename SoftwareDistribution and catroot2 folders
Rename-Item -Path C:\windows\SoftwareDistribution -NewName SoftwareDistribution.old
Rename-Item -Path c:\windows\System32\catroot2 -NewName catroot2.old

# Register key DLL files
regsvr32.exe /s atl.dll
regsvr32.exe /s urlmon.dll
regsvr32.exe /s mshtml.dll

# Reset Winsock and proxy settings
netsh winsock reset
netsh winsock reset proxy

# Clean driver and PnP caches
rundll32.exe pnpclean.dll,RunDLL_PnpClean /DRIVERS /MAXCLEAN

# Run DISM commands
dism /Online /Cleanup-image /ScanHealth
dism /Online /Cleanup-image /CheckHealth
dism /Online /Cleanup-image /RestoreHealth
dism /Online /Cleanup-image /StartComponentCleanup

# Run System File Checker (SFC) scan
Sfc /ScanNow

# Start necessary services
net start bits
net start wuauserv
net start msiserver
net start cryptsvc
net start appidsvc

Write-Host "Script completed successfully!"