<#
.SYNOPSIS
    Gets enabled orphaned Users by adjustable time range.
    Exports findings to csv.
#>


function Get-InactiveADUsers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [int]$Days
    )

    if (-not $PSBoundParameters.ContainsKey('Days')) {
        $input = Read-Host "How many days do you want to go back? (Press Q to escape)"
        if ($input -eq 'Q' -or $input -eq 'q') {
            Write-Host "Exiting." -ForegroundColor Yellow
            return
        }
        if (-not ($input -as [int])) {
            Write-Error "Invalid input. Please enter a numeric value."
            return
        }
        $Days = [int]$input
    }

    Get-ADUser -Filter {enabled -eq $true} -Properties LastLogonDate, Enabled |
    Where-Object {
        $_.LastLogonDate -ne $null -and
        $_.LastLogonDate -le (Get-Date).AddDays(-$Days)
    } |
    Sort-Object -Property LastLogonDate -Descending |
    Format-Table Name, SamAccountName, LastLogonDate, Enabled -AutoSize
}