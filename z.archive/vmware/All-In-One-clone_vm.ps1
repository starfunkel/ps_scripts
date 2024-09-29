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
#  +++++++      Vsphere VM Cloning from Template with OS Customization       +++++++
#  ++++++                        by Christian Rathnau                         ++++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++
#  +++++    Stand 11/2020                                                      +++++
#  +++++    Version 1.1                                                        +++++
#  +++++                                                                       +++++
#  +++++    Das Script                                                         +++++
#  +++++                Installiert bei Bedarf PowerCli und                    +++++
#  +++++                                                                       +++++
#  +++++                klont aus dem WX-LTSC-MUTTER-Template neue VM's        +++++
#  +++++                vergibt Namen, Fügt Notizen hinzu                      +++++
#  +++++                schiebt sie in ViewVW_WBK Ordner (für Nakivo)          +++++
#  +++++                Schiebt sie in User definierte Datastores              +++++
#  +++++                Schiebt sie in User definierte ESXI Hosts              +++++
#  +++++                Assigned Maschinen zu Pools und User zu Maschinen      +++++
#  +++++                                                                       +++++
#  ++++++                                                                     ++++++
#  +++++++              Und das alles schön bunt!                            +++++++
#  ++++++++                                                                 ++++++++   
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++    Changelog:                                                         +++++
#  +++++                                                                       +++++
#  +++++     Version 1.1                                                       +++++
#  +++++                                                                       +++++
#  +++++       - added Executionpolicy Bypass before and after Script          +++++
#  +++++       - dropped RSAT support                                          +++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++
#  +++++                                                                       +++++

#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++++ Variablen

$viserver = xxx.xxx.xxx.xxx
$hvserver = xxx.xxx.xxx.xxx

$domain = domain


#  +++++ Admin Elevation

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

#  +++++ Code

#  +++++ Set Executionpolicy 

# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -scope LocalMachine

Write-Host "#######################################################################################"
Write-Host "#####                                                                             #####"
Write-Host "#####           Vsphere VM Cloning from Template with OS Customization            #####"
Write-Host "#####                            CC Christian Rathnau                             #####"
Write-Host "#####                                                                             #####"
Write-Host "#####                                 Version 1.1                                 #####"
Write-Host "#####                                                                             #####"
Write-Host "#######################################################################################"
Write-Host "#                                                                                     #"
Write-Host "#                                                                                     #"
Write-Host "# Next, Module Install Check!                                                         #"
Write-Host "#                                                                                     #"
Write-Host "#######################################################################################"
Write-Host ""
Write-Host "#######################################################################################"
Write-Host "#                                                                                     #"

#  +++++ PowerCli Module availabilty check

if(get-Module -ListAvailable  -name vmware*){    # Checks if PowerCli Module is installed, if not it installs it (on first run){
    Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false | Out-Null 
    set-PowerCLIConfiguration -invalidcertificateaction  ignore -Confirm:$false | Out-Null
    Import-Module VMware.VimAutomation.HorizonView
    Get-Module -ListAvailable 'VMware.Hv.Helper' | Import-Module    # Please download the Hv Helper 
    Write-Host "# VMware PowerCLI is already installed                                                #" -ForegroundColor Yellow
    Write-Host "#                                                                                     #"
    Write-Host "# Nothing to do, lets go on!                                                          #" -ForegroundColor Green
    Write-Host "#                                                                                     #"
    Write-Host "#######################################################################################"
}else{
    Write-Host "#                                                                                     #"
    Write-Host "# VMware Modules are not installed, so lets go and do that now!                       #" -ForegroundColor yellow
    Write-Host "# Select Yes to all to install it! This may take some time!                           #"
    Write-Host "#                                                                                     #"
    Write-Host "# Setting up Module Directory                                                         #"
    New-Item -Path "$env:USERPROFILE\Documents\WindowsPowershell\Modules" -ItemType Directory | Out-Null
    Copy-Item -Path "c:\support\Clone-vm\VMware.Hv.Helper\" -Destination "$env:USERPROFILE\Documenets\WindowsPowershell\Modules\" -Recurse -Force    # Copy Vmware.HV.Helper to Destination Dir
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module -Name VMware.PowerCLI
    set-PowerCLIConfiguration -scope user -ParticipateinCEIP $false -Confirm:$false | Out-Null      # Wir wollen kein Mitglied für Produktverbesserung werden!
    set-PowerCLIConfiguration -invalidcertificateaction  ignore -Confirm:$false | Out-Null          # Wir ignorieren auch das fehlerhafte selbstsignierte SSL Zertifikat vom VI Server
    Import-Module VMware.VimAutomation.HorizonView
    Get-Module -ListAvailable 'VMware.Hv.Helper' | Import-Module
    Write-Host "# VMware PowerCLI is now installed                                                    #"  -ForegroundColor Yellow
    Write-Host "#                                                                                     #"
    Write-Host "# 1) Respect the privacy of others.                                                   #"
    Write-Host "# 2) Think before you type.                                                           #"
    Write-Host "# 3) With great power comes great responsibility.                                     #"
    Write-Host "#                                                                                     #"
    Write-Host "#                                                                                     #"
    Write-Host "Lets go on!                                                                           #" -ForegroundColor Green
    Write-Host "#                                                                                     #"
    Write-Host "#######################################################################################"
}

