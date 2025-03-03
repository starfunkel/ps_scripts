<#
.SYNOPSIS
    Get ACL list of rights on files and folders. 

.DESCRIPTION
    Get-ACL provides a CLI orientated fast appraoch to view advanced security access settings by warpping Get-ACL.

.PARAMETER 
   -Folder <FOLDER>

      Required?                    yes

.ALIASES
   gracl

.EXAMPLE
    Get-RecurseACL <Folder>

Current Folder test

Identity                                                     Right Access Inherited               Inheritance Flags Propagation Flags
--------                                                     ----- ------ ---------               ----------------- -----------------
VORDEFINIERT\Administratoren                           FullControl  Allow      True ContainerInherit, ObjectInherit              None
NT-AUTORITÄT\SYSTEM                                    FullControl  Allow      True ContainerInherit, ObjectInherit              None
VORDEFINIERT\Benutzer                  ReadAndExecute, Synchronize  Allow      True ContainerInherit, ObjectInherit              None
NT-AUTORITÄT\Authentifizierte Benutzer         Modify, Synchronize  Allow      True                            None              None
NT-AUTORITÄT\Authentifizierte Benutzer                  -536805376  Allow      True ContainerInherit, ObjectInherit       InheritOnly
VORDEFINIERT\Administratoren                           FullControl  Allow      True ContainerInherit, ObjectInherit              None
NT-AUTORITÄT\SYSTEM                                    FullControl  Allow      True ContainerInherit, ObjectInherit              None
VORDEFINIERT\Benutzer                  ReadAndExecute, Synchronize  Allow      True ContainerInherit, ObjectInherit              None
NT-AUTORITÄT\Authentifizierte Benutzer         Modify, Synchronize  Allow      True                            None              None
NT-AUTORITÄT\Authentifizierte Benutzer                  -536805376  Allow      True ContainerInherit, ObjectInherit       InheritOnly
VORDEFINIERT\Administratoren                           FullControl  Allow      True ContainerInherit, ObjectInherit              None
[...]


.NOTES
    https://exchangepedia.com/2017/11/get-file-or-FOLDER-permissions-using-powershell.html

#>

function Get-RecurseACL {
    [CmdletBinding()]
    [Alias("gracl")]
    param(
       [Parameter(Mandatory=$true)]
       [String]$FOLDER
    )

    $PATH=(Get-Childitem -Directory).name
      ForEach ($FOLDER in $PATH) {
          Write-Host Current Folder: $FOLDER -ForegroundColor Yellow
          (get-acl $PATH).access |
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
  }