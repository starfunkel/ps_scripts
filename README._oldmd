# Powershell Stuff 

## Load custom profile.ps1 from cloned repo location
### If persistence is prefered put this line with the custom repo location in one of Powershells $PSHome file path
<br>

```powershell
powershell -noprofile -noexit -command "invoke-expression '. ''PATH_TO_CLONED_REPO\profile.ps1''' "
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

***
***

## To Do:

Build fully automated and Windows platform dependent powershell profile


- set env's:
    - module install
        - on startup of powershell check if installed and install if not
    - may be time sonsuming --> testing required!

    - set path env's:
        - add repo path to $PATH var of Windows (This may be an alternative to dor sourcing all .ps1 files at every powershell startup) 

