function Get-SvcStartName {
    $services = Get-WmiObject -Class Win32_Service

    $serviceObjects = foreach ($service in $services) {
        [PSCustomObject]@{
            Name = $service.Name
            StartName = $service.StartName
        }
    }

    return $serviceObjects
}

Get-SvcStartName | sort-object Startname | Format-Table -AutoSize