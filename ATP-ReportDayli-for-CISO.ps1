#Credentials

$userCredentials = Get-AutomationPSCredential -Name "Outlook365"

########################################
#Select the subscription and the storage account 

Connect-AzAccount -Credential $userCredentials
Set-AzContext -Subscription '04294eda-21ff-4b5a-a2dd-673650a53827'
Set-AzCurrentStorageAccount -ResourceGroupName "CIS-Storage" -Name "atpstoragereports"

####################################
#date for the name of the file CSV

$date= (get-date).ToString("dd-MM-yyyy")

###########################################
# API Connection to Azure ATP
Connect-AzAccount -Identity -AccountId '63e8121f-2c23-4db6-91bb-214b76db23fc' -subscription 'CIS-Technion (EA)'
$key = Get-AzKeyVaultSecret -VaultName 'cis-key' -Name 'DefenderATPApp' -AsPlainText
$tenantId = 'f1502c4c-ee2e-411c-9715-c855f6753b84' ### Paste your own tenant ID here
$appId = '40499d1b-3c87-48f9-9cb3-bf2011658f74' ### Paste your own app ID here

$resourceAppIdUri = 'https://api.securitycenter.windows.com'
$oAuthUri = "https://login.windows.net/$TenantId/oauth2/token"

$authBody = [Ordered] @{
    resource = "$resourceAppIdUri"
    client_id = "$appId"
    client_secret = $Key
    grant_type = 'client_credentials'
}

$authResponse = Invoke-RestMethod -Method Post -Uri $oAuthUri -Body $authBody -ErrorAction Stop
$token = $authResponse.access_token
Out-File -FilePath "./Latest-token.txt" -InputObject $token


##################################################
#Extract the Info for the las 24 Hours

$dateTime = (Get-Date).ToUniversalTime().AddHours(-24).ToString("o")

$url = "https://api.securitycenter.windows.com/api/alerts?`$filter=alertCreationTime ge $dateTime"

$headers = @{ 
    'Content-Type' = 'application/json'
    Accept = 'application/json'
    Authorization = "Bearer $token" 
}

$response = Invoke-RestMethod -Method Get -Uri $url -Headers $headers -ErrorAction Stop


##################################################
#Foreach alert, get the machineId and alertId and isloate machine while writing the alert ID in the isolation comments. 
$obj = $null
$count=$null
$obj | export-csv -Path:"c:\temp\atp\atp-general.csv"  -NoTypeInformation  -Force 

foreach ($alert in $response.value)
{ 
    Start-Sleep -s 2
	$alertId = $alert.id
	$alertseverity = $alert.severity
	$machineId = $alert.machineId
	
	$url = "https://api.securitycenter.windows.com/api/machines/$machineId" 
	
	$body = @{}

	$headers = @{		
		Authorization = "Bearer $token" 
	} 
	
	$machineInfoResponse = Invoke-WebRequest -Method Get -Uri $url -Body $body -Headers $headers -ErrorAction Stop -UseBasicParsing
	
	#Filter for only High an Medium Alerts
	if(($machineInfoResponse.StatusCode -eq 200) -and (($alertseverity -eq "Medium")-or ($alertseverity -eq "High" ) ))  { 
        $machineInfo =  $machineInfoResponse | select -Expand Content | ConvertFrom-Json
        $machineName = $machineInfo.computerDnsName

		# replace the next line with your code to take the alerts data and enrich it with machine info.
	    #$csv = $machineInfo | select @{name="IP";e={$_."lastExternalIpAddress"}},@{name="ComputerNAme";e={$_."computerDnsName"}},@{name="OS";e={$_."osPlatform"}},@{name="Tag";e={$_."rbacgroupname"}}
	   $obj = New-Object -TypeName PSObject
	     $obj | Add-Member -MemberType NoteProperty -Name "Severity" -Value $alert.severity
		 $obj | Add-Member -MemberType NoteProperty -Name "Tag" -Value $machineInfo.rbacGroupName
		 $obj | Add-Member -MemberType NoteProperty -Name "ComputerNAme" -Value $machineInfo.computerDnsName
		 $obj | Add-Member -MemberType NoteProperty -Name "Alert Title" -Value $alert.title
		 $obj | Add-Member -MemberType NoteProperty -Name "Status" -Value $alert.status
         $obj | Add-Member -MemberType NoteProperty -Name "Description" -Value $alert.description
		 $obj | Add-Member -MemberType NoteProperty -Name "IP" -Value $machineInfo.lastExternalIpAddress
		 $obj | Add-Member -MemberType NoteProperty -Name "OS" -Value $machineInfo.osPlatform
		 $obj | Add-Member -MemberType NoteProperty -Name "Incident ID" -Value $alert.incidentId
		 $obj | Add-Member -MemberType NoteProperty -Name "Alert Creation" -Value $alert.alertCreationTime

		 $obj |  sort Severity | export-csv -Path:"c:\temp\atp\atp-general.csv"  -NoTypeInformation  -Append -Force 
    $count++
		 
	} 
	else { 
	} 
}

