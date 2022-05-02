
$message = $args[1]
$title = $args[0]

$JSONBody = [PSCustomObject][Ordered]@{
    "@type"      = "MessageCard"
    "@context"   = "<http://schema.org/extensions>"
    "summary"    = "$($title)"
    "themeColor" = '0078D7'
    "title"      = "$title" #Databasename - from - VM name
    "text"       = "<pre>$message)</pre>"
}
    
$TeamMessageBody = ConvertTo-Json $JSONBody
    
$parameters = @{
    "URI"         = "https://mcmedisoft.webhook.office.com/webhookb2/8ca9b9cc-5cac-4d6b-9f5f-60f41dea8fe8@da61d295-318e-423e-9958-f2fbb0538f98/IncomingWebhook/6ba1b67103c1466b961bdc17da5c7aac/e8f8db86-c7b9-4ed8-b4b4-1aa39bf7e198"
    "Method"      = 'POST'
    "Body"        = $TeamMessageBody
    "ContentType" = 'application/json'
}
    
Invoke-RestMethod @parameters
