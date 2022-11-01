$logfilepath="./Log.txt"
$files = gci -Recurse -filter *.pdf -Path ./input/
$TESTMODE = 0
$ERRORCOUNT = 0
$GOODCOUNT = 0
#$objects = New-Object PSObject
#enum TITLES {
#    "Cash Account Statement"
#    "Securities Settlement"
#}
$TYPES = Import-CSV -Path ./TYPES.CSV -Delimiter ";"
Write-Output = "Types :" $TYPES
Write-Output = "Files: "$files
Write-Output = "Processing" $files.count "Files"
Write-Output = "Testmode: "$TESTMODE

Write-Output "========================" | Out-File -Append -Filepath $logfilepath
Get-Date | Out-File -Append -Filepath $logfilepath

foreach ($files in $files){

$Title = ((pdfinfo ./input/$files) -split '\n') |
    Select-Object @{Name='Data'; Expression = {$_ -split ':\s+'}} |
    Select-Object @{
            Name='Key';
            Expression = {$_.Data[0]}
        },
        @{
            Name='Value';
            Expression = {$_.Data[1]}
        } |
    Where-Object { $_.Key -eq 'Title' } |
    Select -ExpandProperty Value

 Write-Output "Found File: $files, Title: $Title" | Out-File -Append -Filepath $logfilepath


    if (Test-Path -Path ./output/$Title/) {
    "Path exists!"
    $GOODCOUNT++ 
            if ($TESTMODE -eq 1)
        {Write-Output "TESTMODE"}
    else{
     Move-Item ./input/$files ./output/$Title/$files
    }    

} else {
    "Path doesn't exist." | Out-File -Append -Filepath $logfilepath
    $ERRORCOUNT ++
            if ($TESTMODE -eq 1)
        {Write-Output "TESTMODE"}
    
    else{
    Move-Item ./input/$files ./output/$files
    }    
}

#$objects | Add-Member NoteProperty $Title $files
 }


Write-Output "Finished"
Write-Output "errors: "$ERRORCOUNT| Out-File -Append -Filepath $logfilepath
Write-Output "Files in Folders: "$GOODCOUNT| Out-File -Append -Filepath $logfilepath
#Write-Output $objects
#Write-Output [TITLES].GetEnumNames()