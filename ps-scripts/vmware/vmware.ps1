<<<<<<< HEAD:ps-scripts/vmware/vmware.ps1

#  +++++ Vi Server Anmeldung + Zertifikatscheck aus + Kein Participation
set-PowerCLIConfiguration -scope user -ParticipateinCEIP $false -Confirm:$false | Out-Null
set-PowerCLIConfiguration -invalidcertificateaction  ignore -Confirm:$false | Out-Null 
Add-PSSnapin VMware.VimAutomation.Core -ErrorAction 'SilentlyContinue'

$viserver=Read-Host "Enter IP adress of Vi Server"
$hvserver=Read-Host "Enter IP adress of HV Server"

connect-viserver $viserver -ErrorAction Stop |
Out-Null  
connect-hvserver $hvserver -ErrorAction Stop |
Out-Null


# +++++ ESXI Variablen
$vm_on_esx1 = (get-vm -Location "esx1.aab.vwz").count    # Counts VMs per ESX Host --> Bad code I know -.-
$vm_on_esx2 = (get-vm -Location "esx2.aab.vwz").count
$vm_on_esx3 = (get-vm -Location "esx3.aab.vwz").count

#  +++++ ESXI Abfrage
Write-Host ""
$vmamount = Read-Host "[!] Anzahl der zu erstellenden VM's" 
Write-Host ""
Write-Host "Bitte ESXI Host auswählen" -ForegroundColor Green
Write-Host ""
Write-Host "Aktuelle VM Verteilung auf den ESX Hosts " -ForegroundColor Green
Write-Host ""
Write-Host "ESXI Host       VMs"
Write-Host "-----------     ----"
Write-Host "  ESX1:         $vm_on_esx1"  # Lists Vms per ESX Host
Write-Host "  ESX2:         $vm_on_esx2" 
Write-Host "  ESX3:         $vm_on_esx3"
Write-Host "--------------------"
$vmhost = Read-Host "[!] Auf welchem ESX Server sollen die VMs laufen?(e.g. esx1 or esx2)" 

#  +++++ Datastore Abfrage
Write-Host ""
Write-host "Übersicht über alle Datastore und ihre aktuellen Kapazitäten" -ForegroundColor Green
$dstorename= Get-datastore | Sort-Object Name
$dstorename
Write-Host ""
$dstore = Read-Host "Bitte einen DataStore auswaehlen" 
Write-Host ""

#  +++++ VM Creation + User and PC Pool Assigning 
$i = 1
while ($i -le $vmamount){       
    #  +++++ VM Naming
    $vmname = Read-Host "VM-Name (WXL- muss NICHT geschrieben werden!)"

    #  +++++ User Assignment
    $username = Read-Host "Zugewiesener Nutzer"

    #  +++++ Adding Notes
    # $Notes=Read-Host "Evtl. Notizen fuer die Vm eintragen"
    #  +++++ Setting Notes
    # Set-VM "WXL-$vmname" -Notes $Notes -Confirm:$false -RunAsync| Out-Null
    # Get-VM "WXL-$vmname" | Select-Object Name,Notes

    #  +++++ VM Creation
    New-VM -Name "WXL-$vmname" -Template "WXL-LTSC-MUTTER-Template" -OSCustomizationSpec "Windows 10 LTSC Cloning" -VMHost "$vmhost.aab.vwz" -Datastore "$dstore" -RunAsync |
    Out-Null
 
    #  +++++ Move to Pool + Assign User
    Write-Host "Nutzer Zuweisung"
    add-hvdesktop -poolname "Win-10-LTSC" -machines "WXL-$vmname"     # https://communities.vmware.com/t5/Horizon-Desktops-and-Apps/Assign-user-in-Dedicated-pool-with-Powershell/td-p/980880
    New-HVEntitlement -User $username'@aab.vwz' -ResourceName  "Win-10-LTSC"
    start-sleep -s 5
    get-hvmachine -machinename "WXL-$vmname" | 
    set-hvmachine -user "$username@aabvwz"
    Move-VM -VM "WXL-$vmname" -InventoryLocation "ViewVW_WBK" | 
    Out-Null

    #  +++++ Start VM
    Write-host "Starte VM Klon Prozess..."
    Start-vm -VM "WXL-$vmname" -RunAsync | 
    Out-Null
    $i++
}
Disconnect-VIServer -Server 10.10.1.80 -Confirm:$false
Disconnect-HVServer -Server 10.10.1.31 -Confirm:$false
=======
﻿<#
        .SYNOPSIS
        klont VMs
        .NOTES
        Author: Christian Rathnau 
        2022

        TO Do
        Add Auto Scan of Network based either in VI/HV Servers to get Hypervisors and Foreach ESX get vm Info
    
        .LINK
        None.     

        .INPUTS
        None.
    
        .OUTPUTS
        None.
