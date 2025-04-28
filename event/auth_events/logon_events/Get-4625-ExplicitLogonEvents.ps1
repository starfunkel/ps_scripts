<#
.SYNOPSIS
    This scripts lists detailed information about 4625 logon events.

.NOTES
    XML Path for reference

    <Data Name="SubjectUserSid"></Data> 
    <Data Name="SubjectUserName"></Data> 
    <Data Name="SubjectDomainName"></Data> 
    <Data Name="SubjectLogonId"></Data> 
    <Data Name="TargetUserSid"></Data> 
    <Data Name="TargetUserName"></Data> 
    <Data Name="TargetDomainName"></Data> 
    <Data Name="Status"></Data> 
    <Data Name="FailureReason">%%</Data> 
    <Data Name="SubStatus"></Data> 
    <Data Name="LogonType"></Data> 
    <Data Name="LogonProcessName"></Data> 
    <Data Name="AuthenticationPackageName"></Data> 
    <Data Name="WorkstationName"></Data> 
    <Data Name="TransmittedServices">-</Data> 
    <Data Name="LmPackageName">-</Data> 
    <Data Name="KeyLength"></Data> 
    <Data Name="ProcessId"></Data> 
    <Data Name="ProcessName">-</Data> 
    <Data Name="IpAddress"></Data> 
    <Data Name="IpPort"></Data>

#>

function Get-ExplicitLogonEvents {
    [CmdletBinding()]
    Param(
        [int]$Days = 7,
        [int]$ID = 4625
    )

    Get-WinEvent -FilterHashtable @{
        LogName = 'Security'
        Id      = $ID
        StartTime = (Get-Date).AddDays(-$Days)
    } | Where-Object {
        # Ensure there are at least 15 props, and not a machine account
        $_.Properties.Count -ge 15 -and
        $_.Properties[5].Value -and
        -not $_.Properties[5].Value.EndsWith('$')
    } | ForEach-Object {
        $p = $_.Properties

        [PSCustomObject]@{
            TimeCreated               = $_.TimeCreated
            SubjectUserSid            = $p[0].Value
            SubjectUser               = "$($p[2].Value)\$($p[1].Value)"
            SubjectLogonId            = $p[3].Value
            LogonGuid                 = $p[4].Value
            TargetUserName            = "$($p[6].Value)\$($p[5].Value)"
            TargetDomainName          = $p[6].Value
            Status                    = $p[8].Value
            SubStatus                 = $p[9].Value
            FailureReason             = $p[10].Value
            LogonType                 = $p[11].Value
            LogonProcessType          = $p[12].Value
            AuthenticationPackageName = $p[13].Value
            WorkstationName           = $p[14].Value
            ProcessId                 = if ($p.Count -gt 18) { $p[18].Value } else { $null }
            ProcessName               = if ($p.Count -gt 19) { $p[19].Value } else { $null }
            IpAddress                 = if ($p.Count -gt 20) { $p[20].Value } else { $null }
            IpPort                    = if ($p.Count -gt 21) { $p[21].Value } else { $null }
        }
    } | Select-Object TimeCreated, SubjectUserSid, SubjectUser, SubjectLogonId, LogonGuid, 
                      TargetUserName, TargetDomainName, Status, SubStatus, FailureReason,
                      LogonType, LogonProcessType, AuthenticationPackageName, WorkstationName,
                      IpAddress, IpPort, ProcessId, ProcessName 
                      # | Format-table -Autosize
                      # | ConvertTo-Csv -NoTypeInformation
}