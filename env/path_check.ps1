# Path env

<#
To do:

vuild variables
check
    foreach
        if variable exists
        else add variable

#>

# varibales

## Check env:Path

<#
$Env:Path -split ";" -contains $directory

$INSTALL_STPS = "$PSScriptRoot\powershell_stuff"

if (-not [Enviroment]::GetEnviromentVariable('$INSTALL-EVS', 'User'))
    {$Env:support = '$INSTALL_STPS'}

$env:Path += ';$VARIABLE; '  



$pathContent = [Environment]::GetEnvironmentVariable('path', 'User')
$myPath = "\testing"
if ($pathContent -ne $null)
{
  # "Exist in the system!"
  if ($pathContent -split ';'  -contains  $myPath)
  {
    # My path Exists
    Write-Host "$myPath exists"
  }
  else
  {
    Write-Host "$myPath does not exist"
  }
}

#>