REM create a copy of the ntds.dit using the IFM (install from media) method
REM monitor for this - it could be a crim if its not authorised activity

ntdsutil "activate instance ntds" "ifm" "create full $PSScriptRoot\Audit\pw_audit_2024\SYSTEM" q q