#  +++++ RSAT Module availabilty check - Brauchen wir noch nicht
<#
Write-Host ""
Write-Host "#######################################################################################"

if(Get-WindowsCapability -online | where-object Name -Match "RSAT"){    # Checks if RSAT Modules are available, if not it installs it
    Write-Host "#                                                                                     #"
    Write-Host "RSAT Module is allready installed                                                     #" -ForegroundColor Yellow
    Write-Host "#                                                                                     #"
    Write-Host "Nothing to do, lets go on!                                                            #" -ForegroundColor Green
    Write-Host "#                                                                                     #"
    Write-Host "#######################################################################################"
}else{
    Write-Host "#                                                                                     #"

    Write-Host "RSAT Module isn't installed, so lets go and do that now!                              #" -ForegroundColor Red
    Write-Host "Select Y to install it!                                                               #"

    Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online
    Write-Host "RSAT Module is now installed                                                          #" -ForegroundColor Yellow
    Write-Host "#                                                                                     #"
    Write-Host "Again:                                                                                #"
    Write-Host "#1) Respect the privacy of others.                                                    #"
    Write-Host "#2) Think before you type.                                                            #"
    Write-Host "#3) With great power comes great responsibility.                                      #"
    Write-Host "#                                                                                     #"
    Write-Host "#                                                                                     #"
    Write-Host "Lets go on!                                                                           #" -ForegroundColor Green
    Write-Host "#                                                                                     #"
    Write-Host "#######################################################################################"
}
#>

#  +++++ Credential Store Check

Write-host ""
Write-Host "#######################################################################################"
Write-Host "#                                                                                     #"
Write-host "# Test for Credential Store existence                                                 #"

Start-Sleep 1

$appdata = Test-path ([Environment]::GetFolderPath("ApplicationData"))                                  

if ($appdata = "True"){     # Checks for Credential Store in %Appdata% - connect-viserver creats a store with credentials

    Write-Host "#                                                                                     #"
    Write-host "# Connecting to $viserver (Vsphere Appliance)                                        #"
    Write-Host "#                                                                                     #"
    connect-viserver -server $viserver | Out-Null
    Write-Host "#                                                                                     #"
    Write-host "# Connected!                                                                          #" -ForegroundColor Green
    Write-Host "#                                                                                     #"
    Write-Host "#                                                                                     #"
    Write-host "# Remeber, All Actions will be logged!!                                               #" -ForegroundColor Red
    Write-Host "#                                                                                     #"
    Write-Host "#######################################################################################"

}else{
    Write-Host "# Creating new Credential Store                                                       #"
    Write-Host "#                                                                                     #"
    Write-Host "#                                                                                     #"
    Write-host "# Please enter your Username  to Connect to the VI-Server $viserver!             #" -ForegroundColor Green

    $username = Read-Host "# Username"
    $upwd = Read-Host "# Enter your Password" -AsSecureString

    New-VICredentialStoreItem -Host $viserver -User [$username]@$domain -password [$upwd]
    connect-viserver -server $viserver
    # connect-hvserver -server 10.10.1.31 -User [$username]@aabvwz -password [$upwd] | Out-Null
    Write-Host "#                                                                                     #"
    Write-host "# Connected!                                                                          #"
    Write-host "All Actions will be logged!!                                                          #" -ForegroundColor Red
    Write-Host "#                                                                                     #"
    Write-Host "#######################################################################################"

}

# +++++ ESXI Variablen

$vm_on_esx1 = (get-vm -Location "FQDN").count    # Counts VMs per ESX Host
$vm_on_esx2 = (get-vm -Location "FQDN").count
$vm_on_esx3 = (get-vm -Location "FQDN").count
$vm_on_esx4 = (get-vm -Location "FQDN").count
$vm_on_esx5 = (get-vm -Location "FQDN").count

#  +++++ VM Creation

