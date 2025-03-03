# Audit NTLMv1 Logons

$CSVPath = "C:\admin\NTLMv1LogonEvents.csv"
$EventID = 4624
$NTLMv1Logons = @()

# Fetch the security logs related to NTLMv1 logon attempts
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=$EventID} | ForEach-Object {
    # Extract the message part of the event log
    $EventMessage = $_.Properties[10].Value
        # Check if NTLM is used (NTLMv1 has an authentication package of NTLM)
    if ($EventMessage -like "*NTLM*") {
        $EventDetails = $_.Message
        # Look for patterns indicating NTLMv1
        if ($EventDetails -match "NTLM.*Version: 1") {
            # Collect information
            $LogonDetails = [PSCustomObject]@{
                TimeCreated           = $_.TimeCreated
                AccountName           = $_.Properties[5].Value
                LogonType             = $_.Properties[8].Value
                WorkstationName       = $_.Properties[11].Value
                SourceNetworkAddress  = $_.Properties[18].Value
            }
            $NTLMv1Logons += $LogonDetails
        }
    }
}

# Export to csv
$NTLMv1Logons | Export-Csv -Path $CSVPath -NoTypeInformation