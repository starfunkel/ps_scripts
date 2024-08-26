## Der Windows Papst - Jörn Walter
## https://www.der-windows-papst.de

# Define the Windows logs to search
$WindowsLogs = @("Application", "System", "Security", "Setup")

# Define the date range (last 2 days)
$StartDate = (Get-Date).AddDays(-2)
$EndDate = Get-Date

# Suppress errors
$ErrorActionPreference = 'SilentlyContinue'

# Initialize an empty array to collect events
$Events = @()

# Iterate through each log and get the critical, warning, and error events
foreach ($Log in $WindowsLogs) {
    $Events += Get-WinEvent -FilterHashtable @{LogName=$Log; Level=1,2,3; StartTime=$StartDate; EndTime=$EndDate} |
        Select-Object TimeCreated, Id, LevelDisplayName, LogName, Message, ProviderName
}

# Sort the events by TimeCreated
$Events = $Events | Sort-Object TimeCreated

# Check if any events were found
if ($Events.Count -eq 0) {
    Write-Host "No critical, warning, or error events found in the last 2 days in the specified Windows logs."
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
    $Worksheet.Cells.Item(1,4) = "LogName"
    $Worksheet.Cells.Item(1,5) = "Message"
    $Worksheet.Cells.Item(1,6) = "ProviderName"

    # Write event data to the worksheet
    $row = 2
    foreach ($Event in $Events) {
        $Worksheet.Cells.Item($row,1) = $Event.TimeCreated
        $Worksheet.Cells.Item($row,2) = $Event.Id
        $Worksheet.Cells.Item($row,3) = $Event.LevelDisplayName
        $Worksheet.Cells.Item($row,4) = $Event.LogName
        $Worksheet.Cells.Item($row,5) = $Event.Message
        $Worksheet.Cells.Item($row,6) = $Event.ProviderName
        $row++
    }

    # Autofit columns
    $Worksheet.Columns.AutoFit()

    # Save the workbook to a specified path
    $OutputFile = "D:\WindowsLogs_CriticalWarningErrorEvents.xlsx"
    $Workbook.SaveAs($OutputFile)

    # Cleanup
    $Workbook.Close()
    $Excel.Quit()

    # Release COM objects
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Worksheet) | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Workbook) | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel) | Out-Null

    # Final message
    Write-Host "Critical, warning, and error events from the last days in Windows logs have been exported to $OutputFile"
}

# Reset error action preference to default
$ErrorActionPreference = 'Continue'
