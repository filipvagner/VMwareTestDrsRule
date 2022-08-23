# Data files
$drsTestRuleDataPath = "$env:ProgramData\vmware-test-drs-rule\<country code>\countryCode-pdc-drs-rule-data.csv"

# Removing previsouly created data files
Get-Item -Path $drsTestRuleDataPath | Remove-Item -Force -Confirm:$false

# Connection to vCenter
$vCenterServer = "<server name>"
$UserNameToAccessVcenter = '<user name>@<domain name>'
$EncryptedPasswordToAccessVcenter = Get-Content -Path "$env:ProgramData\vmware-test-drs-rule\eid.txt" | ConvertTo-SecureString
$CredentialsToAccessVcenter = New-Object -TypeName System.Management.Automation.PSCredential($UserNameToAccessVcenter, $EncryptedPasswordToAccessVcenter)
Connect-VIServer -Server $vCenterServer  -Credential $CredentialsToAccessVcenter -ErrorAction Stop

# Common variables
$CC = '<country code>'
$hostCluster = "<cluster name>"
$vmsList = Get-Cluster -Name $hostCluster | Get-VM | `
                Where-Object {($_.GuestId -match 'windows') -or `
                ($_.GuestId -like 'winNetStandardGuest') -or `
                ($_.GuestId -like 'winNetEnterpriseGuest') -or `
                ($_.GuestId -like 'winLonghornGuest')} | Select-Object -ExpandProperty Name

$drsClusterHostGroupName = "$CC-WindowsHostsGroup"
$drsClusterVmsGroupName = "$CC-WindowsVmsGroup"
$drsClusterHostGroupMemebers = (Get-DrsClusterGroup -Name $drsClusterHostGroupName).Member | Select-Object -ExpandProperty Name
$drsClusterVmsGroupMemebers = (Get-DrsClusterGroup -Name $drsClusterVmsGroupName).Member | Select-Object -ExpandProperty Name
$checkListArray = New-Object -TypeName "System.Collections.ArrayList"

foreach ($vmToCheck in $vmsList) {
    $vmToCheckHost = (Get-VM -Name $vmToCheck | Get-VMHost).Name
    if ($drsClusterHostGroupMemebers -contains $vmToCheckHost) {
        $OnDesiredHost = $true       
    } else {
        $OnDesiredHost = $false
    }

    if ($drsClusterVmsGroupMemebers -contains $vmToCheck) {
        $vmToCheckObject = [PSCustomObject]@{
            VMName = $vmToCheck
            PartOfGroup = $true
            OnDesiredHost = $OnDesiredHost
            VMHost = $vmToCheckHost
        }
        $checkListArray.Add($vmToCheckObject)
    } elseif ($drsClusterVmsGroupMemebers -notcontains $vmToCheck) {
        $vmToCheckObject = [PSCustomObject]@{
            VMName = $vmToCheck
            PartOfGroup = $false
            OnDesiredHost = $OnDesiredHost
            VMHost = $vmToCheckHost
        }
        $checkListArray.Add($vmToCheckObject) 
    } else {
        $vmToCheckObject = [PSCustomObject]@{
            VMName = $vmToCheck
            PartOfGroup = 'N/A'
            OnDesiredHost = 'N/A'
            VMHost = 'N/A'
        }
        $checkListArray.Add($vmToCheckObject) 
    }
}

Disconnect-VIServer -Server $vCenterServer -Confirm:$false

$checkListArray | Where-Object {($_.PartOfGroup -eq $false) -or ($_.OnDesiredHost -eq $false)} | Export-Csv -Path $drsTestRuleDataPath -NoTypeInformation