<#
.SYNOPSIS
    Get MS (legacy) local administrator password solution passwords of all computers.

.NOTES
    Maybe Noisy!!
    Forces password rotation on scheduled devices.
    Handle with caution!

#>
function Get-MSLaps-passwords {

$ADSISearcher = [ADSISearcher]'(&(objectclass=computer)(ms-mcs-admpwd=*))' 
$AllComputers = $ADSISearcher.FindAll() 
$DailyHarvest = @() 

Foreach($Comp in $AllComputers){ 
$DailyHarvest += New-Object psobject -Property @{Name = $Comp.properties.name; Password = $Comp.properties.'ms-mcs-admpwd';} 
} 

$DailyHarvest 

}