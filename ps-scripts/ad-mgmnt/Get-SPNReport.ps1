function get-spn {

	param (
		[string]$computerName,
		[string]$userName,
		[switch]$allComputers,
		[switch]$allUsernames,
		[switch]$exportToCsv,
		[switch]$outputAsList
	)
	
	$rootDSE = New-Object System.DirectoryServices.DirectoryEntry("LDAP://RootDSE")
	$defaultNamingContext = $rootDSE.defaultNamingContext
	
	$searcher = New-Object System.DirectoryServices.DirectorySearcher
	$searcher.SearchRoot = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$defaultNamingContext")
	
	if ($allComputers) {
		$searcher.Filter = "(&(servicePrincipalName=*)(cn=*))"
	} elseif ($allUsernames) {
		$searcher.Filter = "(&(servicePrincipalName=*)(samAccountName=*))"
	} else {
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
			'Service Principal Names' = $spnValues
		}
	}
	
	if ($exportToCsv) {
		$output | Select-Object 'Object Name', 'Service Principal Names' |
			Export-Csv -Path "C:\support\playground\spn_output.csv" -NoTypeInformation
	} elseif ($outputAsList) {
		$output | ForEach-Object {
			Write-Host "Object Name: $($_.'Object Name')"
			Write-Host "Service Principal Names:"
			Write-Host $_.'Service Principal Names'
			Write-Host
		}
	} else {
		$output | Format-Table
	}
	
	$searcher.Dispose()
	
}