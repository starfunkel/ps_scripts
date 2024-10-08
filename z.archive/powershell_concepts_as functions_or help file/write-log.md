```powershell
function Write-Log # https://gallery.technet.microsoft.com/scriptcenter/Write-Log-PowerShell-999c32d0
{
    #Log Funktion Besipiele
#.EXAMPLE
#   Write-Log -Message 'Log message' 
#   Writes the message to c:\Logs\PowerShellLog.log.
#.EXAMPLE
#   Write-Log -Message 'Restarting Server.' -Path c:\Logs\Scriptoutput.log
#   Writes the content to the specified log file and creates the path and file specified. 
#.EXAMPLE
#   Write-Log -Message 'Folder does not exist.' -Path c:\Logs\Script.log -Level Error
        
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("LogContent")]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [Alias('LogPath')]
        [string]$Path='C:\support\logs\Pers_log.txt', # Pfad angepasst
        
        [Parameter(Mandatory=$false)]
        [ValidateSet("Error","Warnung","Info")]
        [string]$Level="Info",
        
        [Parameter(Mandatory=$false)]
        [switch]$NoClobber
    )

    Begin
    {
        # Set VerbosePreference to Continue so that verbose messages are displayed.
        $VerbosePreference = 'Continue'
    }
    Process
    {
        
        # If the file already exists and NoClobber was specified, do not write to the log.
        if ((Test-Path $Path) -AND $NoClobber) {
            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name."
            Return
            }

        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path.
        elseif (!(Test-Path $Path)) {
            Write-Verbose "Creating $Path."
            $NewLogFile = New-Item $Path -Force -ItemType File
            }

        else {
            # Nothing to see here yet.
            }


        # Make Path outside available

      #  $owrite = New-Object -TypeName psobject
      #  Add-Member -InputObject $owrite -MemberType NoteProperty -Name owrite -Value $Path $obj,

        # Format Date for our Log File
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        # Write message to error, warning, or verbose pipeline and specify $LevelText
        switch ($Level) {
            'Error' {
                Write-Error $Message
                $LevelText = 'ERROR:'
                }
            'Warn' {
                Write-Warning $Message
                $LevelText = 'WARNING:'
                }
            'Info' {
                Write-Verbose $Message # Verbose Nachrichten an oder aus machen
                $LevelText = 'INFO:'
                }
            }
        
        # Write log entry to $Path
        "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path -Append
    }
    End
    {
    }
}
```