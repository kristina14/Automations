$Cred = Get-AutomationPSCredential -Name "Outlook365";
$credLocal = Get-AutomationPSCredential -Name "Outlook365 local AD"
Connect-MSOLService -Credential:$Cred;
connect-azuread -Credential $cred

#connect exchange on prem
$Script:psSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://email.technion.ac.il/powershell -Credential $Cred -Authentication Basic -AllowRedirection;
$Script:importSession = Import-PSSession $psSession -AllowClobber
Set-ADServerSettings -ViewEntireForest $true


#Authenticate access with user-assigned managed identity
Write-Output "Connecting to azure via  Connect-AzAccount"  
Connect-AzAccount -Identity -AccountId '63e8121f-2c23-4db6-91bb-214b76db23fc' -subscription 'CIS-Technion (EA)'
$secret = Get-AzKeyVaultSecret -VaultName 'cis-key' -Name 'iis-oauthSe'
$ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue)  
try {  
  $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)  
} finally {  
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)  
} 


#Connect to MgGraph
$ApplicationId = "2be7d2f1-df99-48b8-b185-f00d005d241b"
$SecuredPassword = $secretValueText
$tenantID = "f1502c4c-ee2e-411c-9715-c855f6753b84"

$SecuredPasswordPassword = ConvertTo-SecureString `
-String $SecuredPassword -AsPlainText -Force

$ClientSecretCredential = New-Object `
-TypeName System.Management.Automation.PSCredential `
-ArgumentList $ApplicationId, $SecuredPasswordPassword

Connect-MgGraph -TenantId $tenantID -ClientSecretCredential $ClientSecretCredential

####

$staffusers = get-aduser -server staff.technion.ac.il -SearchBase "ou=staff,dc=staff,dc=technion,dc=ac,dc=il" -filter *  -Properties userprincipalname,whenchanged,MailNickName | ? { ($_.whenchanged -gt (Get-Date).AddDays(-5)) -and ($_.userprincipalname -notlike "*@g.technion.ac.il") } | select UserPrincipalName,SamAccountName,MailNickName


#check if the UPN in Azure is staff, if not  will change it  
            
    $count= $staffusers.count
    Write-Output "The count of staff users is : $count"

    foreach ($staffuser  in $staffusers) {
	#Variable username    
	$NewName = $staffuser.SamAccountName
    $OldName= $staffuser.MailNickName

    #check if the UPN in Azure is @staff
	$check = get-msoluser -UserPrincipalName "$NewName@technion.ac.il"
	if ($check){}  
        else {          
		                #if the Check is NOT @staff Change Suffix:
						#Get current UPN in Azure
                        $upn = (Get-AzureADUser -Filter "MailNickName eq '$oldname'").UserPrincipalName

                        #$upn=Get-MsolUser -all | ? {$_.UserPrincipalName -Like "$oldname@*"}
						#Update UPN to @staff in AZ

                        Set-MsolUserPrincipalName -UserPrincipalName "$upn" -NewUserPrincipalName "$NewName@technion.ac.il";
                        #$userupn= $NewName + "@technion.ac.il"
                        #update-mguser -UserId $upn -UserPrincipalName $userupn
                        Start-Sleep -s 60   

                        
                         #remove License with Graph
                          
                         $user = Get-MgUser -UserId "$NewName@technion.ac.il" -Select Id,UserPrincipalName,AssignedLicenses
                         $licencesToRemove = $user.AssignedLicenses | Select -ExpandProperty SkuId
                         $username= $user.UserPrincipalName
                         $user = Set-MgUserLicense -UserId $user.UserPrincipalName -RemoveLicenses $licencesToRemove -AddLicenses @{} 
                         Write-Output "User:$username"
                         Write-Output "Removed licenses:  $licencesToRemove"
                         

                         }

     #Update Prefix and MailNickName                    
     if($NewName -ne $OldName){ 
        if($OldName -eq $null){  }
        else{
        Set-MsolUserPrincipalName -UserPrincipalName "$upn" -NewUserPrincipalName "$NewName@technion.ac.il";
		
        Disable-RemoteMailbox  -domainController "staff-dc1.staff.technion.ac.il" $oldname
        Enable-RemoteMailbox -DomainController "staff-dc1.staff.technion.ac.il" "$username" -alias $NewName -RemoteRoutingAddress "$NewName@technionmail.mail.onmicrosoft.com"
		 #Get-RemoteMailbox -domainController "staff-dc1.staff.technion.ac.il" $name | Format-List
		 
        Set-ADUser $NewName -Server staff.technion.ac.il -Replace @{mailNickname = "$NewName"} -Credential $credLocal
        Write-Output "MailNickname and UPN changed from $Oldname to $newname"
        
        }

        #Disable-RemoteMailbox $OldName
        #Enable-RemoteMailbox -Identity $staffuser.UserPrincipalName -Alias $staffuser.SamAccountName -RemoteRoutingAddress "$($_.SamAccountName)@technionmail.mail.onmicrosoft.com"
                            
            }  

}
