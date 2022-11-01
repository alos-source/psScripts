$myUserPath=$Env:userprofile+"\documents\SpeicherInventar\"
$myFileExt=".txt"
$inventarDrive="E:"
$inventarNameFile='\.inventar\inventar.name'

$xmlFile = New-Object System.XMl.XMLTextWriter("myXML3.xml",$Null)
$xmlFile.Formatting = "indented"
$xmlFile.Indentation = 1
#$xmlFile.indentChar = "'t"

$xmlFile.WriteStartDocument()
$xmlFile.WriteStartElement("list")

#$xmlFile.WriteStartElement("eins")
#$xmlFile.WriteElementString("Nummer","zwei")
#$xmlFile.WriteEndElement()

$xmlFile.WriteStartElement("properties")

if(Test-Path ($inventarDrive+$inventarNameFile)) {
    $inventarName = Get-Content ($inventarDrive+$inventarNameFile) #Read DeviceName from Device, must be available and unique
}
else {
    copy-item C:\Users\alex\Documents\Projekte\Skripte\speicherInventar\festplattenordner\.inventar -Recurse "E:\"
    $inventarName = Get-Content ($inventarDrive+$inventarNameFile) #Read DeviceName from Device, must be available and unique
    echo "no file available, created new"
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
    echo "no name available, created from SN"
}
$myFilePath=$myUserPath+ $inventarName + $myFileExt #create separte file for each device according to name
$myFilePathXML=$myUserPath+ $inventarName + '.xml' #create separte file for each device according to name

$xmlFile.WriteElementString("serial", $inventarName)# $inventarName)

#$xmlFile.add-member($inventarName)

#get Device Information
gwmi win32_logicaldisk -filter "drivetype=3" |  where{$_.DeviceID -eq'E:'} | select DeviceID,VolumeName,Size,FreeSpace,name| Out-File -FilePath $myFilePath
gwmi win32_logicaldisk -filter "drivetype=2" |  where{$_.DeviceID -eq'E:'} | select DeviceID,VolumeName,Size,FreeSpace,name| Out-File -FilePath $myFilePath -Append
gwmi win32_logicaldisk |  where{$_.DeviceID -eq'E:'} | select DeviceID,VolumeName,Size,FreeSpace,name| export-clixml  $myFilePathXML #$Env:userprofile\drive.xml

wmic diskdrive 1 get size,model,SerialNumber| Out-File -FilePath $myFilePath -Append
$diskproperties = gwmi win32_logicaldisk |  where{$_.DeviceID -eq'E:'} | select DeviceID,VolumeName,Size,FreeSpace,name
#wmic diskdrive 1 get size,model,SerialNumber| export-clixml  $Env:userprofile\drive2.xml
#$xmlFile.WriteElementString("serial", "test")# $inventarName)
#$xmlFile.WriteStartElement("eigenschaften")
$xmlFile.WriteElementString("VolumeName", $diskproperties.VolumeName)
$xmlFile.WriteElementString("DevID", $diskproperties.DeviceID)
$xmlFile.WriteElementString("Size", $diskproperties.Size)
$xmlFile.WriteElementString("FreeSpace", $diskproperties.FreeSpace)
#$xmlFile.WriteEndElement()

echo($diskproperties)

#Get Folders on Device
$folders = gci $inventarDrive -force | where {$_.attributes -match "Directory"}|Select-Object Name
gci $inventarDrive -force | where {$_.attributes -match "Directory"}| Out-File -FilePath $myFilePath -Append
gci $inventarDrive -force | where {$_.attributes -match "Directory"}| export-clixml  $Env:userprofile\folders.xml

$xmlFrag = $folders|convertTo-xml
$xmlFrag.Save("folders2.xml")

$d = $a.SelectSingleNode("//c1")
$d.AppendChild($c)

$xmlFile.AppendChild($xmlFrag)



echo "Saved data at: "$myFilePath

$xmlFile.WriteEndElement()

$xmlFile.WriteEndDocument()

$xmlFile.flush()
$xmlFile.close()