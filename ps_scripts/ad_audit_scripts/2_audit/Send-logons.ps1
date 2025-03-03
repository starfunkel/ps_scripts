<#
.SYNOPSIS
    Function to simulate a failed logon attempt by trying to map a network drive

.EXAMPLE
    Test-Logon -DC "YourDomainController" -Username "YourUsername" -Password "YourPassword" -NumberOfAttempts 5

.NOTES
    Noisy as hell. But noise is intended!

#>
function Test-Logon {
    param (
        [CmdletBinding()]
        [Parameter(Mandatory=$true)]
        [string]$DC,
        [string]$Username,
        [string]$Password,
        [int]$NumberOfAttempts
    )

    for ($i = 1; $i -le $NumberOfAttempts; $i++) {
        try {
            $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
            $credential = New-Object System.Management.Automation.PSCredential($username, $securePassword)

            New-PSDrive -Name Z -PSProvider FileSystem -Root "\\$dc\C$" -Credential $credential -ErrorAction Stop
            Remove-PSDrive -Name Z -Force
        }
        catch {
            Write-Host "Attempt #$i : Failed logon attempt to $dc with user $username"
        }
    }
}