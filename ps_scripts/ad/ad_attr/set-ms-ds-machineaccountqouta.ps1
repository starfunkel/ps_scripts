<#
.SYNOPSIS
    Set ms-DS-MachineAccountQuota from 10 to 0

.DESCRIPTION
    Sets the default number of allowed computer objects which can be added to a
    domain from 10 to 0. This ensures that only domain admins by default can 
    add computer objects 

#>
Function Set-ms-DS-MachineAccountQuota {
Set-Adobject ((Get-ADDomain).name) -replace @(ms-DS-MachineAccountQuota = "0")
}