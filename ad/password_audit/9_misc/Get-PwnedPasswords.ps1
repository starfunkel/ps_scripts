# The stdouts pwned User's in a given domain on a given DC
#
# Source 
# https://4sysops.com/archives/find-compromised-passwords-in-active-directory-with-have-i-been-pwned/

Import-Module DSInternals
# Get users who have changed their password after a certain date
$user = Get-ADUser -Filter * #-Properties PasswordLastSet #-Filter "PasswordLastSet -gt '08/21/2023'"
# Request the credentials of the user who will fetch the password hashes
# $cred = Get-Credential
#
# Define domain and DC
$domain = 
$srv = 

$user | ForEach-Object{
    $hash=""
    "`nChecking password for: " + $_.SamAccountName
    $r = Get-ADReplAccount -SamAccountName $_.SamAccountName -Domain $domain -Server $srv -Protocol TCP # -Credential $cred
    #Turn byte array into a hex string
    $r.NTHash |ForEach-Object{
        $hash += ([Convert]::ToString($_,16)).padleft(2,"0")
    }
    #Calling Web API passing the first five chars of the hash
    $pwned = Invoke-WebRequest -UseBasicParsing -Uri ("https://api.pwnedpasswords.com/range/" + $hash.substring(0,5) + "?mode=ntlm")
    #Look up hash in the response from haveIbeenpwned
    if($pwned.Content.ToLower().contains($hash.substring(5))){
        "`nPassword for " + $r.DisplayName + " is compromised!"
    }
}