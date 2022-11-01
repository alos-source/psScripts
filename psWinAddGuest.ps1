Write-Host net user Besucher /add /active:yes
Write-Host net localgroup Benutzer Besucher /delete
Write-Host net localgroup HomeUsers Besucher /delete
Write-Host net localgroup Gäste Besucher /add