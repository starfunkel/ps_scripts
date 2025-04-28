$user=Read-Host "Gimme login: "
$password=Read-Host "Gimme  new password: "
Set-ADAccountPassword -Identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $password -Force) -Credential
Read-Host "The password is set!"
