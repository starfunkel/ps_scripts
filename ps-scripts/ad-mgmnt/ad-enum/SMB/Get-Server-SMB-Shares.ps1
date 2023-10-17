# Retrieve Server Names 
$server = Get-ADComputer -Filter 'operatingsystem -like "*server*"' | 
Select-Object -ExpandProperty Name

# Collection Point 
$result = @()

# Show all Shares of all Servers
foreach ($s in $server) {
    $shares = Invoke-Command -ComputerName $s -ScriptBlock {Get-SmbShare | Select-Object PSComputerName,Name,Path} 
    $result += New-Object PSObject -Property ([ordered]@{ 
        ServerName  = $s
        Shares      = $shares.Name -join "`n"
        Path        = $shares.Path -join "`n"
    })
}
Write-Output $result | Format-Table -AutoSize -Wrap