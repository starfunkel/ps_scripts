<#

.SYNOPSIS
A Script to check the AD groupmembership modifications with repadmin.exe
Author cra

.DESCRIPTION
Gets a user defined ad-group object and calls repadmin.exe /showobjmeta to retrieve the last group modifications.

.PARAMETER DC
Specifies the target domain controller.

.PARAMETER PingCycles
Specifies the target ad group.

.INPUTS
System.String

.OUTPUTS
Unfiltered repadmin output

.EXAMPLE
PS C:\> gmc -dc $DC -grp $GRP

#>

function Get-ADGroupmembershipModification  (){

    [CmdletBinding()]
    [Alias("gmc")]

      param(
        [Parameter(Mandatory=$true,
        Position=0,
        ValueFromPipeline=$true)]
        [Alias("Domain Controller")]
        [string[]]$dc,

        [Parameter(Mandatory=$true,
        Position=1,
        ValueFromPipeline=$true)]
        [Alias("AD group name")]
        [string]$grp
        )

    Begin {}

    Process {
        #$grp = ""
        $dgrpn = (Get-ADGroup -Identity $grp).DistinguishedName
        repadmin.exe /showobjmeta $dc $dgrpn
    }

    End {}
}