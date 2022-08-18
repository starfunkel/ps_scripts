# Exchange Ad-hoc functions

function push-azure-sync   {
                            Connect-AzureAD
                            Import-Module ADSync
                            Get-ADSyncScheduler
                            Start-ADSyncSyncCycle -PolicyType Delta
                            start-Sleep -seconds 30
                            Start-ADSyncSyncCycle -PolicyType Initial
                            Disconnect-AzureAD
                        }