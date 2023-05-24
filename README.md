# Powershell Stuff 

## Powershell $PSHOME profile system profile
<br>

```powershell
powershell -noprofile -noexit -command "invoke-expression '. ''PATH_TO_CLONED_REPO\ps_profile\profile.ps1''' "
```

## Autoload .ps1  files 
<br>

```powershell
$Path = "PATH_TO_CLONED_REPO"
Get-ChildItem -Path $Path  -Filter *.ps1 |
ForEach-Object {
    . $_.FullName
}
```
