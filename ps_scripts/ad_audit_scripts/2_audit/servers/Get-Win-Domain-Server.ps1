<#
.SYNOPSIS
    This script gathers all Windows Servers of the current domain with OS, OS version, and IPv4 Address 

.EXAMPLE
    Example usage of the script.

.NOTES
    Additional notes, author, version, etc.

#>
Write-Host -ForegroundColor Green "Windows Server $env:userdnsdomain" 
$server=Get-ADComputer -Filter {operatingsystem -like "*server*"} -Properties Name,Operatingsystem,OperatingSystemVersion,IPv4Address 
$scount=$server | 
Measure-Object | 
Select-Object -ExpandProperty count
Write-Output $server |
Sort-Object Operatingsystem |
Format-Table Name,Operatingsystem,OperatingSystemVersion,IPv4Address
Write-Host "Total: "$scount"" -ForegroundColor Yellow
