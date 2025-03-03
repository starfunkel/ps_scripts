$evtxFile = "evtx"
$csvFile = "csv"

<#
    Account logon events: Event IDs 4624, 4625, 4648, and 4672
    Account management events: Event IDs 4720, 4722, 4723, 4724, 4725, 4726, 4738, 4740, 4741, 4742, and 4743
    Directory service access events: Event IDs 4662, 4663, and 4670
    Logon events: Event IDs 4624, 4625, and 4634
    Object access events: Event IDs 4663, 4698, 4699, 4702, 4704, 4705, 4717, and 4719
    Policy change events: Event IDs 4716, 4717, and 4719
    System events: Event IDs 4647, 4656, and 4658

#>

# Retrieve only Event ID 4625 (Failed Logon) events from the EVTX file
$events = Get-WinEvent -Path $evtxFile | Where-Object {$_.Id -eq 4625}

# Convert events to CSV format
$events | Export-Csv -Path $csvFile -NoTypeInformation