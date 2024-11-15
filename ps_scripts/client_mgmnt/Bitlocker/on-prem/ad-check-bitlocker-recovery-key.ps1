# Variables:

# OU defintion
$ou = "OU=Mobile Clients,OU=Win,OU=integrate-it Workstations,DC=integrate-it,DC=de"
$csvExportPath = "C:\admin\"

# Search
$computers = Get-ADComputer -Filter * -SearchBase $ou

######################
#   Bitlocker in AD  #
######################

# Build Array
$BitlockerIsPresentInfo = @()

foreach ($computer in $computers) {
    $recoveryInfo = Get-ADObject -Filter 'objectClass -eq "msFVE-RecoveryInformation"' `
        -SearchBase $computer.DistinguishedName `
        -Properties whenCreated, "msFVE-RecoveryPassword" | `
        Sort-Object whenCreated -Descending

    foreach ($info in $recoveryInfo) {
        $BitlockerIsPresentInfo += [pscustomobject]@{
            ComputerName = $computer.Name
            whenCreated  = $info.whenCreated
            RecoveryPassword = $info."msFVE-RecoveryPassword"
        }
    }
}

######################
# NO Bitlocker in AD #
######################

# Build Array
$BitlockerIsAbsent = @()

foreach ($computer in $computers) {
    $recoveryInfo = Get-ADObject -Filter 'objectClass -eq "msFVE-RecoveryInformation"' `
        -SearchBase $computer.DistinguishedName `
        -Properties whenCreated, "msFVE-RecoveryPassword"

    if (-not $recoveryInfo) {
        $BitlockerIsAbsent += [pscustomobject]@{
            ComputerName = $computer.Name
            DistinguishedName = $computer.DistinguishedName
        }
    }
}

# Export CSV
$BitlockerIsPresentInfo | Export-Csv -Path "${csvExportPath}BitlockerIsPresentInfo.csv" -NoTypeInformation -Encoding UTF8
$BitlockerIsAbsent | Export-Csv -Path "${csvExportPath}BitlockerIsAbsent.csv" -NoTypeInformation -Encoding UTF8
