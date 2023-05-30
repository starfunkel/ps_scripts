# Gather and dusplay AD group information
function Get-ADGroupInformation {
    [CmdletBinding()]
    [Alias("adg")]
    param(
       [Parameter(Mandatory=$true)]
       [String]$GROUP
    )
    Write-Host ""
    Write-Host "---------------------------------------------------------------------------------" -InformationVariable LINEDELIMITERS
    Write-Host "Group Info:" 
    get-adGROUP $GROUP -Properties * |
    Select-Object   CN, DistinguishedName, SamAccountName, CanonicalName, GroupCategory, `
                    GroupScope, whenChanged, whenCreated, info, objectSid
    $LINEDELIMITERS
    Write-Host ""
    Write-Host "Group Member Info:"
    get-adGROUPmember $GROUP -Recursive -Server |
    Get-ADUser -Properties *  |
    Select-Object   SamAccountName, Displayname, Enabled, lastlogondate, `
                    LastBadpasswordAttempt, BadLogonCount, PasswordLastSet,`
                    PasswordNeverExpires, SID |
    Format-table    SamAccountName, Displayname, Enabled, lastlogondate, `
                    LastBadpasswordAttempt, BadLogonCount, PasswordLastSet, `
                    PasswordNeverExpires, SID
    $LINEDELIMITERS
    Write-Host ""
}