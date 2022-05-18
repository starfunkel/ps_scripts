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

### Directory Jumpers

function runners    { Set-Location C:\support\runners }
function sup        { Set-Location c:\support\ }
function sysint     { set-Location C:\support\Sysinternals }
function gitd       { Set-Location C:\support\code\_git-repos }
function HKLM:      { Set-Location HKLM: }
function HKCU:      { Set-Location HKCU: }
function Env:       { Set-Location Env: }
function C:         { Set-Location C:\ }
function ~          { Set-Location $env:UserProfile }
function grs         { Set-Location C:\support\code\_git-repos }
function posh       { Set-Location C:\support\code\_git-repos\POSH }
function scrpts     { Set-Location C:\support\code\_git-repos\POSH\ps-scripts }


### Directoriey movement
function cd..       { Set-Location .. }
function cd...      { Set-Location ..\.. }
function cd....     { Set-Location ..\..\.. }