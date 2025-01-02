## needs work
## 

function Reset-PWExpiration  (){
 
    [CmdletBinding()]
 
    [Alias("RPWE")]
 
      param(
        [Parameter(Mandatory=$true,
        Position=0,
        ValueFromPipeline=$true)]
        [Alias("User")]
        [string[]]$User,
 
        [Parameter(Mandatory=$false,
        Position=1,
        ValueFromPipeline=$true)]
        [Alias("Reset")]
        [string]$reset
        )
 
    Begin {}
 
    Process {
             
        Get-ADUser $User -Properties pwdLastSet | 
        Select-Object SamAccountName,@{Name="pwdLastSet";Expression={[datetime]::FromFileTime($_.pwdLastSet)}}
        
        # If cluase: Would you like to reset the exp dateß

        Get-ADUser $User -Replace @{pwdLastSet='0'}
        Set-ADUser $User -Replace @{pwdLastSet='-1'}

        Get-ADUser $User -Properties pwdLastSet | 
        Select-Object SamAccountName,@{Name="pwdLastSet";Expression={[datetime]::FromFileTime($_.pwdLastSet)}}

    }
 
    End {}
}