Write-Host ""
Write-Host "#######################################################################################"
Write-Host "#                                                                                     #"
$vmamount = Read-Host "# Please specify the amount of VMs to create"
Write-Host "#                                                                                     #"
Write-Host "# $vmamount it is!                                                                            #"
Write-Host "#                                                                                     #"
Write-Host "# These ESXI Hosts are available:                                                     #"
Write-Host "#                                                                                     #"
Write-Host "# Current distribution of VMs per ESXi Host:                                          #"
Write-Host "#                                                                                     #"
Write-Host "# VMs on ESX1: $vm_on_esx1                                                                     #"    # Lists Vms per ESX Host
Write-Host "# VMs on ESX2: $vm_on_esx2                                                                     #" 
Write-Host "# VMs on ESX3: $vm_on_esx3                                                                     #" 
Write-Host "# VMs on ESX4: $vm_on_esx4                                                                     #" 
Write-Host "# VMs on ESX5: $vm_on_esx5                                                                     #"  
Write-Host "#                                                                                     #"
$vmhost = Read-Host "# Please specify the ESXI host for deployment (e.g. esx1 or esx2)"
Write-Host "#                                                                                     #"
Write-Host "#                                                                                     #"
Write-host "# Available Datastores for Cloning                                                    #"
Write-Host "#                                                                                     #"
Get-datastore | select-object Name, CapacityMB, FreeSpaceMB | format-table -Autosize    
Write-Host "#                                                                                     #"
Write-Host "#                                                                                     #"
$dstore = Read-Host "# Please specify the Datastore where the VM should live in"
Write-Host "#                                                                                     #"
Write-Host "#######################################################################################"
Write-Host ""

#  +++++ VM Creation + User and PC Pool Assigning 

$i = 1
while ($i -le $vmamount){       
    
    Write-Host "#######################################################################################"
    Write-Host "#                                                                                     #"
    # $connectionserver="10.10.1.31"

    #  +++++ VM Naming
    
    $vmname = Read-Host "# Please enter a Name Extension for the VM (WXL-)"
    If ($vmname.Length -gt 11) {write-Host -ForegroundColor Red "$Hostname is an invalid hostname"; break}  # Checks if Name is max 15 characters
    Write-Host "#                                                                                     #"

    #  +++++ User Assign

    $username = Read-Host "# Please enter the User which will be assigned to this VM"
    Write-Host "#                                                                                     #"

    #  +++++ Adding Notes

    $Notes=Read-Host "# Please enter Notes"
    Write-Host "#                                                                                     #"
  
    #  +++++ VM Creation

    Write-Host "#                                                                                     #"
    Write-Host "# Creating VM...                                                                      #"
    New-VM -Name "WXL-$vmname" -Template "WX-LTSC-MUTTER-Template" -OSCustomizationSpec "Windows 10 LTSC Cloning" -VMHost "$vmhost.$domain" -Datastore "$dstore" -RunAsync
    Move-VM -VM "WXL-$vmname" -InventoryLocation "ViewVW_WBK" | Out-Null
    Write-Host "#                                                                                     #"
   
    #  +++++ Setting Notes
   
    Set-VM "WXL-$vmname" -Notes $Notes -Confirm:$false -RunAsync| Out-Null
    # Get-VM "WXL-$vmname" | Select-Object Name,Notes 

    Write-Host "# Finished Creation                                                                   #"
    Write-Host "#                                                                                     #"
    Write-Host "#######################################################################################"
    Write-Host ""

    #  +++++ Move to Pool + Assign User

    Write-Host "#######################################################################################"
    Write-Host "#                                                                                     #"
    Write-Host "# Moving VM to Pool and assigning User                                                #"
    Write-Host "#                                                                                     #"
    Write-Host "# Please log on to the View Administrator                                             #"
    Start-Sleep 2
    connect-hvserver $hvserver | Out-Null
    Write-Host "#                                                                                     #"

    # https://communities.vmware.com/t5/Horizon-Desktops-and-Apps/Assign-user-in-Dedicated-pool-with-Powershell/td-p/980880
    # Add-HVDesktop -poolname "Win-10-LTSC" -Machines "WXL-TEST-4" # 
    add-hvdesktop -poolname "Win-10-LTSC" -machines "WXL-$vmname"
    start-sleep -s 10
    # Get-HVMachine -MachineName "wxl-test-4" | Set-HVMachine -User testcra@$domain
    get-hvmachine -machinename "WXL-$vmname" | set-hvmachine -user "$username@$domain"

    #  +++++ Start VM

    Write-host "# Starting VM...                                                                      #"
    Write-Host "#                                                                                     #"
    Start-vm -VM "WXL-$vmname" -RunAsync | Out-Null
    Write-Host "Deployment of VM $Hostname finished" 
    Write-Host "#                                                                                     #"
    Write-Host "#######################################################################################"
    $i++
}
Disconnect-VIServer -Server $viserver -Confirm:$false
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -scope LocalMachine
