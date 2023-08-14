Get-ADComputer -Filter {OperatingSystem -like "Windows Server*" -and Enabled -eq $true} -Property OperatingSystemVersion |
    Select-Object -Property Name, @{
        Name = "BuildNumber"
        Expression = { $_.OperatingSystemVersion -replace "^10\.0\.(\d+)\.\d+$", '$1' }
    } |
    Sort-Object -Property BuildNumber