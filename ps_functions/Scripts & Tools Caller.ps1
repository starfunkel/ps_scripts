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


<#

### Reload profile https: //itenium.be/blog/dev-setup/powershell-profiles/

function rel        {
  @(
      $Profile.AllUsersAllHosts,
      $Profile.AllUsersCurrentHost,
      $Profile.CurrentUserAllHosts,
      $Profile.CurrentUserCurrentHost
  ) | ForEach-Object {
      if (Test-Path $_) {
          Write-Verbose "Reloading $_"
          . $_
      }
  }
}

#>