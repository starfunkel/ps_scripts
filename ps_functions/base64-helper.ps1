function to-base64    {[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes('[0]'))}
function from-base64  {[Text.Encoding]::Utf8.GetString([Convert]::FromBase64String('[0]'))}