$dir = (Get-Item -Path c:\admin\pdates -Verbose).FullName
Foreach($item in (ls $dir *.msu -Name))
{
echo $item
$item = $dir + "\" + $item
wusa $item /quiet /norestart | Out-Null
}