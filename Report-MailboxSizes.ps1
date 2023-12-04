#This Script is for know tha Status of the Mailbox in Staff-admin Used more than 30 GB 



#Credentials
$userCredentials = Get-AutomationPSCredential -Name "Outlook365"

Connect-ExchangeOnline -Credential $userCredentials

####################################
#Get all users for Admin OU in Staff
$users = Get-ADUser -server staff.technion.ac.il -SearchBase "ou=admin,ou=staff,dc=staff,dc=technion,dc=ac,dc=il" -filter * | select userprincipalname 



###################################
#For MAilbox used more than 30GB of the space , Put the info in the CSV ("Mailbox","Used","Free") 
foreach ($user in $users) {

$mail = $user.userprincipalname

	$size = Get-MailboxStatistics $mail | Select DisplayName, @{name="TotalItemSize (MB)"; expression={[math]::Round(($_.TotalItemSize.ToString().Split("(")[1].Split(" ")[0].Replace(",","")/1MB),2)}}, ItemCount 
    $total = $size.'TotalItemSize (MB)'
    $mailboxquota = get-mailbox $mail | select  @{name="ProhibitSendReceiveQuota"; expression={[math]::Round(($_.ProhibitSendReceiveQuota.ToString().Split("(")[1].Split(" ")[0].Replace(",","")/1MB),2)}} 
    $free = ($mailboxquota.ProhibitSendReceiveQuota - $total)
    
	if ($size.'TotalItemSize (MB)' -gt 30000) {
               $obj = New-Object -TypeName System.Text.UTF8Encoding $false
                $obj | Add-Member -MemberType NoteProperty -Name "Mailbox" -Value $mail 
                $obj | Add-Member -MemberType NoteProperty -Name "Used" -Value $total
                $obj | Add-Member -MemberType NoteProperty -Name "Free" -Value $free
   
            
                $obj | select Mailbox,Used,Free| export-csv -Path:"c:\temp\mailboxreport.csv"  -NoTypeInformation -Append -Force -Encoding UTF8 
       } else {}
}


#############################################
#Send a email with the CSV Attachment to the PcSupport Group
#Send-MailMessage -Subject "Mailbox Size Report" -To:"Cis-PcSupport@technion.ac.il" -SmtpServer:"smtp.office365.com" -Credential:$userCredentials -from: "outlook365@Technion.ac.il" -Attachments c:\temp\mailboxreport.csv  -port 587 -usessl


#####################################################################################################################################################



#region auth
# The resource URI

Connect-AzAccount -Identity -AccountId '63e8121f-2c23-4db6-91bb-214b76db23fc' -subscription 'CIS-Technion (EA)'
$secret = Get-AzKeyVaultSecret -VaultName 'cis-key' -Name 'DefenderATPApp'
$ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue)  
try {  
  $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)  
} finally {  
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)  
} 



$resource = "https://graph.microsoft.com"
$clientid = "40499d1b-3c87-48f9-9cb3-bf2011658f74" #Application (client) ID from Azure App registration Page
$clientSecret = $secretValueText #Client Secret from "Certificate $ secrets"
# $redirectUri = "http://localhost" # Redirect URL, which was used at App Registration Process
$Tenantid = "f1502c4c-ee2e-411c-9715-c855f6753b84" # Directory (tenant) ID also from Azure App registration Page


# No interaction, Application Permission
$tokenBody = @{  
    Grant_Type    = "client_credentials"  
    Scope         = "https://graph.microsoft.com/.default"  
    Client_Id     = $clientId  
    Client_Secret = $clientSecret  
}   

$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$Tenantid/oauth2/v2.0/token" -Method POST -Body $tokenBody  


$headers = @{
        "Authorization" = "Bearer $($tokenResponse.access_token)"
        "Content-type"  = "application/json"
    }



#Configure Mail Properties
$MailSender = "cisreports@Technion.ac.il"


#Connect to GRAPH API
$tokenBody = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $clientId
    Client_Secret = $clientSecret
}
$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token" -Method POST -Body $tokenBody
$headers = @{
    "Authorization" = "Bearer $($tokenResponse.access_token)"
    "Content-type"  = "application/json"
}

$Attachment="c:\temp\mailboxreport.csv"
$FileName=(Get-Item -Path $Attachment).name
$base64string = [Convert]::ToBase64String([IO.File]::ReadAllBytes($Attachment))


#Send Mail    
$URLsend = "https://graph.microsoft.com/v1.0/users/$MailSender/sendMail"


$BodyJsonsend = @"
                    {
                        "message": {
                          "subject": "Mailbox Size Report",
                          "body": {
                            "contentType": "HTML",
                            "content": "This Mail is sent via Microsoft <br>
                            "
                          },
                          
                          "toRecipients": [
                            {
                              "emailAddress": {
                                "address": "Cis-PcSupport@technion.ac.il"
                              }
                            }
                          ]              
                        ,"attachments": [
                            {
                              "@odata.type": "#microsoft.graph.fileAttachment",
                              "name": "$FileName",
                              "contentType": "text/plain",
                              "contentBytes": "$base64string"
                            }
                          ]
                        },
                        "saveToSentItems": "false"
                      }
"@


Invoke-RestMethod -Method POST -Uri $URLsend -Headers $headers -Body $BodyJsonsend

##############################################
#Remove the CSV from the Server 
Remove-Item c:\temp\mailboxreport.csv -Confirm:$false



