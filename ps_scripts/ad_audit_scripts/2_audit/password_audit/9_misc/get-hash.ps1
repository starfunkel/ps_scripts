# Install DSInternals
# Extracts SYSTEm Hive and ntds.dit
# outputs users and hashes

#
##### UNTESTED
#

# Set executionpolicy
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

Install-Module -Name DSInternals -Force
Import-Module -Name DSInternals -Force

# Set location
$output_path = [Environment]::CurrentDirectory = Get-Location

# Path to SYSTEM registry Hive
$bootkey = Get-BootKey -SystemHivePath '$output_path\registry\SYSTEM'

# Path  to ntds.dit file
$ntdsaudit = Get-ADDBAccount -All -DBPath '${output_path}\Active Directory\ntds.dit' -bootkey $bootkey

foreach($object in $ntdsaudit){
    $output_path = [Environment]::CurrentDirectory = Get-Location
    If($object.NTHash.Count -ne 0){
        $nthash = $object.NTHash | ConvertTo-Hex
        $hash = [String]::Join('',$nthash);
        write-host $object.SamAccountName","$hash
        $hash | Out-File "${output_path}\ad_hashes.txt" -NoClobber -Append
    }
}
