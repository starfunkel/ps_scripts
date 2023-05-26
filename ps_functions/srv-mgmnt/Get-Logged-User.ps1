function Get-LoggedUser
{
    [CmdletBinding()]
    param
    (
        [string[]]$ComputerName 
    )
    foreach ($comp in $ComputerName)
    {
        $output = @{'Computer' = $comp }
        $output.UserName = (Get-WmiObject -Class win32_computersystem -ComputerName $comp).UserName
        [PSCustomObject]$output
    }
}

