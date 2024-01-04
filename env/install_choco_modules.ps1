# OpenSSL

choco install openssl
New-Item -ItemType Directory -Path C:\certs
Set-Location C:\certs
Invoke-WebRequest 'http://web.mit.edu/crypto/openssl.cnf' -OutFile .\openssl.cnf