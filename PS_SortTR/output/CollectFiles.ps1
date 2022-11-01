$FILES = Get-ChildItem -Path ./ -Include *.pdf -File -Recurse | Write-Output
foreach ($FILES in $FILES) { 
    Move-Item ./$FILES  ./collected/$FILES 
    }