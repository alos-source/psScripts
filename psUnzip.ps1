$archives = gci -Recurse -filter *.zip
foreach ($archives in $archives){Expand-Archive -Path $archives -DestinationPath $archives.Directory -force}
$archives = gci -Recurse -filter *.zip
Remove-Item -Path $archives