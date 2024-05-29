get-aduser -filter * -prop lastbadpasswordattempt,badpwdcount |
select-object name,lastbadpasswordattempt,badpwdcount |
format-table -auto 