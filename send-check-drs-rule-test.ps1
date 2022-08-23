$inSendMailParams = @{
    From = '<EMAIL ADDRESS>'
    To = '<EMAIL ADDRESS>'
    Subject = 'CC - DRS Rule Report'
    SMTPServer = '<SMTP SERVER>'
}

$Header = @"
    <style>
        table, th, td {
        font-family: arial;
        border: 1px solid black;
        border-collapse: collapse;
    </style>
"@

if ((Get-ChildItem -Path "$env:ProgramData\vmware-test-drs-rule\cc\cc-drsrule-data.csv").Length -gt 0) {
    $inDrsTestRuleDataPath = Import-Csv "$env:ProgramData\vmware-test-drs-rule\cc\cc-drsrule-data.csv"
    $inDrsTestRuleDataPath | ConvertTo-Html -Head $Header | Out-File "$env:ProgramData\vmware-test-drs-rule\cc\cc-drsrule-data.html"
    $inEmailBody = Get-Content -Path "$env:ProgramData\vmware-test-drs-rule\cc\cc-drsrule-data.html" | Out-String
    Send-MailMessage @inSendMailParams -Body $inEmailBody -BodyAsHtml
} else {
    continue
}
