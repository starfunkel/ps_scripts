# If logpath is present in %SYSTEMROOT%\System32\winevt\logs
function get-4625 {
    $filter4625='<QueryList>
    <Query Id="0" Path="file://C:\support\playground\log_audit\logs\BKG\BKG-WTS-01_Security.evtx">
      <Select Path="file://C:\support\playground\log_audit\logs\........$$$$$$$$">*[System[(EventID=681)]]</Select>
    </Query>
  </QueryList>'
    $LogonEvents = Get-WinEvent -FilterXml $filter4625 
    $LogonEvents | Sort-Object -Property TimeCreated 
}

$filter='<QueryList>
<Query Id="0" Path="Security">
<Select Path="Security">*[System[(EventID=4625) and TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]</Select>
</Query>
</QueryList>'
$LogonEvents = Get-WinEvent -FilterXml $filter
$LogonEvents | Sort-Object -Property TimeCreated #| Select-Object -First 1


Get-WmiObject win32_service  | Format-Table name, startname