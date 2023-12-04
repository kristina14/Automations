
#Send SMS from INFORU server (Web Department)

$userCredentials = Get-AutomationPSCredential -Name 'Outlook365'
  
  Send-MailMessage -From cis-account@technion.ac.il -To 0584222125@sms.inforu.co.il -Subject "Your Password is: 123456 , you will ask to change it in the next logon"  -SmtpServer:"tx.technion.ac.il"        
