<#
.SYNOPSIS
 Powershell Script to extract log events from evtx files with the help of chainsaw

.DESCRIPTION
2024
 
.NOTES
This Script uses Chainsaw (https://github.com/WithSecureLabs/chainsaw) to automatically extract single event IDs and converts them into a csv file.
The Chainsaw binary has to be in $PATH so it can be used with this script

.EXAMPLE
log-extract -EventID 4625
#>

function log-extract  {
    param (
        [Parameter(Mandatory=$true)]
        [int]$EventID
    )

    $outputFileTXT = "$EventID-Events.txt"
    $searchTerm = 'Event.System.EventID: =' + $EventID
    
    # Start Chainsaw as helper binary
    # Note Chainsaw has to be added into $PATH for a smooth execution
    chainsaw.exe search -t $searchTerm .\Security.evtx > $outputFileTXT

    Write-Host ""
    Write-Host "Writing $outputFileTXT finished" -ForegroundColor green
    Write-Host ""
    Write-Host "Parsing $outputFileTXT and converting to csv"-ForegroundColor Green

    # Start conversion from txt to csv
    $fileContent = Get-Content -Path $outputFileTXT -Raw
    $outputFileCSV = "$EventID-Events.csv"

    Write-Host ""
    # Split the content into individual events
    $events = $fileContent -split "Event:"
    
    # Initialize an array to store event data
    $eventsData = @()
    
    # Iterate over each event
    foreach ($event in $events) {
        # Skip empty lines
        if (-not [string]::IsNullOrWhiteSpace($event)) {
            # Create a hashtable to store event data
            $eventData = @{}
    
            # Extract key-value pairs from the event text using regex
            $keyValuePairs = [regex]::Matches($event, "(?sm)^\s+(.*?):\s+(.*?)$")
    
            # Populate the hashtable with extracted data
            foreach ($pair in $keyValuePairs) {
                $key = $pair.Groups[1].Value.Trim()
                $value = $pair.Groups[2].Value.Trim()
                $eventData[$key] = $value
            }
    
            # Add timestamp to event data
            $timestampMatch = [regex]::Match($event, "(?sm)SystemTime:\s+(.*?)$")
            if ($timestampMatch.Success) {
                $timestamp = $timestampMatch.Groups[1].Value.Trim()
                $eventData["Timestamp"] = $timestamp
            }
    
    
            # Add the event data to the array
            $eventsData += New-Object PSObject -Property $eventData
        }
    }
    
    # Select desired fields for CSV
    $fields = "Timestamp", "EventID", "LogonType", "IpAddress", "IpPort", "Computer", "ProcessName", "WorkstationName", "SubjectUserName", "TargetUserName", "Status", "SubStatus"

    Write-Host "Converting  $outputFileTXT... to $outputFileCSV" -ForegroundColor Green
    # Export event data to CSV with UTF-8 encoding
    $eventsData | Select-Object $fields | Export-Csv -Path $outputFileCSV -NoTypeInformation -Encoding UTF8

}