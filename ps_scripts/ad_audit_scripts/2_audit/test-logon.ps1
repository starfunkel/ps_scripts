# Define the target domain controller and the number of attempts
$dc = "ii-dc22-01"
$numberOfAttempts = 200

# Credentials (invalid username and password for failed logons)
$invalidUsername = "fakeuser"
$invalidPassword = "wrongpassword"

# Function to simulate a failed logon attempt by trying to map a network drive
function Test-Logon {
    param (
        [string]$dc,
        [string]$username,
        [string]$password
    )

    try {
        # Create a credential object with invalid credentials
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential($username, $securePassword)

        # Try to map a network drive to the admin share on the domain controller using invalid credentials
        New-PSDrive -Name Z -PSProvider FileSystem -Root "\\$dc\C$" -Credential $credential -ErrorAction Stop

        # If somehow successful (which shouldn't happen), remove the mapped drive
        Remove-PSDrive -Name Z -Force
    }
    catch {
        Write-Host "Failed logon attempt to $dc with user $username"
    }
}

# Loop to run the logon attempt multiple times
for ($i = 1; $i -le $numberOfAttempts; $i++) {
    Test-Logon -dc $dc -username $invalidUsername -password $invalidPassword
}