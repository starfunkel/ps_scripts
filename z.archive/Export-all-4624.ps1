$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFileName = "4624_$timestamp.csv"

$Events = Get-WinEvent -Logname security -FilterXPath "
    Event[System[(EventID=4624)]]
    and Event[EventData[Data[@Name='TargetUserName']='administrator']]" |
    Select-Object `
    @{Label='Time';Expression={$_.TimeCreated.ToString('g')}},
    @{Label='UserName';Expression={$_.Properties[5].Value}},
    @{Label='WorkstationName';Expression={$_.Properties[11].Value}},
    @{Label='IpAddress';Expression={$_.Properties[18].Value}},
    @{Label='LogonType';Expression={$_.Properties[8].Value}},
    @{Label='ImpersonationLevel';Expression={$_.Properties[20].Value}}

 $Events | Export-Csv -Path "C:\admin\log audit\$logFileName" -NoTypeInformation -Encoding UTF8