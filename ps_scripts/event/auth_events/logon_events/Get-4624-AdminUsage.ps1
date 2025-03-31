# add more usernames like so
# and Event[EventData[Data[@Name='TargetUserName']='administrator' or Data[@Name='TargetUserName']='2nd Administrator']]" |

$Events = Get-WinEvent -Logname security -FilterXPath "
    Event[System[(EventID=4624)]]
    and Event[EventData[Data[@Name='TargetUserName']='administrator' or Data[@Name='TargetUserName']='2nd Administrator']]" |
    Select-Object `
    @{Label='Time';Expression={$_.TimeCreated.ToString('g')}},
    @{Label='UserName';Expression={$_.Properties[5].Value}},
    @{Label='WorkstationName';Expression={$_.Properties[11].Value}},
    @{Label='IpAddress';Expression={$_.Properties[18].Value}},
    @{Label='LogonType';Expression={$_.Properties[8].Value}},
    @{Label='ImpersonationLevel';Expression={$_.Properties[20].Value}}

$Events | Out-GridView

<#
Reference

- <Event xmlns="http://schemas.microsoft.com/win/2004/08/events/event">
- <System>
    <Provider Name="Microsoft-Windows-Security-Auditing" Guid="{54849625-5478-4994-a5ba-3e3b0328c30d}" /> 
    <EventID>4624</EventID> 
    <Version>2</Version> 
    <Level>0</Level> 
    <Task>12544</Task> 
    <Opcode>0</Opcode> 
    <Keywords>0x8020000000000000</Keywords> 
    <TimeCreated SystemTime="2024-05-24T08:49:53.964991900Z" /> 
    <EventRecordID>2174835075</EventRecordID> 
    <Correlation /> 
    <Execution ProcessID="864" ThreadID="4180" /> 
    <Channel>Security</Channel> 
    <Computer>SRV-Nonsense/Computer> 
    <Security /> 
  </System>
- <EventData>
    <Data Name="SubjectUserSid">S-1-5-18</Data> 
    <Data Name="SubjectUserName">Redacted$</Data> 
    <Data Name="SubjectDomainName">Redacted</Data> 
    <Data Name="SubjectLogonId">0x3e7</Data> 
    <Data Name="TargetUserSid">S-1-5-21-1715567821-651377827-839522115-2975</Data> 
    <Data Name="TargetUserName">Redacted</Data> 
    <Data Name="TargetDomainName">Redacted</Data> 
    <Data Name="TargetLogonId">Redacted</Data> 
    <Data Name="LogonType">3</Data> 
    <Data Name="LogonProcessName">Advapi</Data> 
    <Data Name="AuthenticationPackageName">MICROSOFT_AUTHENTICATION_PACKAGE_V1_0</Data> 
    <Data Name="WorkstationName">Redacted</Data> 
    <Data Name="LogonGuid">{00000000-0000-0000-0000-000000000000}</Data> 
    <Data Name="TransmittedServices">-</Data> 
    <Data Name="LmPackageName">-</Data> 
    <Data Name="KeyLength">0</Data> 
    <Data Name="ProcessId">0x360</Data> 
    <Data Name="ProcessName">C:\Windows\System32\lsass.exe</Data> 
    <Data Name="IpAddress">Redacted/Data> 
    <Data Name="IpPort">14754</Data> 
    <Data Name="ImpersonationLevel">%%1833</Data> 
    <Data Name="RestrictedAdminMode">-</Data> 
    <Data Name="TargetOutboundUserName">-</Data> 
    <Data Name="TargetOutboundDomainName">-</Data> 
    <Data Name="VirtualAccount">%%1843</Data> 
    <Data Name="TargetLinkedLogonId">0x0</Data> 
    <Data Name="ElevatedToken">%%1842</Data> 
  </EventData>
  </Event>



#>