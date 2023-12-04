$cred = Get-AutomationPSCredential -Name 'Outlook365'
Connect-azuread -Credential $cred
Set-AzContext -Subscription '04294eda-21ff-4b5a-a2dd-673650a53827'
Set-AzCurrentStorageAccount -ResourceGroupName "CIS-Storage" -Name "ciscostcsv"

import-module activedirectory

# Function to recursively retrieve all members of a group

function Get-RecursiveGroupMembers {

    [CmdletBinding()]

    param (

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$GroupName, [string]$domain

    )

    # Get DC from Domain

    $dc =  Get-ADDomainController -Server $domain -Filter * | select -First 1 HostName

    # Get the members of the group

    $admembers = (Get-ADGroup -Identity $GroupName -Properties members -Server "$($dc.HostName)").members

    $members = $admembers | % {Get-ADObject -Identity $_ -Properties * -Server "$($dc.HostName):3268"}

    # Loop through each member

    foreach ($member in $members) {

        if ($member.objectClass -eq "User") {

        $userdom = (($member).CanonicalName).split("/")[0]

            Write-Output $member | Select-Object Name, SamAccountName, dist*,@{n="LastLogon";e={[datetime]::FromFileTime($member.lastLogonTimestamp).ToString('g')}},@{n="UserDomain";e={$userdom}},@{n="PwdLastSet";e={[datetime]::FromFileTime($member.pwdLastSet).ToString('g')}}

        }

        elseif ($member.objectClass -eq "Group") {

        $userdom = (($member).CanonicalName).split("/")[0]

            Get-RecursiveGroupMembers -GroupName $member.Name -Domain "$userdom"

        }

    }

}




# list all domains

$domains = (get-ADForest).domains  + "sap.technion.ac.il"| sort




# Specify the group name

$adminGroupName = "Administrators"


# Get the recursive list of users in the Administrators group in all domains

$info = foreach ($domain in $domains) {Get-RecursiveGroupMembers -GroupName $adminGroupName -Domain $domain} 

# list only once per user and export to csv

#$info | sort UserDomain,SamAccountName | group DistinguishedName| %{($_.group)[0]}| export-csv c:\temp\ad-admins.csv -NoClobber -NoTypeInformation -Encoding utf8 -append
#$info | Sort-Object UserDomain, SamAccountName |group DistinguishedName | ForEach-Object { ($_.Group)[0] }| export-csv -Path:"C:\temp\ad-admins.csv" -NoClobber -NoTypeInformation -Encoding utf8 -append
#$info |  Group-Object SamAccountName | export-csv -Path:"C:\temp\ad-admins.csv" -NoClobber -NoTypeInformation -Encoding utf8 -append


$a= $info |  Group-Object SamAccountName
$b= $a | ForEach-Object { ($_.Group)[0] }
$b | export-csv -Path:"C:\temp\ad-admins.csv" -NoTypeInformation -Encoding utf8 -Force



#Export file to blob
Set-AzStorageBlobContent -Container "ad-admins-report" -File 'C:\temp\ad-admins.csv' -Blob "ad-admins.csv" -Force


$count= $b.count
write-output "The count is : $count"


#######################################
#Send email with the Attachment            
#Send-MailMessage -Bodyashtml -Encoding ([System.Text.Encoding]::UTF8) -Attachments 'ad-admins.csv' -Subject "AD Admins - report" -To: ms-group@technion.ac.il, igorfl@technion.ac.il -SmtpServer:"smtp.office365.com" -UseSsl -Port 587 -Credential:$cred -from: "cisreports@Technion.ac.il" 

#####################################################################################################################################################




############################
#Authenticate access with user-assigned managed identity
Write-Output "Connecting to azure via  Connect-AzAccount"  
Connect-AzAccount -Identity -AccountId '63e8121f-2c23-4db6-91bb-214b76db23fc' -subscription 'CIS-Technion (EA)'
$secret = Get-AzKeyVaultSecret -VaultName 'cis-key' -Name 'DefenderATPApp'
$ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue)  
try {  
  $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)  
} finally {  
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)  
} 


#Connect to MgGraph
$ApplicationId = "40499d1b-3c87-48f9-9cb3-bf2011658f74"
$SecuredPassword = $secretValueText
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
    Client_Secret = $secretValueText 
}   

$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$Tenantid/oauth2/v2.0/token" -Method POST -Body $tokenBody  


$headers = @{
        "Authorization" = "Bearer $($tokenResponse.access_token)"
        "Content-type"  = "application/json"
    }



#Configure Mail Properties
$MailSender = "cisreports@technion.ac.il"

$Attachment= "C:\temp\ad-admins.csv"
$FileName=(Get-Item -Path $Attachment).name
$base64string = [Convert]::ToBase64String([IO.File]::ReadAllBytes($Attachment))


#Send Mail    
$URLsend = "https://graph.microsoft.com/v1.0/users/$MailSender/sendMail"


$BodyJsonsend = @"
                    {
                        "message": {
                          "subject": "AD Admins - report",
                          "body": {
                            "contentType": "HTML",
                            "content": "This Mail is sent via Microsoft <br>
                           
                            "
                          },
                          
                          "toRecipients": [
                            {
                              "emailAddress": {
                                "address": "ms-group@technion.ac.il"
                              }
                             },
                             { 
                              "emailAddress": {
                                "address": "zeev@technion.ac.il"
                              }
                            }
                          ]              
                        ,"attachments": [
                            {
                              "@odata.type": "#microsoft.graph.fileAttachment",
                              "name": "$FileName",
                              "contentType": "HTML",
                              "contentBytes": "$base64string"
                            }
                          ]
                        },
                        "saveToSentItems": "false"
                      }
"@


Invoke-RestMethod -Method POST -Uri $URLsend -Headers $headers -Body $BodyJsonsend