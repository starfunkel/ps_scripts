### Github Management

function git-auto       {
                        
                        param([string]$message = "auto commit - nothing to special")

                        git add .
                        git commit -m $message
                        git push
                        Remove-Variable -Name message
}

function git-ps       {
                        
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
