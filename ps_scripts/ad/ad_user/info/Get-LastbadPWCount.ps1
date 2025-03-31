<#
.SYNOPSIS
    This script lists all the lastbadpassword AD attribute

#>

Function Get-lastbadPWCount {
Get-ADUser -Filter * -Properties lastbadpasswordattempt,LastLogonDate,badpwdcount |
Where-Object { $_.lastbadpasswordattempt } |
Select-Object Name,enabled,lastbadpasswordattempt,LastLogonDate,badpwdcount |
Sort-Object lastbadpasswordattempt -Descending |
Format-Table -AutoSize
}