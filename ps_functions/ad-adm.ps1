### Microsoft AD Azur M365 Administration

#### AD Info on Prem
function adu        ( $user ) { # Get AD User Info
    Write-Host ""
    Write-Host "---------------------------------------------------------------------------------"
    Write-Host "User Info:"
    Get-ADUser $user -Properties *  |
    Select-Object SamAccountName, Displayname, distinguishedname, EmailAddress, OfficePhone, Enabled, lastlogondate, LastBadpasswordAttempt, BadLogonCount, PasswordLastSet, PasswordNeverExpires,SID
    Write-Host "---------------------------------------------------------------------------------"
    Write-Host ""
    Write-Host "Group memberships of $user"
    get-adprincipalgroupmembership -Identity $user |
    Select-Object name, distinguishedName |
    Format-Table
    Sort-Object name
    Write-Host ""
    Write-Host "---------------------------------------------------------------------------------"
    #|
    #Format-table SamAccountName, Name, Displayname, EmailAddress, OfficePhone, Enabled, lastlogondate, LastBadpasswordAttempt, lastlogondate, PasswordLastSet, PasswordNeverExpires,SID
}
function adg        ( $group) { # Get AD Group Info
    Write-Host ""
    Write-Host "---------------------------------------------------------------------------------"
    Write-Host "Group Info:" 
    get-adgroup $group -Properties * |
    Select-Object CN, DistinguishedName, SamAccountName, CanonicalName, GroupCategory, GroupScope, whenChanged, whenCreated, info, objectSid
    Write-Host "---------------------------------------------------------------------------------"
    Write-Host ""
    Write-Host "Group Member Info:"
    get-adgroupmember $group -Recursive -Server vwdc |
    Get-ADUser -Properties *  |
    Select-Object SamAccountName, Displayname, Enabled, lastlogondate, LastBadpasswordAttempt, BadLogonCount, PasswordLastSet, PasswordNeverExpires, SID |
    Format-table SamAccountName, Displayname, Enabled, lastlogondate, LastBadpasswordAttempt, BadLogonCount, PasswordLastSet, PasswordNeverExpires, SID
    Write-Host "---------------------------------------------------------------------------------"
    Write-Host ""
}
function adc        ( $computer ){ # Get Ad Computer Info
    Write-Host ""
    Write-Host "---------------------------------------------------------------------------------"
    Write-Host "Computer Info:"
    Get-ADComputer $computer -Properties * |
    Select-Object Name , Enabled, ObjectCategory,  CanonicalName, PrimaryGroup, OperatingSystem, OperatingSystemVersion, IPv4Address, whenCreated, LastLogonDate, whenChanged, LastBadPasswordAttempt, logonCount, objectSid
    Write-Host "---------------------------------------------------------------------------------"
    Write-Host ""
}

# Azure AD + M365

function push-azure-sync   {
    Connect-AzureAD
    Import-Module ADSync
    Get-ADSyncScheduler
    Start-ADSyncSyncCycle -PolicyType Delta
    start-Sleep -seconds 30
    Start-ADSyncSyncCycle -PolicyType Initial
    Disconnect-AzureAD
}