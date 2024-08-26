## Der Windows Papst - Jörn Walter
## https://www.der-windows-papst.de
# Define the log name and the date range (last 2 days)

$LogName = "Microsoft-Windows-DNS-Client/Operational"
$StartDate = (Get-Date).AddDays(-2)
$EndDate = Get-Date

# Suppress errors
$ErrorActionPreference = 'SilentlyContinue'

# Get all DNS Client events within the date range
$Events = Get-WinEvent -FilterHashtable @{LogName=$LogName; StartTime=$StartDate; EndTime=$EndDate} |
    Select-Object TimeCreated, Id, LevelDisplayName, Message, ProviderName |
    Sort-Object TimeCreated

# Check if any events were found
if ($Events.Count -eq 0) {
    Write-Host "No DNS Client events found in the last 2 days."
} else {
    # Load the Excel assembly
    Add-Type -AssemblyName "Microsoft.Office.Interop.Excel"

    # Create a new Excel application
    $Excel = New-Object -ComObject Excel.Application
    $Excel.Visible = $true
    $Excel.DisplayAlerts = $false

    # Create a new workbook and get the active worksheet
    $Workbook = $Excel.Workbooks.Add()
    $Worksheet = $Workbook.ActiveSheet

    # Add headers to the worksheet
    $Worksheet.Cells.Item(1,1) = "TimeCreated"
    $Worksheet.Cells.Item(1,2) = "EventID"
    $Worksheet.Cells.Item(1,3) = "Level"
    $Worksheet.Cells.Item(1,4) = "Message"
    $Worksheet.Cells.Item(1,5) = "ProviderName"

    # Write event data to the worksheet
    $row = 2
    foreach ($Event in $Events) {
        $Worksheet.Cells.Item($row,1) = $Event.TimeCreated
        $Worksheet.Cells.Item($row,2) = $Event.Id
        $Worksheet.Cells.Item($row,3) = $Event.LevelDisplayName
        $Worksheet.Cells.Item($row,4) = $Event.Message
        $Worksheet.Cells.Item($row,5) = $Event.ProviderName
        $row++
    }

    # Autofit columns
    $Worksheet.Columns.AutoFit()

    # Save the workbook to a specified path
    $OutputFile = "D:\DNSClientEvents.xlsx"
    $Workbook.SaveAs($OutputFile)

    # Cleanup
    $Workbook.Close()
    $Excel.Quit()

    # Release COM objects
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Worksheet) | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Workbook) | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel) | Out-Null

    # Final message
    Write-Host "DNS Client events from the last days have been exported to $OutputFile"
}

# Reset error action preference to default
$ErrorActionPreference = 'Continue'
