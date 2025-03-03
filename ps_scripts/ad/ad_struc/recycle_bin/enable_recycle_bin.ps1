# Check if running as admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Import Active Directory module
Import-Module ActiveDirectory

# Check optional features
$feature = Get-ADOptionalFeature -Filter {Name -eq "Recycle Bin Feature"}
if ($feature.EnabledScopes -eq $null) {
    # Enable Recycle Bin
    Enable-ADOptionalFeature "Recycle Bin Feature" -Scope ForestOrConfigurationSet -Target (Get-ADForest).Name -Confirm:$false
    
    # Sync changes across domain controllers
    repadmin /syncall /AdeP
    
    # Confirm feature enabled
    Get-ADOptionalFeature -Filter {Name -eq "Recycle Bin Feature"}
}