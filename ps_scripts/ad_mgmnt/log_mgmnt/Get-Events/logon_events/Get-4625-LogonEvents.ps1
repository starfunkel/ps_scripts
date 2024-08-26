<#
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
        [int]
        $Days = 7,
        [string]
        $ID = 4625
    )

    Get-WinEvent -FilterHashtable @{LogName='Security'; Id=$ID; StartTime=(Get-Date).AddDays(-$Days)} | 
        Where-Object {!$_.Properties[5].Value.EndsWith('$')} |
            Foreach-Object {

                $Properties = $_.Properties
                New-Object PSObject -Property @{
                    TimeCreated                 = $_.TimeCreated
                    SubjectUserSid              = $Properties[0].Value.ToString()
                    SubjectUser                 = "$($Properties[2].Value)\$($Properties[1].Value)"
                    SubjectLogonId              = $Properties[3].Value
                    LogonGuid                   = $Properties[4].Value
                    TargetUserName              = "$($Properties[6].Value)\$($Properties[5].Value)"
                    TargetDomainName            = $Properties[7].Value
                    Status                      = $Properties[8].Value
                    SubStatus                   = $Properties[9].Value
                    FailureReason               = $Properties[10].Value
                    LogonType                   = $Properties[11].Value
                    LogonProcessType            = $Properties[12].Value
                    AuthenticationPackageName   = $Properties[13].Value
                    WorkstationName             = $Properties[14].Value
                    ProcessId                   = $Properties[18].Value
                    ProcessName                 = $Properties[19].Value
                    IpAdress                    = $Properties[20].Value
                    IpPort                      = $Properties[21].Value

                }
    } | Select-object TimeCreated,SubjectUserSid,SubjectUser,SubjectLogonId,LogonGuid,TargetUserName,TargetDomainName,Status,SubStatus,FailureReason,LogonType,LogonProcessType,AuthenticationPackageName,WorkstationName,IpAdress,IpPort,ProcessId,ProcessName | ConvertTo-Csv -NoTypeInformation
}
