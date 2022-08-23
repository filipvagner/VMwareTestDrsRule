# Country PDC getting data schedule begining
$inPdcDrsJobTriggerParameters = @{
    Frequency = "Weekly"
    At = "2:30AM"
    DaysOfWeek = "Monday"
}

$inPdcDrsJobOptionParameters = @{
    WakeToRun = $true
    #ContinueIfGoingOnBattery = $true
    # StartIfOnBattery = $true
    RunElevated = $false
}

$inPdcDrsJobName = "<job name>"
$inPdcDrsJobFilePath = "$env:ProgramData\vmware-test-drs-rule\cc\countryCode-pdc-test-drs-rule.ps1"
$ScheduledJobCredentials = (Get-Credential)
Register-ScheduledJob -Name $inPdcDrsJobName -FilePath $inPdcDrsJobFilePath -Trigger $inPdcDrsJobTriggerParameters -ScheduledJobOption $inPdcDrsJobOptionParameters -Credential $ScheduledJobCredentials
# Country PDC getting data  schedule end

# Country DRC getting data  schedule begining
$vnDrcDrsJobTriggerParameters = @{
    Frequency = "Weekly"
    At = "1:00AM"
    DaysOfWeek = "Monday"
}

$vnDrcDrsJobOptionParameters = @{
    WakeToRun = $true
    #ContinueIfGoingOnBattery = $true
    # StartIfOnBattery = $true
    RunElevated = $false
}

$vnDrcDrsJobName = "<job name>"
$vnDrcDrsJobFilePath = "$env:ProgramData\vmware-test-drs-rule\cc\countryCode-drc-test-drs-rule.ps1"
$ScheduledJobCredentials = (Get-Credential)
Register-ScheduledJob -Name $vnDrcDrsJobName -FilePath $vnDrcDrsJobFilePath -Trigger $vnDrcDrsJobTriggerParameters -ScheduledJobOption $vnDrcDrsJobOptionParameters -Credential $ScheduledJobCredentials
# Country DRC getting data  schedule end

# Schedule send check begining
$sendCheckJobTriggerParameters = @{
    Frequency = "Weekly"
    At = "7:00AM"
    DaysOfWeek = "Monday"
}

$sendCheckJobOptionParameters = @{
    WakeToRun = $true
    #ContinueIfGoingOnBattery = $true
    # StartIfOnBattery = $true
    RunElevated = $false
}

$sendCheckJobName = "vmware-send-drs-rule-report"
$sendCheckJobFilePath = "$env:ProgramData\vmware-test-drs-rule\vmware-send-drs-rule-report.ps1"
$ScheduledJobCredentials = (Get-Credential)
Register-ScheduledJob -Name $sendCheckJobName -FilePath $sendCheckJobFilePath -Trigger $sendCheckJobTriggerParameters -ScheduledJobOption $sendCheckJobOptionParameters -Credential $ScheduledJobCredentials
# Schedule send check end