#####################################
#Export the CSV to AzureStorage

Set-AzStorageBlobContent -Container atpreportdayli -File c:\temp\atp\atp-general.csv -blob "Daily-$date.csv" -Force

write-output "The count is $count"

######################################
#Import the CSV from AzureStorage 

$blob =  Get-AzStorageBlobContent -Blob:"Daily-$date.csv" -Container:"atpreportdayli" -Destination:"C:\Temp\atp" -Force 

import-csv -Path "c:\temp\atp\Daily-$date.csv" | sort severity | export-csv -Path:"c:\temp\atp\ATP-Report-Daily-$date.csv" -NoTypeInformation -Force 

#######################################
#Send email with the Attachment            
##Send-MailMessage -Bodyashtml -Encoding ([System.Text.Encoding]::UTF8) -Attachments "c:\temp\atp\ATP-Report-Daily-$date.csv" -Subject "ATP Report Daily - $date" -To:"atpreportsteams@technion.ac.il" -SmtpServer:"smtp.office365.com" -UseSsl -Port 587 -Credential:$userCredentials -from: "cisreports@Technion.ac.il" 


#######################################
#Delete file from blob
Remove-AzStorageBlob -Container "atpreportdayli" -Blob "Daily-$date.csv"

#####################################################################################################################################################



#region auth
# The resource URI
#Connect to MgGraph
$ApplicationId = "40499d1b-3c87-48f9-9cb3-bf2011658f74"
$SecuredPassword = $key
$tenantID = "f1502c4c-ee2e-411c-9715-c855f6753b84"

$SecuredPasswordPassword = ConvertTo-SecureString `
-String $SecuredPassword -AsPlainText -Force

$ClientSecretCredential = New-Object `
-TypeName System.Management.Automation.PSCredential `
-ArgumentList $ApplicationId, $SecuredPasswordPassword

Connect-MgGraph -TenantId $tenantID -ClientSecretCredential $ClientSecretCredential



# No interaction, Application Permission
$tokenBody = @{  
    Grant_Type    = "client_credentials"  
    Scope         = "https://graph.microsoft.com/.default"  
    Client_Id     = $ApplicationId  
    Client_Secret = $key
}   

$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$Tenantid/oauth2/v2.0/token" -Method POST -Body $tokenBody  


$headers = @{
        "Authorization" = "Bearer $($tokenResponse.access_token)"
        "Content-type"  = "application/json"
    }



#Configure Mail Properties
$MailSender = "cisreports@Technion.ac.il"



$Attachment="c:\temp\atp\ATP-Report-Daily-$date.csv"
$FileName=(Get-Item -Path $Attachment).name
$base64string = [Convert]::ToBase64String([IO.File]::ReadAllBytes($Attachment))


#Send Mail    
$URLsend = "https://graph.microsoft.com/v1.0/users/$MailSender/sendMail"


$BodyJsonsend = @"
                    {
                        "message": {
                          "subject": "ATP Report Daily - $date",
                          "body": {
                            "contentType": "HTML",
                            "content": "This Mail is sent via Microsoft <br>
                            "
                          },
                          
                          "toRecipients": [
                            {
                              "emailAddress": {
                                "address": "atpreportsteams@technion.ac.il"
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