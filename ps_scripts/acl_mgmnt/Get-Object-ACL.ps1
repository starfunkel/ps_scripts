<#
.SYNOPSIS
    Get list of rights on an organizational Unit in active directory. 

.DESCRIPTION
    Get-ACL provides a CLI orientated fast appraoch to view advanced security access settings by warpping Get-ACL.

.PARAMETER 
   -Name <Name>

      Required?                    yes

.EXAMPLE
    Get-OU-ACL -name <NAme>

    IdentityReference                                 AccessControlType ActiveDirectoryRights
    -----------------                                 ----------------- ---------------------
    NT-AUTORITÄT\DOMÄNENCONTROLLER DER ORGANISATION               Allow           GenericRead
    NT-AUTORITÄT\Authentifizierte Benutzer                        Allow           GenericRead
    NT-AUTORITÄT\SYSTEM                                           Allow            GenericAll
    $DOMAIN\Domänen-Admins                                   Allow            GenericAll
    $DOMAIN\Organization Management                          Allow            GenericAll
    $DOMAIN\Exchange Trusted Subsystem                       Allow            GenericAll
    $DOMAIN\Exchange Enterprise Servers                      Allow           GenericRead
    $DOMAIN\Exchange Enterprise Servers                      Allow           GenericRead
    $DOMAIN\Exchange Trusted Subsystem                       Allow            GenericAll
    $DOMAIN\Exchange Trusted Subsystem                       Allow            GenericAll
    VORDEFINIERT\Prä-Windows 2000 kompatibler Zugriff             Allow           GenericRead
    VORDEFINIERT\Prä-Windows 2000 kompatibler Zugriff             Allow           GenericRead
    $DOMAIN\Organization Management                          Allow           GenericRead
    $DOMAIN\Exchange Trusted Subsystem                       Allow           GenericRead
    $DOMAIN\Organisations-Admins                             Allow            GenericAll


#>
function Get-OU-ACL {
    [CmdletBinding()]
    param(
       [Parameter(Mandatory=$true)]
       [String]$name
    )

    $OUName= (Get-ADOrganizationalUnit -Filter 'Name -eq $name').DistinguishedName
    (get-acl "AD:$((Get-ADOrganizationalUnit -Identity $OUName).distinguishedname)").access |
    where-object {($_.ActiveDirectoryRights -eq "GenericAll") -or ($_.ActiveDirectoryRights -eq  "GenericRead") -or ($_.ActiveDirectoryRights -eq "GenericWrite")} |
    select-object IdentityReference,AccessControlType,ActiveDirectoryRights
}