## DeviceManagementManagedDevices.Read.All and InformationProtection.RecoveryKeys.Read.All) permissions are needed

# Define your access token (ensure you have a valid OAuth2 token)
$accessToken = "YOUR_ACCESS_TOKEN"

# Set headers for the request
$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type"  = "application/json"
}

# Step 1: Query BitLocker recovery keys
$recoveryKeysUrl = "https://graph.microsoft.com/v1.0/informationProtection/bitlocker/recoveryKeys"
$recoveryKeysResponse = Invoke-RestMethod -Uri $recoveryKeysUrl -Headers $headers -Method Get

# Check if we got the response successfully
if ($recoveryKeysResponse) {
    # Loop through each recovery key entry
    foreach ($key in $recoveryKeysResponse.value) {
        $deviceId = $key.deviceId

        # Step 2: Get the device details using deviceId
        $deviceUrl = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices/$deviceId"
        $deviceResponse = Invoke-RestMethod -Uri $deviceUrl -Headers $headers -Method Get

        if ($deviceResponse) {
            # Extract device name (or use 'Unknown' if not found)
            $deviceName = $deviceResponse.deviceName
            Write-Host "Device ID: $deviceId, Device Name: $deviceName, Recovery Key: $($key.recoveryKey)"
        } else {
            Write-Host "Failed to get device details for deviceId $deviceId"
        }
    }
} else {
    Write-Host "Failed to retrieve recovery keys."
}