$sendMailParams = @{
    From = '<name>@<domain>'
    To = '<name>@<domain>'
    Subject = 'DRS Rule Report'
    SMTPServer = '<server name>'
}

$Header = @"
    <style>
        table, th, td {
        font-family: arial;
        border: 1px solid black;
        border-collapse: collapse;
    </style>
"@

$drsRuleReport = "$env:ProgramData\vmware-test-drs-rule\drs-rule-report.html"
$inPdcDrsTestRuleDataPath = "$env:ProgramData\vmware-test-drs-rule\cc\countryCode-pdc-drs-rule-data.csv"
$vnDrcDrsTestRuleDataPath = "$env:ProgramData\vmware-test-drs-rule\cc\countryCode-drc-drs-rule-data.csv"
$reportHasData = $false

if (Test-Path -Path $drsRuleReport) {
    Get-Item -Path $drsRuleReport | Remove-Item -Confirm:$false
}

if ((Get-ChildItem -Path $inPdcDrsTestRuleDataPath).Length -gt 0) {
    $inDrsTestRuleDataPath = Import-Csv $inPdcDrsTestRuleDataPath
    $inDrsTestRuleDataPath | ConvertTo-Html -Head $Header | Out-File $drsRuleReport -Append
    $reportHasData = $true
} else {
    continue
}

if (($vnDrcDrsTestRuleDataPath).Length -gt 0) {
    $vnDrsTestRuleDataPath = Import-Csv $vnDrcDrsTestRuleDataPath
    $vnDrsTestRuleDataPath | ConvertTo-Html -Head $Header | Out-File $drsRuleReport -Append
    $reportHasData = $true
} else {
    continue
}

if ($reportHasData -eq $true) {
    $emailBody = Get-Content -Path $drsRuleReport | Out-String
    Send-MailMessage @sendMailParams -Body $emailBody -BodyAsHtml
}