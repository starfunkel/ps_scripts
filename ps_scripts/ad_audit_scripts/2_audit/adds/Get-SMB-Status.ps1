<#
.SYNOPSIS
    Quick check to get information about the current server's SMB configuration

.EXAMPLE
    EnableSMB1Protocol:           False
    EnableSMB2Protocol:           True
    EncryptData:                  False
    EncryptionCiphers             AES_128_GCM, AES_128_CCM, AES_256_GCM, AES_256_CCM
    RequireSecuritySignature:     False
    EnableSecuritySignature:      True
    EnableMultichannel:           True
    SmbServerNameHardeningLevel:  0
    AutoDisconnectTimeout:        15 min
    AnnounceServer:               False

.NOTES
    Additional notes, author, version, etc.

#>
Function Get-SmbMetrics {
    $SmbConfig = Get-SmbServerConfiguration
    Write-Host "EnableSMB1Protocol:          	 $($SmbConfig.EnableSMB1Protocol)"
    Write-Host "EnableSMB2Protocol:          	 $($SmbConfig.EnableSMB2Protocol)"
    Write-Host "EncryptData:                  $($SmbConfig.EncryptData)"
    Write-Host "EncryptionCiphers             $($SmbConfig.EncryptionCiphers)"
    Write-Host "RequireSecuritySignature:     	$($SmbConfig.RequireSecuritySignature)"
    Write-Host "EnableSecuritySignature:      	$($SmbConfig.EnableSecuritySignature)"
    Write-Host "EnableMultichannel:           	$($SmbConfig.EnableMultichannel)"
    Write-Host "SmbServerNameHardeningLevel:  	$($SmbConfig.SmbServerNameHardeningLevel)"
    Write-Host "AutoDisconnectTimeout:        	$($SmbConfig.AutoDisconnectTimeout) min"
    Write-Host "AnnounceServer:               	$($SmbConfig.AnnounceServer)"
}
