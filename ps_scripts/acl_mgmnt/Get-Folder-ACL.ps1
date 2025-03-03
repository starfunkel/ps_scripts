<#
.SYNOPSIS
    Get list of rights on files and folders. 

.DESCRIPTION
    Get-ACL provides a CLI orientated fast appraoch to view advanced security access settings by warpping Get-ACL.

.PARAMETER 
   -Folder <FOLDER>

      Required?                    yes

.ALIASES
   gacl

.EXAMPLE
    Get-FolderACL 

        Identity                                                     Right Access Inherited               Inheritance Flags Propagation Flags
    --------                                                     ----- ------ ---------               ----------------- -----------------
    NT-AUTORITÄT\SYSTEM                                    FullControl  Allow      True ContainerInherit, ObjectInherit              None
    VORDEFINIERT\Benutzer                  ReadAndExecute, Synchronize  Allow      True ContainerInherit, ObjectInherit              None
    NT-AUTORITÄT\Authentifizierte Benutzer         Modify, Synchronize  Allow      True                            None              None
    NT-AUTORITÄT\Authentifizierte Benutzer                  -536805376  Allow      True ContainerInherit, ObjectInherit       InheritOnly


.NOTES
    https: //exchangepedia.com/2017/11/get-file-or-FOLDER-permissions-using-powershell.html

#>

function Get-FolderACL {
    [CmdletBinding()]
    [Alias("gacl")]
    param(
       [Parameter(Mandatory=$true)]
       [String]$FOLDER
    )
    (get-acl $FOLDER).access |
    Select-Object `
    @{Label="Identity";Expression={$_.IdentityReference}}, `
    @{Label="Right";Expression={$_.FileSystemRights}}, `
    @{Label="Access";Expression={$_.AccessControlType}}, `
    @{Label="Inherited";Expression={$_.IsInherited}}, `
    @{Label="Inheritance Flags";Expression={$_.InheritanceFlags}}, `
    @{Label="Propagation Flags";Expression={$_.PropagationFlags}} |
    Format-Table -auto
    Sort-Object Identity -Descending
 }