<#
.SYNOPSIS
Helper Script to identify all active smb sessions and their type (dialect) of a given server
arreay
.DESCRIPTION 

.EXAMPLE

.LINK


.NOTES
Written by: Christian Rathnau

Website:	https://www.integrate-it.net/
#>

$Server = "HIN-SRV-023", "HIN-SRV-06"

$Connections = Get-SmBConnection -Server $Server

if ($Connections) {
    foreach ($Connection in $Connections) {
        Write-Host "Connection ID: $($Connection.Id)"
        Write-Host "Client: $($Connection.ClientComputerName)"
        Write-Host "Dialect used $($Connection.Dialect)"
        Write-Host "SMB Version: $($Connection.SmbVerion)"
        Write-Host
    }
} else {
    Write-Host "No active SMB connections found"
}
