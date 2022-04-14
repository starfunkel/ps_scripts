#### Powershell 

##### Powershell scripts and definitions which autoload when following code is put in the Powershell profile: 

```
$Path = "PATH_TO_CLONED_REPO"
Get-ChildItem -Path $Path  -Filter *.ps1 |ForEach-Object {
    . $_.FullName
}
```

#### To Do:

> X500 Snippet