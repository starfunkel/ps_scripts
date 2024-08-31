# Get-Adobject (Get-ADDomain) -Properties ms-DS-MachineAccountQuota

Set-Adobject ((Get-ADDomain).name) -replace @(ms-DS-MachineAccountQuota = "0")
