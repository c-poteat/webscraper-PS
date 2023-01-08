
function webscraper {
$html = Invoke-WebRequest -Uri 'https://bqotd.com/'
$htmlContent = $html.Content
$imageUrls = Select-String -InputObject $htmlContent -Pattern '<img src="([^"]+png)"' -AllMatches | % { $_.Matches } | % { $_.Groups[1].Value }
foreach ($imageUrl in $imageUrls) {
    Invoke-WebRequest -Uri $imageUrl -OutFile "$((Split-Path -Leaf $imageUrl))" #Outfile location is the current active directory.
  }
}
function sendemailwithpic {
$from = "youremail@mail.com" #used mail.com setting since gmail and yahoo mail do not allow less secure connections
$to = "youremail@gmail.com"  #replace with actual gmail address
$subject = "A great motivating quote while using PowerShell"
$body = "Quote of the Day"
$directory = "/Users/nell/Documents/DEV/PowerShell/webscraper-ps"
$imageExtensions = @("*.jpg", "*.png", "*.gif")
$attachment = Get-ChildItem -Path $directory -Include $imageExtensions -Recurse | Get-Random
$username = "youremail@mail.com"  #again signed up to mail.com
$password = "yourpassword"
Send-MailMessage -From $from -To $to -Subject $subject -Body $body -Attachment $attachment -SmtpServer smtp.mail.com -Port 587 -UseSsl -Credential (New-Object System.Management.Automation.PSCredential($username,(ConvertTo-SecureString $password -AsPlainText -Force)))

}

function main {
  webscraper
  sendemailwithpic

  Write-Output "Email was sent successfully"
}




