# Microsoft on prem AD, AAD, M365 Administration

# Ad-hoc AD on prem Info

# Gather and display AD user information
function adu    ( $USER ){ # Get AD User Info
        Write-Host ""
        Write-Host "---------------------------------------------------------------------------------" -InformationVariable LINEDELIMITERS
        Write-Host "User Info:"
        Get-ADUser $USER -Properties *  |
        Select-Object   SamAccountName, Displayname, distinguishedname, EmailAddress, `
                        OfficePhone, Enabled, lastlogondate, LastBadpasswordAttempt, `
                        BadLogonCount, PasswordLastSet, PasswordNeverExpires,SID
        $LINEDELIMITERS
        Write-Host ""
        Write-Host "Group memberships of $USER"
        get-adprincipalGROUPmembership -Identity $USER |
        Select-Object name, distinguishedName |
        Format-Table
        Sort-Object name
        Write-Host ""
        $LINEDELIMITERS
    }

# Gather and dusplay AD group information
function adg    ( $GROUP ){ # Get AD Group Info
        Write-Host ""
        Write-Host "---------------------------------------------------------------------------------" -InformationVariable LINEDELIMITERS
        Write-Host "Group Info:" 
        get-adGROUP $GROUP -Properties * |
        Select-Object   CN, DistinguishedName, SamAccountName, CanonicalName, GroupCategory, `
                        GroupScope, whenChanged, whenCreated, info, objectSid
        $LINEDELIMITERS
        Write-Host ""
        Write-Host "Group Member Info:"
        get-adGROUPmember $GROUP -Recursive -Server |
        Get-ADUser -Properties *  |
        Select-Object   SamAccountName, Displayname, Enabled, lastlogondate, `
                        LastBadpasswordAttempt, BadLogonCount, PasswordLastSet,`
                        PasswordNeverExpires, SID |
        Format-table    SamAccountName, Displayname, Enabled, lastlogondate, `
                        LastBadpasswordAttempt, BadLogonCount, PasswordLastSet, `
                        PasswordNeverExpires, SID
        $LINEDELIMITERS
        Write-Host ""
    }

# Gather and display AD computer information
function adc    ( $COMPUTER ){ # Get Ad Computer Info
        Write-Host ""
        Write-Host "---------------------------------------------------------------------------------" -InformationVariable LINEDELIMITERS
        Write-Host "Computer Info:"
        Get-ADComputer $COMPUTER -Properties * |
        Select-Object   Name , Enabled, ObjectCategory,  CanonicalName, `
                        PrimaryGroup, OperatingSystem, OperatingSystemVersion, IPv4Address,`
                        whenCreated, LastLogonDate, whenChanged, LastBadPasswordAttempt,`
                        logonCount, objectSid
        $LINEDELIMITERS
        Write-Host ""
    }

# Get ad group modifications (e.g. add / delete group memebr)
function gmc    ( $dc, $GROUPC ){
        $sid=(get-adgroup $GROUPC).SID |
        foreach {$_.Value}
        $sid2="<SID=$sid>"
        repadmin.exe /showobjmeta $dc $sid2
    }

# Azure AD 
