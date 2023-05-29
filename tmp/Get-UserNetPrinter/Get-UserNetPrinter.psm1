function Get-UserNetPrinter {
    <#
        .SYNOPSIS
            Get all the Network Printers from the Registry
            Requires Remote Registry access on the remote machine
 
        .DESCRIPTION
            Extract a list of all Print-Server Printers that a computer is using.
            These are not the same as direct install printers. For that, WMI is easier
 
 
        .PARAMETER ComputerName
            A computer or array of computers
 
        .EXAMPLE
            Get-UserNetPrinter $(hostname)
 
        DESCRIPTION
        ------------
            Get all the installed printers on the current machine
 
 
        OUTPUT
        ------------
            Returns Computer Printer Details as an object
 
            E.g:
 
            computer         : ComputerName
            user             : Domain\User
            printServer      : PrintServerName
            printer          : PrinterName
            pringerGUID      : {ABCDE-FGH-1234-5678-ABCDEFGHI}
            printerDesc      : 
            printerDriver    : XX V123
            printerLocation  : 
            printerPortName  : 192.168.254.254
            printerShareName : PrinterSharedName
            printerSpooling  : PrintAfterSpooled
            printerPriority  : 1
            printerUNC       : \\UNC\PATH\GOES\HERE
            printerDefault   : 
 
 
 
        .NOTES
            Author: Pessimist__Prime for Reddit
            Last-Edit-Date: 14/06/2017
 
 
            Changelog:
            14/06/2017 - Initial Script
            14/06/2017 - Adam Mnich added default printer
 
 
    #>
 
 
    [CmdletBinding()]
    PARAM(
        [Parameter(ValueFromPipelineByPropertyName = $true, Position = 0)]        
        [string[]]$computerName = $env:ComputerName
    )
    begin {
        #Return the script name when running verbose, makes it tidier
        write-verbose "===========Executing $($MyInvocation.InvocationName)==========="
        #Return the sent variables when running debug
        Write-Debug "BoundParams: $($MyInvocation.BoundParameters|Out-String)"
        $regexPrinter = "\\\\.*\\(.*)$"
        $regexPrinter2 =  "(\w*),"
        $regexPrinter3 = "\\\\.*\\(.*),winspool"
    }
 
    process {
        #Iterate through each computer passed to function
        foreach ($computer in $computerName) {
 
            write-verbose "Processing $computer"
            #Open the old remote registry
            $reglm = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.Registryhive]::LocalMachine, $computer)
            $regu = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.Registryhive]::Users, $computer)
            #Grab the USER SIDS, try and ignore service accounts and stuff
            $sids = ($regu.GetSubKeyNames() | Where-Object {($_ -notlike '*.DEFAULT*') -and ($_ -notlike "*classes*") -and ($_.length -ge 9)})
            foreach ($sid in $sids) {
                write-verbose "Processing UserSID:  $sid"
                $printersReg = $regu.OpenSubKey("$sid\printers\connections")
                $printerDefaultReg = $regu.OpenSubKey("$sid\printers\defaults")                             
                $DefaultPrinter = try {
                        ($regu.OpenSubKey("$sid\printers\defaults\$($printerDefaultReg.GetSubKeyNames())")).getvalue($null)
                    } 
                    catch {$null}
                if ($printerDefaultReg -eq $null){
                    $printerDefaultReg = $regu.OpenSubKey("$sid\Software\Microsoft\Windows NT\CurrentVersion\Windows")  
                    $DefaultPrinter = try {$printerDefaultReg.GetValue("Device")} catch {$null}
                }
                Write-Verbose "Default Printer $DefaultPrinter"
                if ($DefaultPrinter -match $regexPrinter3){
                    $DefaultPrinter = $Matches[1]
                }
                elseif ($DefaultPrinter -match $regexPrinter){
                    $DefaultPrinter = $Matches[1]
                }
                elseif ($DefaultPrinter -match $regexPrinter2){
                    $DefaultPrinter = $Matches[1]           
                }
                if (($printersReg -ne $null) -and ($printersReg.length -gt 0)) {
                    $printers = $printersReg.getsubkeynames()
                    #Try and get the username from the SID - Need to be the same domain
                    #Should change to a try-catch for different domains
                    $user = $($(New-Object System.Security.Principal.SecurityIdentifier($sid)).Translate([System.Security.Principal.NTAccount]).Value)
 
                    foreach ($printer in $printers) {
                        #Need to split the regkey name to get proper values
                        #Split 2 = Print server
                        #Split 3 = printer name
                        #Never seen a value in the 0 or 1 spots
                        $split = $printer.split(",")
                        $printerDetails = $regu.openSubKey("$SID\Printers\Connections\$printer")
                        $printerGUID = $printerDetails.getValue("GuidPrinter")
                        $spoolerPath = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider\Servers\$($split[2])\Printers\$printerGUID\DsSpooler"
                        $printSpooler = $reglm.OpenSubKey("$spoolerPath")
 
                        #Make an object to store in the array
                        $pdetails = [pscustomobject]@{
                            computer         = $computer
                            user             = $user
                            printServer      = $split[2]
                            printer          = $split[3]
                            pringerGUID      = $printerGUID
                            printerDesc      = $($printSpooler.getValue("description"))
                            printerDriver    = $($printSpooler.getValue("DriverName"))
                            printerLocation  = $($printSpooler.getValue("Location"))
                            printerPortName  = $($printSpooler.getValue("PortName"))
                            printerShareName = $($printSpooler.getValue("printShareName"))
                            printerSpooling  = $($printSpooler.getValue("printSpooling"))
                            printerPriority  = $($printSpooler.getValue("priority"))
                            printerUNC       = $($printSpooler.getValue("uNCName"))
                            printerDefault   = if ($split[3] -eq $DefaultPrinter){$true}
                        }                       
                        #Add the object to the array
                        $pdetails
                    }
                }
                else {
                    #Well, something didn't work on this computer entry
                    #This script could do with better error handling
                    write-verbose "No Access or No Printers"
                }
            }
        }
    }

    }

