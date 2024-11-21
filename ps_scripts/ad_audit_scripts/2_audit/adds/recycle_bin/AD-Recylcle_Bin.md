### Get deleted AD-Users

##### Chekc if AD Recycle Bin is activated
```powershell
Get-ADOptionalFeature "Recycle Bin Feature" | select-object name, EnabledScopes
```
##### If not Check the Forest Mode (<2k8 is required)
```powershell
Get-ADForest | select-object ForestMode|fl
```

##### Enable Recycle Bin
```powershell
Enable-ADOptionalFeature 'Recycle Bin Feature' -Scope ForestOrConfigurationSet -Target domain.local
```