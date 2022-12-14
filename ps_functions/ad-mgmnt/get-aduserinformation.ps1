# Gather and display AD user information
function get-aduserinformation {
    [CmdletBinding()]
    [Alias("adu")]
    param(
       [Parameter(Mandatory=$true)]
       [String]$USER
    )
    Write-Host ""
    Write-Host "---------------------------------------------------------------------------------" -InformationVariable LINEDELIMITERS
    Write-Host "User Info:"
    Get-ADUser $USER -Properties *  |
    Select-Object   SamAccountName, Displayname, distinguishedname, EmailAddress, `
                    OfficePhone, Enabled, lastlogondate, LastBadpasswordAttempt, `
                    BadLogonCount, PasswordLastSet, PasswordNeverExpires,SID
    $LINEDELIMITERS
    Write-Host ""
    Write-Host "Group memberships of $USER"
    get-adprincipalGROUPmembership -Identity $USER |
    Select-Object name, distinguishedName |
    Format-Table
    Sort-Object name
    Write-Host ""
    $LINEDELIMITERS
 }