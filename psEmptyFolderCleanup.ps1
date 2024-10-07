# Pfad des Verzeichnisses
$path = "C:\Users\..."

# Hole alle leeren Ordner
$emptyFolders = Get-ChildItem -Path $path -Recurse -Directory | Where-Object {($_.GetFileSystemInfos()).Count -eq 0}

# Begrenze die Anzahl der Ordner auf 500
$foldersToProcess = $emptyFolders | Select-Object -First 500

# Zeige gefundene Ordner an
if ($foldersToProcess.Count -eq 0) {
    Write-Host "Keine leeren Ordner gefunden."
} else {
    Write-Host "Gefundene leere Ordner (maximal 500):"
    $foldersToProcess | ForEach-Object { Write-Host $_.FullName }

    # Frage nach Bestätigung zum Löschen
    $confirmation = Read-Host "Möchtest du diese Ordner löschen? (ja/j/y/yes)"
    
    # Akzeptiere verschiedene Bestätigungen (ja, j, y, yes)
    if ($confirmation -in @("ja", "j", "y", "yes")) {
        # Zähler für gelöschte Ordner
        $deletedCount = 0
        
        $foldersToProcess | ForEach-Object {
            Remove-Item $_.FullName -Force
            Write-Host "Gelöscht:" $_.FullName
            $deletedCount++
        }

        Write-Host "$deletedCount Ordner wurden erfolgreich gelöscht."
    } else {
        Write-Host "Löschvorgang abgebrochen."
    }
}