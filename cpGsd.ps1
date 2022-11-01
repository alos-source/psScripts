

function cpGsds {

PARAM ([string]$SOURCE)

#$SOURCE = "D:\Kundenprojekte\BMW\20200124_SafetyCrash\02301RKE1\AdditionalFiles\GSD\*"


#$DelayinSeconds = Read-Host -Prompt 'How manys seconds to delay until server starts?'


$Path = Get-Location

Copy-Item -Path "$Path\AdditionalFiles\GSD\*" -Destination "D:\VMShare\gsds"

}



cpGsds
