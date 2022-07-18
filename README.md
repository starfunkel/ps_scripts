# Powershell Working Stuff

##

### powershell system profile

> Put this scriptblock in the $PSHOME profile

```powershell
powershell -noprofile -noexit -command "invoke-expression '. ''PATH_TO_CLONED_REPO\ps_profile\profile.ps1''' "
```


### Powershell scripts and definitions scriptblock

> autoloads them when put in Powershell profile

```powershell
$Path = "PATH_TO_CLONED_REPO"
Get-ChildItem -Path $Path  -Filter *.ps1 |ForEach-Object {
    . $_.FullName
}
```

