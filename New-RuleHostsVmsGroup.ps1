$CC = '<country code>'
$drsClusterHostGroupName = "$CC-WindowsHostsGroup"
$drsClusterVmsGroupName = "$CC-WindowsVmsGroup"
$drsVMHostRuleName = "$CC-WindowsVmHostRule"
$drsVMhostRuleType = "ShouldRunOn"
$drsClusterGroupCluster = "<cluster name>"
$drsClusterGroupVMHosts = "<host name>"
$drsClusterGroupVM = Get-Content -Path $env:USERPROFILE\Documents\server-list.txt

# Command to create new DRS host group
New-DrsClusterGroup -Name $drsClusterHostGroupName -Cluster $drsClusterGroupCluster -VMHost $drsClusterGroupVMHosts
# Command to create new DRS virtual machine group
New-DrsClusterGroup -Name $drsClusterVmsGroupName -Cluster $drsClusterGroupCluster -VM $drsClusterGroupVM
# Command to create DRS rule for hosts and virtual machines
New-DrsVMHostRule -Name $drsVMHostRuleName -Cluster $drsClusterGroupCluster -VMGroup $drsClusterVmsGroupName -VMHostGroup $drsClusterHostGroupName -Type $drsVMhostRuleType
# Command to add new host to DRS host group
Get-DrsClusterGroup -Name $drsClusterHostGroupName | Set-DrsClusterGroup -VMHost $drsClusterGroupVMHosts -Add
# Command to add virtual machine to DRS virtual machine group
Get-DrsClusterGroup -Name $drsClusterVmsGroupName | Set-DrsClusterGroup -VM $drsClusterGroupVM -Add
# Command to remove host from DRS host group
Get-DrsClusterGroup -Name $drsClusterHostGroupName | Set-DrsClusterGroup -VMHost $drsClusterGroupVMHosts -Remove
# Command to remove virtual machine from DRS virtual machine group
Get-DrsClusterGroup -Name $drsClusterVmsGroupName | Set-DrsClusterGroup -VM $drsClusterGroupVM -Remove