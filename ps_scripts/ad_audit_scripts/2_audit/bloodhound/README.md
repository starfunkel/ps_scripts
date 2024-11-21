## bloodhound eval

- neo4j hat bei mir unter Windows nicht funktioniert, deswegen habe ich dafür WSL benutzt.

### install
https://debian.neo4j.com/

# Dies ist unsicher und sollte nur zum Testen benutzt werden
# In WSL
nano /etc/neo4j/neo4j.conf
# Zeile 71 auskommentieren
dbms.default_listen_address=0.0.0.0


### run

in wsl
./neo4j console

in bloodhound dir
.\BloodHound.exe -no-sandbox

in browser open
http://localhost:7474/browser/


# Bloodhound Queries
MATCH p=shortestPath((m:User)-[r:MemberOf*1..]->(n:Group))
WHERE n.name = "Administratoren"
WITH m MATCH q=((m)<-[:HasSession]-(o:Computer)) 
RETURN count(o)

SHORTEST PATH

Logik: From --> TO 

MATCH (n:User {objectid: "S-1-5-21-1757981266-1682526488-854245398-14631"}) MATCH (m:User {objectid: "S-1-5-21-1757981266-1682526488-854245398-3186"}) MATCH p=allShortestPaths((n)-[r:{}*1..]->(m)) RETURN p

# Azurehound

$body = @{
    "client_id" =     "1950a258-227b-4e31-a9cf-717495945fc2"
    "resource" =      "https://graph.microsoft.com"
}
$UserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36"
$Headers=@{}
$Headers["User-Agent"] = $UserAgent
$authResponse = Invoke-RestMethod `
    -UseBasicParsing `
    -Method Post `
    -Uri "https://login.microsoftonline.com/common/oauth2/devicecode?api-version=1.0" `
    -Headers $Headers `
    -Body $body
$authResponse

## Follow instructions !!!

# Do

$body=@{
    "client_id" =  "1950a258-227b-4e31-a9cf-717495945fc2"
    "grant_type" = "urn:ietf:params:oauth:grant-type:device_code"
    "code" =       $authResponse.device_code
}
$Tokens = Invoke-RestMethod `
    -UseBasicParsing `
    -Method Post `
    -Uri "https://login.microsoftonline.com/Common/oauth2/token?api-version=1.0" `
    -Headers $Headers `
    -Body $body
$Tokens

## grep refresh_token

./azurehound -r "0.ARwA6Wg..." list --tenant "$TENENT.onmicrosoft.com" -o output.json

# AD-miner

AD-miner.exe  -cf iit_ad -b bolt://localhost:7687 -u neo4j -p 