#>

### Vi Server Anmeldung + Zertifikatscheck aus + Kein Participation

set-PowerCLIConfiguration -scope user -ParticipateinCEIP $false -Confirm:$false | Out-Null
set-PowerCLIConfiguration -invalidcertificateaction  ignore -Confirm:$false | Out-Null 

$viserver=Read-Host "Enter VI Server IP"
connect-viserver $vserver-ErrorAction Stop

$hvserver=Read-Host "Enter HV Server IP"
connect-hvserver $hvserver -ErrorAction Stop

### Alte ESXI Variablen
$vm_on_esx1 = (get-vm -Location "esx").count

### ESXI Abfrage
$vmamount = Read-Host "[!] How many Vm's do you want to clone" 
Write-Host ""
Write-Host "Please choose" -ForegroundColor Green
Write-Host "ESXI Host       VMs"
Write-Host "-----------     ----"
Write-Host "  ESX1:         $vm_on_esx1"  # Lists Vms per ESX Host
Write-Host "--------------------"
$vmhost = Read-Host "[!] On which Host should they run" 

### Datastore Abfrage
Write-Host ""
Write-host "Datastore overview" -ForegroundColor Green
$dstorename= Get-datastore | Sort-Object Name
$dstorename
Write-Host ""
$dstore = Read-Host "Please choose a target datastore" 
Write-Host ""

### VM Creation + User and PC Pool Assigning 
$i = 1
while ($i -le $vmamount){
    Write-Host "Please choose" -ForegroundColor Green
    Write-Host "ESXI Host       VMs"
    Write-Host "-----------     ----"
    Write-Host "  ESX1:         $vm_on_esx1"  # Lists Vms per ESX Host
    Write-Host "--------------------"
    $vmhost = Read-Host "[!] On which Host should they run" 

    ### Datastore Abfrage
    Write-Host ""
    Write-host "Datastore overview" -ForegroundColor Green
    $dstorename= Get-datastore | Sort-Object Name
    $dstorename
    Write-Host ""
    $dstore = Read-Host "Please choose a target datastore" 
    Write-Host ""

    ### VM Naming
    $vmname = Read-Host "VM-Name"

    ### User Assignment
    $username = Read-Host "Assigned User"

    ### Adding Notes
    # $Notes=Read-Host "Evtl. Notizen fuer die Vm eintragen"
    
    ### Setting Notes
    # Set-VM "WXL-$vmname" -Notes $Notes -Confirm:$false -RunAsync
    # Get-VM "WXL-$vmname" | Select-Object Name,Notes

    ### VM Creation
    New-VM -Name "WXL-$vmname" -Template "WXL-LTSC-MUTTER-Template" -OSCustomizationSpec "Windows 10 LTSC Cloning" -VMHost "$vmhost.bla.com" -Datastore "$dstore" -RunAsync |
    Out-Null
 
    ### Move to Pool + Assign User
    Write-Host "User pool assignment"
    add-hvdesktop -poolname "Win-10-LTSC" -machines "WXL-$vmname"     # https://communities.vmware.com/t5/Horizon-Desktops-and-Apps/Assign-user-in-Dedicated-pool-with-Powershell/td-p/980880
    New-HVEntitlement -User $username'@bla.com' -ResourceName  "Win-10-LTSC"
    start-sleep -s 5
    get-hvmachine -machinename "WXL-$vmname" | 
    set-hvmachine -user "$username@blacom"
    Move-VM -VM "WXL-$vmname" -InventoryLocation "ViewVW_WBK" | 
    Out-Null

    ### Start VM
    Write-host "Start cloning(s)..."
    Start-vm -VM "WXL-$vmname" -RunAsync | 
    Out-Null
    $i++
}

Disconnect-VIServer -Server $viserver -Confirm:$false
Disconnect-HVServer -Server $hvserver -Confirm:$false
>>>>>>> a6d7ba278becbe9869efeefe706139cbc9a8892a:ps-scripts/Clone_vms.ps11
