function    Get-WinBuild {Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion" | 
            Select-Object ProductName, ReleaseId, InstallationType, CurrentMajorVersionNumber,`
            CurrentMinorVersionNumber,CurrentBuild
            }