#requires -version 5.1

<#
    setup SSHD on Windows Server 2016
    https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH

    This script is designed to be run remotely using Invoke-Command

    Sample usage:
    Verbose and Whatif
    invoke-command -FilePath .\Setup-SSHServer2.ps1 -ComputerName srv1 -cred $admin -ArgumentList @("Continue",$True)

    Verbose
    invoke-command -FilePath .\Setup-SSHServer2.ps1 -ComputerName srv1 -cred $admin -ArgumentList @("Continue")
#>

[cmdletbinding(SupportsShouldProcess)]
Param([string]$VerboseOption = "SilentlyContinue", [bool]$WhatIfOption = $False)

$VerbosePreference = $VerboseOption
$WhatIfPreference = $WhatIfOption

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = 'https://github.com/PowerShell/Win32-OpenSSH/releases/latest/'
$request = [System.Net.WebRequest]::Create($url)
$request.AllowAutoRedirect = $false
$response = $request.GetResponse()
$dl = $([String]$response.GetResponseHeader("Location")).Replace('tag', 'download') + '/OpenSSH-Win64.zip'

$zip = "C:\OpenSSH64.zip"
Write-Verbose "download SSH from $dl to $zip"
if ($pscmdlet.ShouldProcess($dl,"Downloading OpenSSH-Win64 Package")) {
    Try {
        Invoke-WebRequest -Uri $dl -OutFile $zip -DisableKeepAlive -ErrorAction Stop
    }
    Catch {
        Throw $_
    }
    if (Test-Path $zip) {
        Write-Verbose "Extract zip file"
        Expand-Archive $zip -DestinationPath "c:\Program Files" -force
    }
    else {
        Return "zip file failed to download"
    }
}

Write-Verbose "Install SSH"
if ($pscmdlet.ShouldProcess("install-sshd.ps1", "Execute")) {
    Push-Location
    Set-Location -Path 'C:\Program Files\OpenSSH-Win64\'
    . .\install-sshd
    Pop-Location
}

Write-Verbose "Set sshd to auto start"
Try {
    if ($pscmdlet.ShouldProcess("sshd", "Configure service")) {
        Set-Service -Name sshd -StartupType Automatic -ErrorAction stop
        Write-Verbose "Start the sshd service"
        Start-Service -Name sshd -ErrorAction Stop
        Get-Service sshd | Select-Object -Property * | Out-String | Write-Verbose
    }
}
Catch {
    Write-Warning "There was a problem configuring the sshd service."
}

Write-Verbose "Add the firewall rule"
if ($pscmdlet.ShouldProcess("sshd", "Add firewall rule")) {
    Try {
        $rule = New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 -ErrorAction Stop
        Write-Verbose ($rule | Out-String)
    }
    Catch {
        Throw $_
    }
}

if (-Not $WhatIfOption) {
    #only display the summary if not using -WhatIf
    $msg = @"

SSH setup complete. Edit $ENV:ProgramData\ssh\sshd_config for additional configurations options
or to enable remoting under PowerShell 7.

You will need to restart the sshd service for changes to take effect.

"@
    Write-Host $msg -ForegroundColor green
}

Write-Verbose "Ending SSHD setup process."
