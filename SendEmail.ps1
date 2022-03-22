Param([string]$from,[string]$to,[string]$cc,[string]$attachment,
[string]$subject,[string]$bodyContent,[string]$smtpServer,[int]$smtpPort,[string]$password)
    
$attachmentPath = ".\"+ $attachment
$body = "<p><strong>:</strong> $bodyContent </p>”
$secureString = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($from, $secureString)

Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential $creds -Attachments $attachmentPath


