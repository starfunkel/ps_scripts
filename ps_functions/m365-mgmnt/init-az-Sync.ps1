# function push-azure-sync {

# [CmdletBinding()]
# param (
#     [Parameter(Mandatory=$true)]
#     [Alias("pas")]
# )
# Connect-AzureAD
# Import-Module ADSync
# Get-ADSyncScheduler
# Start-ADSyncSyncCycle -PolicyType Delta
# start-Sleep -seconds 30
# Start-ADSyncSyncCycle -PolicyType Initial
# Disconnect-AzureAD
# }
