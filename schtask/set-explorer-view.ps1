$regkey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $regkey Hidden 1
Set-ItemProperty $regkey HideFileExt 0
Set-ItemProperty $regkey ShowSuperHidden 1
Stop-Process -processname explorer
