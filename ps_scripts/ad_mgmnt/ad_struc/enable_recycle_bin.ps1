### BEARBEITEN

$domain = (Get-ADDomainController).forest

Get-ADOptionalFeature -Filter { Name -eq "Recycle Bin Feature" }

Enable-ADOptionalFeature -Identity ‘CN=Recycle Bin Feature,CN=Optional Features,CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration,dc=one,dc=local’ -Scope ForestOrConfigurationSet -Target $domain
