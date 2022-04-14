### Github Management

function git-auto       {
                        
                        param([string]$message = "auto commit - nothing to special")

                        git add .
                        git commit -m $message
                        git push
                        Remove-Variable -Name message
}

function git-ps       {



                            param([switch]$Elevated)
                        function Test-Admin{ # https://superuser.com/questions/108207/how-to-run-a-powershell-script-as-administrator
                        
                        $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
                        $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
                        } 

                        if ((Test-Admin) -eq $false)  {
                            if ($elevated) 
                            {
                                # tried to elevate, did not work, aborting
                            } 
                            else {
                                Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
                        }

                        exit
                        }
                        
                        $current_path = (pwd).path
                        Set-Location $PSHOME
                        git add .\profile.ps1
                        git commit -m "Profile Updated"
                        git push
                        Set-Location C:\support\code\_git-repos\POSH
                        git add .
                        git commit -m "Functions and Definitions Update"
                        git push
                        Set-Location $current_path
                        Remove-Variable -Name current_path
}
