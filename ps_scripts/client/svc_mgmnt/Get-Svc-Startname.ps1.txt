function Get-SvcStartName {
    $services = Get-WmiObject -Class Win32_Service

    $serviceObjects = foreach ($service in $services) {
        $binaryPath = $null
        try {
            $binaryPath = (Get-ItemProperty -LiteralPath "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\$($service.Name)").ImagePath
        } catch {
            # Handle exceptions, e.g., service registry key not found
        }

        [PSCustomObject]@{
            Name = $service.Name
            StartName = $service.StartName
            BinaryPath = $binaryPath
        }
    }

    return $serviceObjects
}

Get-SvcStartName | Sort-Object StartName | Format-Table -AutoSize