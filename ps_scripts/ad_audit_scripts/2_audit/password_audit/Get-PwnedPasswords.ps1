# https://4sysops.com/archives/find-compromised-passwords-in-active-directory-with-have-i-been-pwned/

Import-Module DSInternals
# Get users who have changed their password after a certain date
$user = Get-ADUser -Properties PasswordLastSet -Filter "PasswordLastSet -gt '08/21/2023'"
# Request the credentials of the user who will fetch the password hashes
$cred = Get-Credential

$user | foreach{
    $hash=""
    "`nChecking password for: " + $_.SamAccountName
    $r = Get-ADReplAccount -SamAccountName $_.SamAccountName -Domain contoso -Server dc1 -Credential $cred -Protocol TCP
    #Turn byte array into a hex string
    $r.NTHash |foreach{
        $hash += ([Convert]::ToString($_,16)).padleft(2,"0")
    }
    #Calling Web API passing the first five chars of the hash
    $pwned = Invoke-WebRequest -UseBasicParsing -Uri ("https://api.pwnedpasswords.com/range/" + $hash.substring(0,5) + "?mode=ntlm")
    #Look up hash in the response from haveIbeenpwned
    if($pwned.Content.ToLower().contains($hash.substring(5))){
        "`nPassword for " + $r.DisplayName + " is compromised!"
    }
}