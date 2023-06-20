function Get-SPN {
    param (
        [string]$computerName,
        [string]$userName,
        [switch]$allComputers,
        [switch]$allUsernames,
        [switch]$exportToCsv,
        [switch]$outputAsList,
        # [string]$csvPath = "C:\admin\ad_spns.csv"
		[string]$csvPath = "C:\support\code\git-repos\starfunkel\powershell_stuff\ps-scripts\ad-mgmnt"
	)

    $rootDSE = New-Object System.DirectoryServices.DirectoryEntry("LDAP://RootDSE")
    $defaultNamingContext = $rootDSE.defaultNamingContext

    $searcher = New-Object System.DirectoryServices.DirectorySearcher
    $searcher.SearchRoot = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$defaultNamingContext")

    if ($allComputers) {
        $searcher.Filter = "(&(servicePrincipalName=*)(cn=*))"
    }
    elseif ($allUsernames) {
        $searcher.Filter = "(&(servicePrincipalName=*)(samAccountName=*))"
    }
    else {
        $searcher.Filter = "(&(servicePrincipalName=*)(|(cn=$computerName)(samAccountName=$userName)))"
    }

    $searcher.PageSize = 1000
    $searcher.PropertiesToLoad.AddRange(@("name", "servicePrincipalName"))

    $results = $searcher.FindAll()

    $output = foreach ($result in $results) {
        $entry = $result.GetDirectoryEntry()
        $spnValues = $entry.Properties["servicePrincipalName"] | ForEach-Object { $_ -join "`n" }

        [PSCustomObject]@{
            'Object Name' = $entry.Properties["name"] -join ';'
            'Service Principal Names' = $spnValues -join "`n"
        }
    }

    if ($exportToCsv) {
        $output | Export-Csv -Path $csvPath -NoTypeInformation -Delimiter ';'
    }
    elseif ($outputAsList) {
        $output | ForEach-Object {
            Write-Host "Object Name: $($_.'Object Name')"
            Write-Host "Service Principal Names:"
            Write-Host $_.'Service Principal Names'
            Write-Host
        }
    }
    else {
        $output | Sort-Object 'Object Name' | Format-Table -Wrap
    }

    $searcher.Dispose()
}