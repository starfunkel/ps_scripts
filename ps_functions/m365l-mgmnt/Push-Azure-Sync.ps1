# Exchange Ad-hoc functions
function push-azure-sync {
    [CmdletBinding()]
    [Alias("pas")]
    param(
       [Parameter(Mandatory=$true)]
    )
    Connect-AzureAD
    Import-Module ADSync
    Get-ADSyncScheduler
    Start-ADSyncSyncCycle -PolicyType Delta
    start-Sleep -seconds 30
    Start-ADSyncSyncCycle -PolicyType Initial
    Disconnect-AzureAD
 }