#  +++++ Vi Server Anmeldung + Zertifikatscheck aus + Kein Participation
set-PowerCLIConfiguration -scope user -ParticipateinCEIP $false -Confirm:$false | Out-Null
set-PowerCLIConfiguration -invalidcertificateaction  ignore -Confirm:$false | Out-Null 

Write-Host ""
Write-Host "AAB VM Cloning from Template with OS Customization Script"
Write-Host ""
Write-Host "Bitte am Vsphere Server anmelden"
Start-Sleep 1
$viserver = connect-viserver 10.10.1.80     # $visserver muss als ganzer Befehl übergeben werden 
Write-Host "Bitte am Vsphere Horizon anmelden"
$hvserver = connect-hvserver 10.10.1.31

# +++++ ESXI Variablen

$vm_on_esx1 = (get-vm -Location "esx1.aab.vwz").count    # Counts VMs per ESX Host
$vm_on_esx2 = (get-vm -Location "esx2.aab.vwz").count
$vm_on_esx3 = (get-vm -Location "esx3.aab.vwz").count
$vm_on_esx4 = (get-vm -Location "esx4.aab.vwz").count
$vm_on_esx5 = (get-vm -Location "esx5.aab.vwz").count

#  ++++++ Action!

#  +++++ VM Creation

#  +++++ Abfragen und Status

#  +++++ ESXI Abfrage

Write-Host ""
$vmamount = Read-Host "Anzahl der zu erstellenden VM's"
Write-Host ""
Write-Host ""
Write-Host "Bitte ESXI Host auswählen"
Write-Host ""
Write-Host "$vmamount Maschinen werden erstellt"
Write-Host ""
Write-Host "Aktuelle VM Verteilung auf den ESX Hosts "
Write-Host ""
Write-Host "ESXI Host       VMs"
Write-Host "-----------     ----"
Write-Host "VMs on ESX1:    $vm_on_esx1"  # Lists Vms per ESX Host
Write-Host "VMs on ESX2:    $vm_on_esx2" 
Write-Host "VMs on ESX3:    $vm_on_esx3" 
Write-Host "VMs on ESX4:    $vm_on_esx4" 
Write-Host "VMs on ESX5:    $vm_on_esx5"  
Write-Host ""
$vmhost = Read-Host "Auf welchem ESX Server sollen die VMs laufen?(e.g. esx1 or esx2)"

#  +++++ Datastore Abfrage

Write-Host ""
Write-host "Uebersicht über alle Datastore und ihre aktuellen Kapazitäten"
Get-datastore | select-object Name, CapacityMB, FreeSpaceMB | format-table -Autosize    
$dstore = Read-Host "Bitte einen DataStore auswaehlen"
Write-Host ""
Write-Host ""
Write-Host ""

#  +++++ VM Creation + User and PC Pool Assigning 

$i = 1
while ($i -le $vmamount){       
    
    #  +++++ VM Naming
    $vmname = Read-Host "VM-Name (WXL- muss NICHT geschrieben werden!)"

    #  +++++ User Assignment
    $username = Read-Host "Zugewiesener Nutzer"

    #  +++++ Adding Notes

    ## SCHLEIFE FÜR NOTIZEN, ODER AKTUELLE DATUM

    #$Notes=Read-Host "Evtl. Notizen fuer die Vm eintragen"
  
    #  +++++ VM Creation
    New-VM -Name "WXL-$vmname" -Template "WXL-LTSC-MUTTER-Template" -OSCustomizationSpec "Windows 10 LTSC Cloning" -VMHost "$vmhost.aab.vwz" -Datastore "$dstore" -RunAsync
 
    #  +++++ Setting Notes
    # Set-VM "WXL-$vmname" -Notes $Notes -Confirm:$false -RunAsync| Out-Null
    # Get-VM "WXL-$vmname" | Select-Object Name,Notes 

    #  +++++ Move to Pool + Assign User

    Write-Host "VM in Win-10-LTSC Pool verschieben und Nutzer Zuweisung"
    # Write-Host "Bitte als VSphere Horizon Admin anmelden"
    # Start-Sleep 2
    # connect-hvserver 10.10.1.31 | Out-Null

    # https://communities.vmware.com/t5/Horizon-Desktops-and-Apps/Assign-user-in-Dedicated-pool-with-Powershell/td-p/980880
    # Add-HVDesktop -poolname "Win-10-LTSC" -Machines "WXL-TEST-4" # 
    add-hvdesktop -poolname "Win-10-LTSC" -machines "WXL-$vmname"
    start-sleep -s 10
    # Get-HVMachine -MachineName "wxl-test-4" | Set-HVMachine -User testcra@aabvwz
    get-hvmachine -machinename "WXL-$vmname" | set-hvmachine -user "$username@aabvwz"
    Move-VM -VM "WXL-$vmname" -InventoryLocation "ViewVW_WBK" | Out-Null

    #  +++++ Start VM

    Write-host "Starte VM"
    Start-vm -VM "WXL-$vmname" -RunAsync | Out-Null
    Write-Host "VM $Hostname wurde erstellt" 
    $i++
}
Disconnect-VIServer -Server 10.10.1.80 -Confirm:$false
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -scope LocalMachine