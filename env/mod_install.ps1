$Green = @{ "ForegroundColor" = "Green" } 
$Yellow = @{ "ForegroundColor" = "Yellow" } 
$Red = @{ "ForegroundColor" = "Red" } 
$Cyan = @{ "ForegroundColor" = "Cyan" }

# RSAT - Install Remote Server Administration Tools
if(Get-WindowsCapability -online | where-object Name -Match "RSAT")   
    else{Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online}

# AzureAD - Connect to the AzureAD service. Install the module if needed. 
if (Get-Module -ListAvailable -Name AzureAD) { 
    Write-Host "Conneting to Azure AD Online Service" @Green 
    Connect-AzureAD
    }
else { 
    Write-Host "AzureAD required. Now installing" @Yellow 
    Install-Module -Name AzureAD -Scope AllUsers -Force 
    Write-Host "Conneting to Azure AD Online Service" @Cyan 
    Connect-AzureAD 
    }

# ExchangeOnline - Connect to the Exchange Online Service. Install the module if needed. 
if (Get-Module -ListAvailable -Name ExchangeOnlineManagement) { 
    Write-Host "Conneting to Exchange Online Service" @Green 
    Connect-ExchangeOnline 
    }
else { 
    Write-Host "ExchangeOnline required. Now installing" @Yellow
    Install-Module -Name ExchangeOnlineManagement -Scope AllUsers -Force
    Write-Host "Conneting to Exchange Online Service" @Cyan 
    Connect-ExchangeOnline 
    }

# Optional - VMWare PowerCli
function install-powercli (
    if(get-Module -ListAvailable  -name vmware*){  
        Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false
        set-PowerCLIConfiguration -invalidcertificateaction  ignore 
    }
    else{
        Install-Module -Name VMware.PowerCLI
        set-PowerCLIConfiguration -invalidcertificateaction  ignore
    }
)

function install-sharepoint (

    $AdminSiteURL = $(Write-Host "Enter the new SharePoint admin domain." u/Green -NoNewLine)`
    + $(Write-Host " (i.e. 'conteso-admin.sharepoint.com'): " @Yellow -NoNewLine; Read-Host)

    if (Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell) { 
        Write-Host "Connecting to SharePoint Online Service" @Green 
        Connect-SPOService -Url $AdminSiteURL 
        }
    else { 
        Write-Host "MSOnline required. Now installing" @Yellow 
        Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Scope AllUsers -Force 
        Write-Host "Conneting to SharePoint Online Service" @Cyan 
        Connect-SPOService -Url $AdminSiteURL 
        }
)

function install-dsinternals (
    Install-Module -Name DSInternals -Force
)