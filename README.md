# Powershell Stuff 

## Load custom profile.ps1 from cloned repo location
### If persistence is prefered put this line with the custom repo location in one of Powershells $PSHome file path
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
