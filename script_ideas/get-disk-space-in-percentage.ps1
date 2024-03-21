get-psdrive c | % { $_.free/($_.used + $_.free) } | % tostring p
