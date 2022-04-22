<#
  .SYNOPSIS

  .DESCRIPTION

  .PARAMETER InputPath

  .PARAMETER OutputPath

  .INPUTS

  .OUTPUTS

  .EXAMPLE

  .EXAMPLE

  .EXAMPLE
#>

### Exchange

function push-azure-sync   {
    Connect-AzureAD
    Import-Module ADSync
    Get-ADSyncScheduler
    Start-ADSyncSyncCycle -PolicyType Delta
    start-Sleep -seconds 30
    Start-ADSyncSyncCycle -PolicyType Initial
    Disconnect-AzureAD
}