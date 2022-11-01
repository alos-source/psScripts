$myUserPath=$Env:userprofile+"\SynologyDrive\Dokumente\Projekte\SpeicherInventar\"
$myFileExt=".txt"
$inventarDrive="E:"
$inventarNameFile='\.inventar\inventar.name'
$lostAndFoundFile='\lostAndfound.txt'

if(Test-Path ($inventarDrive+$lostAndFoundFile)) { #write lost and found file to disk
    Write-Output "lost&found file available"
}
else {
    #copy-item C:\Users\alex\Documents\Projekte\Skripte\speicherInventar\festplattenordner\lostAndFound.txt -Recurse "E:\"
    copy-item $PSScriptRoot"\festplattenordner\lostAndFound.txt" -Recurse "D:\"
    Write-Output "no lost&found file available, created new"
}


if(Test-Path ($inventarDrive+$inventarNameFile)) { #write inventary name on the device
    $inventarName = Get-Content ($inventarDrive+$inventarNameFile) #Read DeviceName from Device, must be available and unique
}
else {
    copy-item $PSScriptRoot"\festplattenordner\.inventar" -Recurse "D:\"
    $inventarName = Get-Content ($inventarDrive+$inventarNameFile) #Read DeviceName from Device, must be available and unique
    Write-Output "no file available, created new"
}

if ($inventarName-eq"dummy"){
    $serialNum=(wmic diskdrive 1 get SerialNumber)
    
    $inventarName=($serialNum[2..2]).trim() #| out-string
    #$volumeName= gwmi win32_logicaldisk |  where{$_.DeviceID -eq'E:'} | select DeviceID,VolumeName,Size,FreeSpace
    #gwmi win32_logicaldisk|  where{$_.DeviceID -eq'E:'} | select DeviceID,VolumeName
    #gwmi win32_logicaldisk -filter "drivetype=3" |  where{$_.DeviceID -eq 'E:'} | select DeviceID,VolumeName,Size,FreeSpace

    #$count=$volumeName.count
    #$count
    #$volumeName.length
    #$volumeName
    #$serialNum[2..2]
    Set-Content -Path ($inventarDrive+$inventarNameFile) -Value $inventarName
    Write-Output "no name available, created from SN"
}
$myFilePath=$myUserPath+ $inventarName + $myFileExt #create separte file for each device according to name
$myFilePathXML=$myUserPath+ $inventarName + '.xml' #create separte file for each device according to name


#get Device Information
Get-WmiObject win32_logicaldisk -filter "drivetype=3" |  Where-Object{$_.DeviceID -eq'D:'} | Select-Object DeviceID,VolumeName,Size,FreeSpace,name| Out-File -FilePath $myFilePath
Get-WmiObject win32_logicaldisk -filter "drivetype=2" |  Where-Object{$_.DeviceID -eq'D:'} | Select-Object DeviceID,VolumeName,Size,FreeSpace,name| Out-File -FilePath $myFilePath -Append
Get-WmiObject win32_logicaldisk |  Where-Object{$_.DeviceID -eq'E:'} | Select-Object DeviceID,drivetype,VolumeName,Size,FreeSpace,name| export-clixml  $myFilePathXML #$Env:userprofile\drive.xml


wmic diskdrive 1 get size,model,SerialNumber| Out-File -FilePath $myFilePath -Append
#wmic diskdrive 1 get size,model,SerialNumber| export-clixml  $Env:userprofile\drive2.xml

#Get Folders on Device
Get-ChildItem $inventarDrive -force | Where-Object {$_.attributes -match "Directory"}| Out-File -FilePath $myFilePath -Append
Get-ChildItem $inventarDrive -force | Where-Object {$_.attributes -match "Directory"}| Select-Object Name |export-clixml  $myFilePathXML #$Env:userprofile\folders.xml

Write-Output "Saved data at: "$myFilePath