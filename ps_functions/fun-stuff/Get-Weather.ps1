    # Get the weather
function getw   {
    (Invoke-WebRequest http://wttr.in/:Berlin?0M -UserAgent "curl" -ErrorAction SilentlyContinue ).Content
}
