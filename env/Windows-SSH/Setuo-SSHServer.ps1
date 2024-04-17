#requires -version 5.1

#Deployment control script to setup SSH server on a remote Windows 10 desktop
#It is assumed PowerShell 7 is, or will be, installed.

[cmdletbinding(SupportsShouldProcess)]
Param(
    [Parameter(Position = 0, Mandatory)]
    [string]$Computername,
    [pscredential]$Credential,
    [switch]$InstallPowerShell
)

#remove parameters from PSBoundparameter that don't apply to New-PSSession
if ($PSBoundParameters.ContainsKey("InstallPowerShell")) {
    [void]($PSBoundParameters.remove("InstallPowerShell"))
}

if ($PSBoundParameters.ContainsKey("WhatIf")) {
    [void]($PSBoundParameters.remove("WhatIf"))
}

#parameters for Write-Progress
$prog = @{
    Activity = "Deploy SSH Server to Windows 10"
    Status = $Computername.toUpper()
    CurrentOperation = ""
    PercentComplete = 0
}
#create the PSSession
Try {
    Write-Verbose "Creating a PSSession to $Computername"
    $prog.CurrentOperation = "Creating a temporary PSSession"
    $prog.PercentComplete = 10
    Write-Progress @prog
    $sess = New-PSSession @PSBoundParameters -ErrorAction Stop
}
Catch {
    Throw $_
}

if ($sess) {
    if ($InstallPowerShell) {
        $prog.currentOperation = "Installing PowerShell 7"
        $prog.percentComplete = 25
        Write-Progress @prog
        #install PowerShell
        if ($pscmdlet.ShouldProcess($Computername.toUpper(),"Install PowerShell 7")) {

            Invoke-Command -ScriptBlock {
                [void](Install-PackageProvider -Name nuget -force -forcebootstrap)
                Install-Module PSReleaseTools -Force
                Install-PowerShell -EnableRemoting -EnableContextMenu -mode Quiet
            } -session $sess
        } #whatif
    }

    #setup SSH
    $prog.currentOperation = "Installing OpenSSH Server"
    $prog.percentComplete = 50
    Write-Progress @prog
    Invoke-Command -FilePath .\Setup-SSHServer.ps1 -Session $sess -ArgumentList @($VerbosePreference, $WhatIfPreference)

    #copy the sshd_config file. This assumes you've installed PowerShell 7 on the remote computer
    Write-Verbose "Copying sshd_config to target"
    $prog.currentOperation = "Copying default sshd_config to target"
    $prog.percentcomplete = 60
    Write-Progress @prog
    Copy-Item -Path .\sshd_config_default -Destination $env:ProgramData\ssh\sshd_config -ToSession $sess

    #restart the service
    Write-Verbose "Restarting the sshd service on the target"
    $prog.currentOperation = "Restarting the ssh service target"
    $prog.percentComplete = 75
    Write-Progress @prog
    if ($pscmdlet.ShouldProcess("sshd","Restart service")) {
        Invoke-Command { Restart-Service -Name sshd } -Session $sess
    }

    Write-Verbose "Removing the temporary PSSession"
    $prog.currentOperation = "Removing temporary PSSession"
    $prog.percentComplete = 90
    Write-Progress @prog
    $sess | Remove-PSSession

    Write-Progress @prog -completed
    $msg = @"

SSH Server deployment complete for $($Computername.toUpper()).

If PowerShell 7 is installed remotely, you should be able to test
with an expression like:

Enter-PSSession -hostname $Computername -username <user> -sshtransport

"@

    Write-Host $msg -ForegroundColor yellow
} #if $sess
