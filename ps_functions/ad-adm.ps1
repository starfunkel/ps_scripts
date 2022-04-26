<#
  .SYNOPSIS

  .DESCRIPTION

  .PARAMETER InputPath

  .PARAMETER OutputPath

  .INPUTS

  .OUTPUTS

  .EXAMPLE

  .EXAMPLE

  .EXAMPLE
#>

### Microsoft AD Azur M365 Administration

#### AD Info on Prem
function adu        ( $USER ) { # Get AD User Info
    Write-Host ""
    Write-Host "---------------------------------------------------------------------------------" -InformationVariable LINEDELIMITERS
    Write-Host "User Info:"
    Get-ADUser $USER -Properties *  |
    Select-Object SamAccountName, Displayname, distinguishedname, EmailAddress, OfficePhone, Enabled, lastlogondate, LastBadpasswordAttempt, BadLogonCount, PasswordLastSet, PasswordNeverExpires,SID
    $LINEDELIMITERS
    Write-Host ""
    Write-Host "Group memberships of $USER"
    get-adprincipalGROUPmembership -Identity $USER |
    Select-Object name, distinguishedName |
    Format-Table
    Sort-Object name
    Write-Host ""
    $LINEDELIMITERS
    #|
    #Format-table SamAccountName, Name, Displayname, EmailAddress, OfficePhone, Enabled, lastlogondate, LastBadpasswordAttempt, lastlogondate, PasswordLastSet, PasswordNeverExpires,SID
}
function adg        ( $GROUP) { # Get AD Group Info
    Write-Host ""
    Write-Host "---------------------------------------------------------------------------------" -InformationVariable LINEDELIMITERS
    Write-Host "Group Info:" 
    get-adGROUP $GROUP -Properties * |
    Select-Object CN, DistinguishedName, SamAccountName, CanonicalName, GroupCategory, GroupScope, whenChanged, whenCreated, info, objectSid
    $LINEDELIMITERS
    Write-Host ""
    Write-Host "Group Member Info:"
    get-adGROUPmember $GROUP -Recursive -Server vwdc |
    Get-ADUser -Properties *  |
    Select-Object SamAccountName, Displayname, Enabled, lastlogondate, LastBadpasswordAttempt, BadLogonCount, PasswordLastSet, PasswordNeverExpires, SID |
    Format-table SamAccountName, Displayname, Enabled, lastlogondate, LastBadpasswordAttempt, BadLogonCount, PasswordLastSet, PasswordNeverExpires, SID
    $LINEDELIMITERS
    Write-Host ""
}
function adc        ( $COMPUTER ){ # Get Ad Computer Info
    Write-Host ""
    Write-Host "---------------------------------------------------------------------------------" -InformationVariable LINEDELIMITERS
    Write-Host "Computer Info:"
    Get-ADComputer $COMPUTER -Properties * |
    Select-Object Name , Enabled, ObjectCategory,  CanonicalName, PrimaryGroup, OperatingSystem, OperatingSystemVersion, IPv4Address, whenCreated, LastLogonDate, whenChanged, LastBadPasswordAttempt, logonCount, objectSid
    $LINEDELIMITERS
    Write-Host ""
}

### Get Windows ACL Information  https: //exchangepedia.com/2017/11/get-file-or-FOLDER-permissions-using-powershell.html

function gacl       ( $FOLDER ) { 
    (get-acl $FOLDER).access | Select-Object `
      @{Label="Identity";Expression={$_.IdentityReference}}, `
      @{Label="Right";Expression={$_.FileSystemRights}}, `
      @{Label="Access";Expression={$_.AccessControlType}}, `
      @{Label="Inherited";Expression={$_.IsInherited}}, `
      @{Label="Inheritance Flags";Expression={$_.InheritanceFlags}}, `
      @{Label="Propagation Flags";Expression={$_.PropagationFlags}} | Format-Table -auto
      }

### Azure AD 
