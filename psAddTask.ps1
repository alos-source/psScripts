[CmdletBinding(DefaultParameterSetName="Operate")]
param (
    [Parameter(ParameterSetName="Operate", Mandatory=$false)]
    [Parameter(ParameterSetName="Install", Mandatory=$true)]
    [switch] $Install,
    [Parameter(ParameterSetName="Uninstall", Mandatory=$true)]
    [switch] $Uninstall
)

if($Install) {
    "installing ..."
    # script ist being registered as scheduled task
    $posh = 'powershell'
    if($PSVersionTable.PSEdition -eq 'Core') {
        $posh = 'pwsh'
    }
    $script = '-EP Bypass -NoLogo -NonInteractive -WindowStyle Hidden -File "' + $MyInvocation.MyCommand.Definition + '"';
    $action = New-ScheduledTaskAction -Execute $posh -Argument $script;
    $trigger = New-ScheduledTaskTrigger -Once -At ((Get-Date).AddSeconds(10)) -RepetitionInterval (New-TimeSpan -Days 1);
    $settings = New-ScheduledTaskSettingsSet -Hidden -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -StartWhenAvailable;
    $task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings;
    Register-ScheduledTask 'Service-Scripts' -InputObject $task | Out-Null;
    "ready."
    exit
}

if($Uninstall) {
    "uninstalling ..."
    # scheduled task is unregistered
    Unregister-ScheduledTask 'Service-Scripts';
    "ready."
    exit
}