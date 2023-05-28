funtion logsrch_admin {$eventlog= 
    Get-WinEvent -Path $eventlog -FilterXPath '*[EventData[Data[@Name="TargetUserName"] = "administrator"]]' |
    Select-Object Message -ExpandProperty Message > .\audit.log

    Get-WinEvent -ProviderName 'Microsoft-Windows-Security-Auditing'  -FilterXPath '*EventData[Data[@Name="EventRecordID"] = "800"]'

    Get-WinEvent -Filterhashtable @{
        Logname = "Application"
        Task = "800"
    }
}