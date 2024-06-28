# Search with chainsaw
# chainsaw.exe search  -t 'Event.System.EventID: =4625' .\Security.evtx > 4625_secs.txt
# Read the content of the text file
$fileContent = Get-Content -Path "4625_secs.txt" -Raw

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
$fields = "Timestamp", "EventID", "LogonType", "IpAddress", "IpPort", "ProcessName", "SubjectUserName", "TargetUserName", "Status", "SubStatus"

# Export event data to CSV with UTF-8 encoding
$eventsData | Select-Object $fields | Export-Csv -Path "events.csv" -NoTypeInformation -Encoding UTF8
