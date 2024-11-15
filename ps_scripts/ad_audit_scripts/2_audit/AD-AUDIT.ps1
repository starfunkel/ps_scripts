##############################################################
##                                                          ##
##  |_ _|_ __ | |_ ___  __ _ _ __ __ _| |_ ___      (_) |_  ##
##   | || '_ \| __/ _ \/ _` | '__/ _` | __/ _ \_____| | __| ##
##   | || | | | ||  __/ (_| | | | (_| | ||  __/_____| | |_  ##
## |___|_| |_|\__\___|\__, |_|  \__,_|\__\___|     |_|\__|  ##
##                    |___/                                 ##
##                                                          ##
##                      cc 24/11                            ##
##                                                          ##
##              AD Audit script                             ##
##############################################################

############
# Varibles #
############

# Define path for export
$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
$RootDirectory = "AD_AUDIT"
$DirectoryName = "AUDIT_$((Get-Date).ToString('yyyy-MM-dd'))"
$AuditFolder = Join-Path -Path (Join-Path -Path $DesktopPath -Childpath $RootDirectory) -Childpath $DirectoryName

# Set date to audit (used for lastlogon attr.)
$Date = ((get-date).adddays(-90))

# Default ad-user parameter values
$PSDefaultParameterValues['Get-ADUser:Properties'] = @(
    'SID',    
    'DisplayName',
    'Description',
    'DistinguishedName',
    'CN',
    'EmailAddress',
    'Description',
    'Created',
    'LockedOut',
    'adminCount',
    'telephoneNumber',
    'PasswordLastSet',
    'PasswordExpired',
    'LastBadPasswordAttempt',
    'LastLogonDate',
    'ProxyAddresses',
    'servicePrincipalName',
    'whenCreated'
)

# Default ad-group parameter values
$PSDefaultParameterValues['Get-ADgroup:Properties'] = @(
    'SID',
    'DisplayName',
    'Description',
    'DistinguishedName',
    'CN',
    'Description',
    'Created',
    'whenCreated'
)

# Default ad-computer parameter values
$PSDefaultParameterValues['Get-ADComputer:Properties'] = @(
    'SID',
    'Name',
    'Description',
    'DistinguishedName',
    'CN',
    'Description',
    'SamAccountName',
    'isCriticalSystemObject',
    'KerberosEncryptionType',
    'OperatingSystemVersion',
    'TrustedForDelegation',
    'PasswordExpired',
    'Created',
    'LastLogonDate',
    'whenCreated'
)

# CSV exporting needs special treatment
$PSDefaultParameterValues = @{
    'Export-Csv:NoTypeInformation' = $true
    'Export-Csv:Encoding'          = 'UTF8'
}

# Action!

$WELCOME = @"
##############################################################
##                                                          ##
##   _       _                       _             _ _      ##
##  (_)_ __ | |_ ___  __ _ _ __ __ _| |_ ___      (_) |_    ##
##  | | '_ \| __/ _ \/ _ ` |'__/  _`  | __/ _ \_____| | __|   ##
##  | | | | | ||  __/ (_| | | | (_| | ||  __/_____| | |_    ##
##  |_|_| |_|\__\___|\__, |_|  \__,_|\__\___|     |_|\__|   ##
##                    |___/                                 ##
##                                                          ##
##               cc 24/11 | integrate.net                   ##
##                                                          ##
##                  AD Audit script                         ##
##                                                          ##
##############################################################


"@
Write-Host 
Write-Host 
Write-Host $WELCOME -ForegroundColor green 
Write-Host "This script gathers AD Admin related information from AD and"
Write-Host "export it to"
Write-Host ${AuditFolder} -ForegroundColor yellow

# Check if the folder already exists
Write-Host
Write-Host
Write-Host "Lets check if our csv target folder is already created"
Write-Host
if (Test-Path -Path $AuditFolder) {
    Write-Host "$AuditFolder already exists!" -ForegroundColor yellow 
    Write-Host "We will rename it and create a new audit folder." -ForegroundColor yellow
    
    # Get the creation time of the existing folder
    $OldAuditFolderDate = (Get-Item $AuditFolder).CreationTime.ToString('yyyy-MM-dd-HH-mm')
    $OldAuditFolderName = "AD_AUDIT_$OldAuditFolderDate"

    # Rename the old folder
    Rename-Item -Path $AuditFolder -NewName (Join-Path -Path (Split-Path $AuditFolder) -ChildPath $OldAuditFolderName)

    # Create a new folder
    New-Item -Path $AuditFolder -ItemType Directory | Out-Null
    Write-Host "A new audit folder has been created:" -ForegroundColor green
    Write-Host "$AuditFolder" -ForegroundColor green
    Write-Host
} else {
    # If the folder doesn't exist, create it
    Write-Host "Creating audit folder: $AuditFolder" -ForegroundColor green
    New-Item -Path $AuditFolder -ItemType Directory | Out-Null
}

