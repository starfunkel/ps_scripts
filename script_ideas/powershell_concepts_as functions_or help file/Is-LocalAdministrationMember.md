```powershell
function Is-LocalAdministratorsMember ()
{
  # Note: $false to get the Thread's access token in both cases, whether the thread is or is not impersonating
  [Security.Principal.WindowsIdentity] $currentPrincipal = [Security.Principal.WindowsIdentity]::GetCurrent($false)

  [bool] $isAdmin = $false
  [string[]] $sids = $currentPrincipal.Groups | select -Expand Value

  for ($i = 0; $i -lt $sids.Length; $i ++) {

    if ($sids[$i] -eq 'S-1-5-32-544') {

      $isAdmin = $true
      break
    }
  }

  return $isAdmin
}
```