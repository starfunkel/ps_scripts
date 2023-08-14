<# Should be in $Profile #>

powershell -noprofile -noexit -command "invoke-expression '. ''C:\support\code\git-repos\starfunkel\powershell_stuff\ps_profile\profile.ps1''' "

# Set-ExecutionPolicy -ExecutionPolicy remotesigned -Scope CurrentUser