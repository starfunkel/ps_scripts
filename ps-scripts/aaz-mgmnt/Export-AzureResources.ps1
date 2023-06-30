<#
.SYNOPSIS
Azure Export Script

.DESCRIPTION
Exports User Information from Azure AD teenents
 
.NOTES
Written by Christian Rathnau IIT
#>

Write-Host "
     ____                    __    ___                    ___   ___    ___                                     
    / __/_ __ ___  ___  ____/ /_  / _ |_____ _________   / _ | / _ \  / _ \___ ___ ______  __ _____________ ___
   / _/ \ \ // _ \/ _ \/ __/ __/ / __ /_ / // / __/ -_) / __ |/ // / / , _/ -_|_-<(_-< _ \/ // / __/ __/ -_|_-<
  /___//_\_\/ .__/\___/_/  \__/ /_/ |_/__|_,_/_/  \__/ /_/ |_/____/ /_/|_|\__/___/___|___/\_,_/_/  \__/\__/___/
           /_/   
" -ForegroundColor DarkGreen

Write-Host "    Written by Christian Rathnau 2023 (DBAD)" -ForegroundColor DarkYellow
Write-Host ""

# Prompt for tenant credentials
Write-Host "Please privide login credentials for the Azure tenant" -ForegroundColor Green
$credentials = Get-Credential -Message "Please enter your Azure AD credentials"
Write-Host ""
Write-Host ""
# Prompt for CSV export path
Write-Host  "Please enter the CSV export path."
Write-Host "If left blank, the CSV will be saved in $PSScriptRoot" -ForegroundColor Red
$csvPath = Read-Host

# Set the default CSV export path if not specified
if ([string]::IsNullOrEmpty($csvPath)) {
    $csvPath = $PSScriptRoot
}

# Connect to Azure AD using the provided credentials
Connect-AzureAD -Credential $credentials | Out-Null

# Export Azure AD users to CSV file
Get-AzureADUser -All $true |
    Where-Object {
        $_.ObjectType -eq "User" -and $_.UserType -eq "Member" -and
        ($_.AssignedLicenses).Count -gt 1 -and $_.Surname -ne $null -and $_.GivenName -ne $null
    } |
    Select-Object Surname, GivenName, UserPrincipalName, Mail |
    Sort-Object Surname |
    Export-Csv (Join-Path $csvPath "export.csv") -Force -NoTypeInformation -Encoding Default
Disconnect-AzureAD
Remove-Variable * -ErrorAction SilentlyContinue