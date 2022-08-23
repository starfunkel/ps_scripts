# Powershell Stuff for Work

## Powershell system profile

> Put this scriptblock in the $PSHOME profile. Replace `PATH_TO_CLONED_REPO` with the path of the cloned repo.

```powershell
powershell -noprofile -noexit -command "invoke-expression '. ''PATH_TO_CLONED_REPO\ps_profile\profile.ps1''' "
```

## Powershell scripts and definitions scriptblock

> Autoloads .ps1 files when put in Powershell profile.

```powershell
$Path = "PATH_TO_CLONED_REPO"
Get-ChildItem -Path $Path  -Filter *.ps1 |ForEach-Object {
    . $_.FullName
}
```
