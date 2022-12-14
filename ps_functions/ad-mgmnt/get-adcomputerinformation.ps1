# Get Ad Computer Info
function Get-ADComputerInformation {
    [CmdletBinding()]
    [Alias("adc")]
    param(
       [Parameter(Mandatory=$true)]
       [String]$COMPUTER
    )
    Write-Host ""
    Write-Host "---------------------------------------------------------------------------------" -InformationVariable LINEDELIMITERS
    Write-Host "Computer Info:"
    Get-ADComputer $COMPUTER -Properties * |
    Select-Object   Name , Enabled, ObjectCategory,  CanonicalName, `
                    PrimaryGroup, OperatingSystem, OperatingSystemVersion, IPv4Address,`
                    whenCreated, LastLogonDate, whenChanged, LastBadPasswordAttempt,`
                    logonCount, objectSid
    $LINEDELIMITERS
    Write-Host ""
}