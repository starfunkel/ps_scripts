<#
.SYNOPSIS
    Removes unwanted (old) user accounts from workstations and servers

#>
Function Remove-UserProfile($userName)
{

    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]$InputString

    $userProfile=Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq $userName } | Remove-CimInstance
    Remove-Item -Recurse -Force ($userProfile).LocalPath
}
Remove-UserProfile -userName $user
