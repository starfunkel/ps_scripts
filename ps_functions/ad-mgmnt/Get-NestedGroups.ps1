function Get-NestedGroups {
    param (
    [Parameter()] $groupinput,
    [Parameter()] [Switch] $IncludeUsers
    )

    function Test-Nest ($funcinput) {
        $indent = $indent + "  "
        foreach ( $group in $funcinput ) { 
    
            Write-host "$indent↳ $($group.name)" 
        
            $GetObjects = Get-ADGroupMember $group
            $GetGroups = $getobjects | Where-Object ObjectClass -eq "Group"
            
            if ($IncludeUsers) {
                $GetUsers = $getobjects | Where-Object ObjectClass -eq "User"
                if ( $GetUsers ) { foreach ($user in $GetUsers) { Write-host "$indent  ↳ $($user.name)" } }
                }

            if ( $getgroups ) { foreach ($group in $GetGroups) { Test-Nest $group } }
            
        }
    }
    
    $i = 1

    foreach ($group in $groupinput) {
        $progress = [math]::round(($i/$groupinput.count)*100) ; Write-Progress -Activity "Scanning for nested groups" -Status "$progress % ($i of $($groupinput.count)) Complete:" -PercentComplete $progress -currentoperation $group.name; $i++

        $indent = ""
        $GetObjects = Get-ADGroupMember $group
        $GetGroups = $getobjects | where objectclass -eq "Group"

        if ( $getgroups ) { 
            Write-Host "`n"$group.name
            
            if ($IncludeUsers) {
                $GetUsers = $getobjects | where objectclass -eq "User"
                if ( $GetUsers ) { foreach ( $user in $GetUsers ) { Write-host "$indent  ↳ $($user.name)" } }
                }

            foreach ( $group in $getgroups ) { Test-Nest $group }
            
            }
    }
}