Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force -Confirm:$false

# Define OUs, Groups and Users and Attributes here
$OUs            =   'HR','Technicians','CEOs','Groups'
$Groups         =   'HR','Technicians','CEOs'
$HR             =   'Hans Womanizer','Markus Haul','Birgit Immerfroh','Franz Bizeps'
$Technician     =   'Bernd Bullseye','Michael Hightower','Markus PowerShell'
$CEO            =   'Peter Travesty','Tatjana Schlank'
$City           =   'Vienna','Berlin','New York'

# User Password 
$userpw = Read-Host "Enter a password for the users"

# Creating litte helpers ...
$root = $env:USERDNSDOMAIN.Split('.')[1]
$sub = $env:USERDNSDOMAIN.Split('.')[0]

Create OUs
Foreach ($o in $OUs) {
    New-ADOrganizationalUnit -Name $o -Verbose
}

Create Groups
Foreach ($g in $Groups) {
    New-ADGroup -Name $g `
    -Path "OU=Groups,DC=$sub,DC=$root" `
    -GroupScope Universal -GroupCategory Security -Verbose
}

# Create users and store them in the corresponding OU. 
# Add users to groups corresponding to the OU.
foreach ($h in $HR) {
    $split =    $h.split(' ')
    $sam =      ($split[0].Substring(0,1) + '.' + $split[1]).ToLower()
    $upn =      ($split[0].Substring(0,1) + '.' + $split[1] + '@' + 
                $env:USERDNSDOMAIN).ToLower()
    New-ADUser `
    -Name $h `
    -GivenName $split[0] `
    -Surname $split[1] `
    -DisplayName $h `
    -Enabled $true `
    -AccountPassword (ConvertTo-SecureString -AsPlainText $userpw -Force) `
    -SamAccountName $sam `
    -UserPrincipalName $upn `
    -Path "OU=HR,DC=$sub,DC=$root" `
    -EmailAddress $upn `
    -Department 'HR' `
    -City (Get-Random -InputObject $City[0..3]) `
    -Verbose
}

foreach ($t in $Technician) {
    $split =    $t.split(' ')
    $sam =      ($split[0].Substring(0,1) + '.' + $split[1]).ToLower()
    $upn =      ($split[0].Substring(0,1) + '.' + $split[1] + '@' + 
                $env:USERDNSDOMAIN).ToLower()
    New-ADUser `
    -Name $t `
    -GivenName $split[0] `
    -Surname $split[1] `
    -DisplayName $t `
    -Enabled $true `
    -AccountPassword (ConvertTo-SecureString -AsPlainText $userpw -Force) `
    -SamAccountName $sam `
    -UserPrincipalName $upn `
    -Path "OU=Technicians,DC=$sub,DC=$root" `
    -EmailAddress $upn `
    -Department 'Technicians' `
    -City (Get-Random -InputObject $City[0..3]) `
    -Verbose
}

foreach ($c in $CEO) {
    $split =    $c.split(' ')
    $sam =      ($split[0].Substring(0,1) + '.' + $split[1]).ToLower()
    $upn =      ($split[0].Substring(0,1) + '.' + $split[1] + '@' + $env:USERDNSDOMAIN).ToLower()
    New-ADUser `
    -Name $c `
    -GivenName $split[0] `
    -Surname $split[1] `
    -DisplayName $c `
    -Enabled $true `
    -AccountPassword (ConvertTo-SecureString -AsPlainText $userpw -Force) `
    -SamAccountName $sam `
    -UserPrincipalName $upn `
    -Path "OU=CEOs,DC=$sub,DC=$root" `
    -EmailAddress $upn `
    -Department 'CEOs' `
    -City (Get-Random -InputObject $City[0..3]) `
    -Verbose
}

# Add OU Users to Group
$CEOg = "OU=CEOs,DC=$sub,DC=$root"
$hrg = "OU=HR,DC=$sub,DC=$root"
$techg = "OU=Technicians,DC=$sub,DC=$root"
$HRg = "OU=HR,DC=$sub,DC=$root"

Get-ADUser -Filter * -SearchBase $CEOg | 
ForEach-Object {Add-ADGroupMember -Identity CEOs -Members $_ -Verbose}

Get-ADUser -Filter * -SearchBase $hrg | 
ForEach-Object {Add-ADGroupMember -Identity HR -Members $_ -Verbose}

Get-ADUser -Filter * -SearchBase $techg | 
ForEach-Object {Add-ADGroupMember -Identity Technicians -Members $_ -Verbose}

Get-ADUser -Filter * -SearchBase $HRg | 
ForEach-Object {Add-ADGroupMember -Identity HR -Members $_ -Verbose}

Start-Process dsa.msc

#--------------------------------------------------------------------------------------------------------

# Remove Test Environment
$domainname = $env:USERDNSDOMAIN
$sub = $domainname.Split('.')[0]
$root = $domainname.Split('.')[1]
$OUs = 'HR','Technicians','CEOs','Groups'

foreach ($u in $OUs) {
    Set-ADOrganizationalUnit -Identity "OU=$u,DC=$sub,DC=$root" -ProtectedFromAccidentalDeletion $false -Verbose -ErrorAction SilentlyContinue
    Remove-ADOrganizationalUnit -Identity "OU=$u,DC=$sub,DC=$root" -Recursive -Confirm:$false -Verbose -ErrorAction SilentlyContinue
}
