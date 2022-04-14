### Github Management

function gitc       {
                        param([string]$message = "auto commit - nothing to special")

                        git add .
                        git commit -m $message
                        git push
}

function gitp       {
                        $p = (pwd).path
                        Set-Location $PSHOME

                        git add .\profile.ps1
                        git commit -m "Profile Updated"
                        git push
                        Set-Location $p
}