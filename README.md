# Test VMware DRS Rule
This repository contains PowerShell scripts needed for check if desired virtual machines are running on desired ESXi hosts.

## Requirements
#### Requirements for management server:
*  *Windows Management Framework 5.1* is installed
*  PowerShell *VMware.PowerCLI* module is installed
*  Management server has connection to *vCenter* on port `443`

#### Requirements for script:
* In folder `$env:ProgramData` must be folder `vmware-test-drs-rule`
* In folder `vmware-test-drs-rule` must be stored
    * Script `send-check-drs-rule-test.ps1`
    * Script `schedule-drs-rule-test.ps1` (optional)
    * TXT File `eid.txt` with generated password to access vCenter
    * Folder `cc` (Where "cc" stands for country code)
        * In folder `cc` msut be script `cc-test-drs-rule.ps1` (:warning: **Do not forget** to update variables)
        
#### Requirements for vCenter (how to create rules go to 
* VM group must exist
* Host group must exist
* Rule must exist

:warning: DRS groups must follow naming convention (more information [How to create DRS rules](#### How to create DRS rules))

### Notes
In some coutries VMWare Windows cluster has been merged with other cluster but for 
licensing limitation, all Windows virtual machines must run on specified ESXi hosts.

#### How to create DRS rules
* It is recommended to create create each group with `CC` code
    * To create host group use name `$CC-WindowsHostsGroup`
        * Command `New-DrsClusterGroup -Name $drsClusterHostGroupName -Cluster $drsClusterGroupCluster -VMHost $drsClusterGroupVMHosts`
    * To create virtual machine group use name `$CC-WindowsVmsGroup`
        * Command `New-DrsClusterGroup -Name $drsClusterVmsGroupName -Cluster $drsClusterGroupCluster -VM $drsClusterGroupVM`
    * To create rule use name `$CC-WindowsVmHostRule`
        * Command `New-DrsVMHostRule -Name $drsVMHostRuleName -Cluster $drsClusterGroupCluster -VMGroup $drsClusterVmsGroupName -VMHostGroup $drsClusterHostGroupName -Type $drsVMhostRuleType`

On server *server name* are scheduled tasks running every Monday.

| JobName | StartAt (UTC) | Note |
| ------- | ------------ | ------------- |
| vmware-cc-test-drs-rule | 00:30:00 | Getting data |
| vmware-cc-drc-test-drs-rule | 23:00:00 | Getting data |
| vmware-send-check-drs-rule-test | 05:00:00 | Sends email |

## Author
* Filip Vagner - filip.vagner@hotmail.com