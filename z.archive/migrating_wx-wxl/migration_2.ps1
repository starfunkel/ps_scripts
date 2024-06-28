#  +++++++++++++++++++++++++++ $$$$$$   /$$$$$$  /$$$$$$$ ++++++++++++++++++++++++++
#  ++++++++++++++++++++++++++/$$__  $$ /$$__  $$| $$__  $$++++++++++++++++++++++++++
#  +++++++++++++++++++++++++| $$  \ $$| $$  \ $$| $$  \ $$++++++++++++++++++++++++++
#  +++++++++++++++++++++++++| $$$$$$$$| $$$$$$$$| $$$$$$$ ++++++++++++++++++++++++++
#  +++++++++++++++++++++++++| $$__  $$| $$__  $$| $$__  $$++++++++++++++++++++++++++
#  +++++++++++++++++++++++++| $$  | $$| $$  | $$| $$  \ $$++++++++++++++++++++++++++
#  +++++++++++++++++++++++++| $$  | $$| $$  | $$| $$$$$$$/++++++++++++++++++++++++++
#  +++++++++++++++++++++++++|__/  |__/|__/  |__/|_______/+++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  ++++++++                                                                 ++++++++   
#  +++++++                  Import Script MDDaemon Messenger                 +++++++
#  ++++++                         by Christian Rathnau                        ++++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++
#  +++++                        Stand 11/2020                                  +++++
#  +++++                        Version 1.0                                    +++++
#  +++++                                                                       +++++
#  +++++    Das Script                                                         +++++
#  +++++                Import Mdaemon Messanger                               +++++
#  +++++                                                                       +++++
#  ++++++                                                                     ++++++
#  +++++++                                                                   +++++++
#  ++++++++                                                                 ++++++++   
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++   
   
#  +++++ Admin Elevation


#  +++++ Parameter
param([switch]$Elevated)
function Test-Admin{ # https://superuser.com/questions/108207/how-to-run-a-powershell-script-as-administrator
 
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
} 

if ((Test-Admin) -eq $false)  {
    if ($elevated) 
    {
        # tried to elevate, did not work, aborting
    } 
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}

exit
}

#  ++++++ Variablen

[string[]] $impd = "C:\Support\1_import\"

#  +++++ Code

Write-Host "#######################################################################################"
Write-Host "#####                                                                             #####"
Write-Host "#####                  Admin Helper Script WX to WXL Generation                   #####"
Write-Host "#####                            CC Christian Rathnau                             #####"
Write-Host "#####                                                                             #####"
Write-Host "#####                                 Version 1.0                                 #####"
Write-Host "#####                                                                             #####"
Write-Host "#######################################################################################"
Write-Host "#                                                                                     #"
Write-Host "# Importing MDaemon Userdata in %programfiles(x86)                                    #"
Write-Host "#                                                                                     #"

#  +++++ Mdaemon Messanger Import
Write-Host "#######################################################################################"
Copy-Item -Path "$impd\MD_Messanger\" -Destination  "C:\Program Files (x86)\MDaemon Technologies\ComAgent" -Recurse -Force
Write-Host "#                                                                                     #"
Write-Host "# Done!                                                                               #"  -ForegroundColor Green
Write-Host "#                                                                                     #"
Write-Host "#######################################################################################"

# netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes # Enable Network Discovery (https://serverfault.com/questions/969771/how-to-check-if-network-discovery-is-on-using-powershell)


