# Exclusive Powershell Stuff

## Get all available colors in Powershell with color scheme

[StackOverFlow Link](https://stackoverflow.com/questions/20541456/list-of-all-colors-available-for-powershell)

```powershell
function Show-Colors( ) {
    $colors = [enum]::GetValues([System.ConsoleColor])
    Foreach ($bgcolor in $colors){
        Foreach ($fgcolor in $colors) { Write-Host "$fgcolor|"  -ForegroundColor $fgcolor -BackgroundColor $bgcolor -NoNewLine }
        Write-Host " on $bgcolor"
    }
}
```

## Get all available colors

```powershell
function Show-Colors( ) {
    $colors = [Enum]::GetValues( [ConsoleColor] )
    $max = ($colors | foreach { "$_ ".Length } | Measure-Object -Maximum).Maximum
    foreach( $color in $colors ) {
    Write-Host (" {0,2} {1,$max} " -f [int]$color,$color) -NoNewline
    Write-Host "$color" -Foreground $color
    }
}
```

## Alternativ way of reloading every powershell profile

```powershell
# https: //itenium.be/blog/dev-setup/powershell-profiles/
function rel {
    @(
        $Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost
    ) | 
    ForEach-Object {
        if (Test-Path $_) {
            Write-Verbose "Reloading $_"
            . $_
        }
    }
}
```

## Powershell profile in system32 git add, commit, push

```powershell
Write-Host "Elevating for Powershell Profile commit..." -ForegroundColor Yellow
start-Sleep 1
Start-Process -FilePath powershell.exe -ArgumentList { ### evtl Start-job hieraus machen
    Write-Host "-------------------------------------------------------------------`n
    ###################################################################`n
    -------------------------------------------------------------------" -InformationVariable LINEDELIMITERS
    $PID # Gets Process ID of current Process
    Clear-Host
    ""
    $LINEDELIMITERS
    Set-Location $PSHOME
    Write-Host "Powershell Profile commit (Sys32)"
    ""
    git add .\profile.ps1
    ""
    git commit -m "Profile_Updated"
    ""
    git push
    ""
    Write-Host "Profile (Sys32) comitted" -ForegroundColor Green
    $LINEDELIMITERS
    start-Sleep 2
    stop-process -id $PID
} -verb RunAs
```
## Filter in Powershell

    -ne (not equal to)
    -lt (less than)
    -le (less than or equal to)
    -gt (greater than)
    -ge (greater than or equal to)
    -like (like—a wildcard comparison)
    -notlike (not like—a wildcard comparison)
    -contains (contains the specified value)
    -notcontains (doesn't contain the specified value)