#########
# Users #
#########

Write-Host
Write-Host

## Get all user Accounts which logged on in the last x- days and who do not need to change their password
Write-Host "Targeting user who are not required to change their passwords and haven't logged on since ${Date)}" -ForegroundColor yellow
get-ADUser  -Filter 'passwordNeverExpires -eq "false" -and lastlogondate -ne "$null and $_.lastlogondate -le $Date"' |
Export-Csv $AuditFolder\All_Users_password_expiration_status.csv
Write-Host "All_Users_password_expiration_status.csv written" -ForegroundColor green
Write-Host
Write-Host

## Get all user accounts which have the admincount set to 1 and are eligible
Write-Host "Targeting users who have the admincount set to 1 and are eligible" -ForegroundColor yellow
Get-ADUser -Filter  "admincount -eq 1 -and AccountNotDelegated -eq '$false'" | 
Export-Csv $AuditFolder\Enabled_Users_with_set-admincount_and_eligible.csv
Write-Host "Enabled_Users_with_set-admincount_and_eligible.csv written" -ForegroundColor green
Write-Host
Write-Host

## Get old IIS related users
Write-Host "Targeting IUS Users" -ForegroundColor yellow
get-ADUser -Filter {name -like "IUS*"} |
Export-Csv $AuditFolder\IUS_User_Accounts.csv
Write-Host "IUS_User_Accounts.csv written" -ForegroundColor green
Write-Host
Write-Host

##get old IWAM related users
Write-Host "Targeting IWAM Users" -ForegroundColor yellow
get-ADUser -Filter {name -like "IWAM*"} |
Export-Csv $AuditFolder\IWAM_User_Accounts.csv
Write-Host "IUS_User_Accounts.csv written" -ForegroundColor green
Write-Host
Write-Host

## Get disblaed user ho haven't logged on since the last $Date
Write-Host "Targeting inactive users who haven't logged on in since ${Date}" -ForegroundColor yellow
Get-ADUser -Filter {enabled -eq $false -and lastlogondate -ne "$null and $_.lastlogondate -le $Date"} |
Export-Csv $AuditFolder\Old_Disabled_Users_Accounts.csv
Write-Host "Old_Disabled_Users_Accounts.csv written" -ForegroundColor green
Write-Host
Write-Host

## Get enabled user ho haven't logged on since the last $Date
Write-Host "Targeting active users who haven't logged on in since ${Date}" -ForegroundColor yellow
Get-ADUser -Filter {enabled -eq $true -and lastlogondate -ne "$null and $_.lastlogondate -le $Date"} |
Export-Csv $AuditFolder\Old_Enabled_Users_Accounts.csv
Write-Host "Old_Enabled_Users_Accounts.csv written" -ForegroundColor green
Write-Host
Write-Host

##########
# Groups #
##########

## Get all AD-Groups which have the admincount set to 1
Write-Host "Targeting AD groups which have an admincount flag set to 1" -ForegroundColor yellow
Get-ADGroup -LDAPFilter "(admincount=1)" |
Export-Csv $AuditFolder\Groups_with_set-admincount.csv
Write-Host "Groups_with_set-admincount.csv written" -ForegroundColor green
Write-Host
Write-Host

#######
# SPN #
########

## User SPNs
Write-Host "Targeting user SPNs" -ForegroundColor yellow
Get-ADUser -Filter {ServicePrincipalName -like "*"}  | 
Export-Csv $AuditFolder\User-SPN.csv
Write-Host "User-SPN.csv written" -ForegroundColor green
Write-Host
Write-Host

## Computer SPNs
Write-Host "Targeting computer SPNs" -ForegroundColor yellow
Get-ADComputer -Filter {ServicePrincipalName -like "*"} -Property ServicePrincipalName |
Export-Csv $AuditFolder\Computer-SPN.csv
Write-Host "Computer-SPN.csv written" -ForegroundColor green
Write-Host
Write-Host
Write-Host "Finished"