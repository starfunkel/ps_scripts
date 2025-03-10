<#
.SYNOPSIS
    This script gathers all AD-Computer accounts which are not Windows Server OS based
    in the current domain with OS, OS version, and IPv4 Address.
#>
function Get-Win-Domain-Computers {
    Write-Host -ForegroundColor Green "Windows Computer Objects $env:userdnsdomain"
    $computers = Get-ADComputer -Filter {OperatingSystem -notlike "*server*" -and OperatingSystem -notlike "unknown"} `
        -Properties Name, OperatingSystem, OperatingSystemVersion, IPv4Address 
    $ccount = $computers | Measure-Object | Select-Object -ExpandProperty Count
    $computers | 
    Sort-Object OperatingSystem | 
    Format-Table Name, OperatingSystem, OperatingSystemVersion, IPv4Address
        Write-Host -ForegroundColor Yellow "Total: $ccount"
}




