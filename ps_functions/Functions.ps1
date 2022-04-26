<#
  .SYNOPSIS

  .DESCRIPTION

  .PARAMETER InputPath

  .PARAMETER OutputPath

  .INPUTS

  .OUTPUTS

  .EXAMPLE

  .EXAMPLE

  .EXAMPLE
#>
### Funcions

### Compute file hashes 
function md5        { Get-FileHash -Algorithm MD5 $args }
function sha1       { Get-FileHash -Algorithm SHA1 $args }
function sha256     { Get-FileHash -Algorithm SHA256 $args }


### Bash like commands
function pwd        { Get-Location }
function ll         { Get-Childitem | Sort-Object -Property LastWriteTime }
function help       { get-help $args[0] | out-host -paging }
function man        { get-help $args[0] -Full | out-host -paging }
function cat        { get-content $args[0] }
function less       { get-content $args[0] | out-host -paging }
function find       { Get-Childitem -Filter $args[0] -Recurse -File | out-host -paging }

function uname      { $PROPERTIES = 'Caption', 'CSName', 'Version', 'BuildType', 'OSArchitecture'; Get-CimInstance Win32_OperatingSystem | 
                        Select-Object $PROPERTIES |
                         Format-Table -AutoSize 
                    }
                    
function history    { get-history -Count 20 }

function imp        { Import-Module $args[0] }
function touch      { New-Item $args[0] }
function aterm      { Start-Process wt.exe -Verb runAs }

### Custom functions
function pong       { Test-Connection $args[0] | Format-Table -Autosize } 

function ToBase64   {[Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes("$args[0]"))}

<#
function FromBase64 { $string=}

{[System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String("$args[0]"))}

#>

function ip         { $env:externalip = ( # gets external $ internal IPs of Localhost
                        Invoke-WebRequest "ifconfig.me/ip").Content;
                        $LOCALIPADRESS = ((ipconfig | findstr [0-9].\.)[0]).Split()[-1]
                        Write-host ""
                        Write-Output "External IP:"; 
                        $env:externalip;
                        Write-host ""
                        Write-Host "Internal IP:"
                        $LOCALIPADRESS
                        Write-host ""
                    }

### Reload profile https: //itenium.be/blog/dev-setup/powershell-profiles/
function rel        {
    @(
        $Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost
    ) | ForEach-Object {
        if (Test-Path $_) {
            Write-Verbose "Reloading $_"
            . $_
        }
    }
}

### Get Windows ACL Information  https: //exchangepedia.com/2017/11/get-file-or-FOLDER-permissions-using-powershell.html

function gacl       ( $FOLDER ) { 
        (get-acl $FOLDER).access | Select-Object `
          @{Label="Identity";Expression={$_.IdentityReference}}, `
          @{Label="Right";Expression={$_.FileSystemRights}}, `
          @{Label="Access";Expression={$_.AccessControlType}}, `
          @{Label="Inherited";Expression={$_.IsInherited}}, `
          @{Label="Inheritance Flags";Expression={$_.InheritanceFlags}}, `
          @{Label="Propagation Flags";Expression={$_.PropagationFlags}} | Format-Table -auto
          }