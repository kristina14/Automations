$Cred = Get-AutomationPSCredential -Name "Outlook365";
$credLocal = Get-AutomationPSCredential -Name "Outlook365 local AD"
Connect-MSOLService -Credential:$Cred;
connect-azuread -Credential $cred

#connect exchange on prem
$Script:psSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://email.technion.ac.il/powershell -Credential $Cred -Authentication Basic -AllowRedirection;
$Script:importSession = Import-PSSession $psSession -AllowClobber
Set-ADServerSettings -ViewEntireForest $true

#Graph
$key = Get-AzKeyVaultSecret -VaultName 'cis-key' -Name 'iis-oauthSe' -AsPlainText
$appid = "2be7d2f1-df99-48b8-b185-f00d005d241b"
$tenantid = "f1502c4c-ee2e-411c-9715-c855f6753b84"

$url = "https://login.microsoftonline.com/$tenantId/oauth2/token"
$resource = "https://graph.microsoft.com/"
$restbody = @{
        grant_type    = 'client_credentials'
        client_id     = $appid
        client_secret = $Key
        resource      = $resource
}

$token = Invoke-RestMethod -Method POST -Uri $url -Body $restbody

connect-graph -AccessToken $token.access_token

#All users in OU Stud that was changed in the last 5 days  - This happens in AD Local 
$campususers = get-aduser -server staff.technion.ac.il -SearchBase "ou=stud,dc=staff,dc=technion,dc=ac,dc=il" -filter * -Properties whenchanged,MailNickName | ? {$_.whenchanged -gt (Get-Date).AddDays(-5)} | select UserPrincipalName,SamAccountName,MailNickName

$count = $campususers.count
Write-Output " The count of users is: $count"	
$count= $null

#check if the UPN in Azure is campus, if not  will change it  
    foreach ($campususer in $campususers) {
	#Variable username    
	$NewName = $campususer.SamAccountName
    $OldName= $campususer.MailNickName
    
    #$count++ 
    #Write-Output " The $count user is: $campususer"
    #Write-Output " User SamAccountName (new): $NewName"
    #Write-Output " User MailNickName (old): $OldName"

    #check if the UPN in Azure is @campus
	$check = get-msoluser -UserPrincipalName "$NewName@campus.technion.ac.il"
	if ($check){}  
        else {
		                #if the Check is NOT @campus Change Suffix:
						#Get current UPN in Azure
                        $upn = (Get-AzureADUser -Filter "MailNickName eq '$oldname'").UserPrincipalName

                        #$upn=Get-MsolUser -all | ? {$_.UserPrincipalName -Like "$oldname@*"}
					      
                        #remove License with Graph
                          #When the User is part of the Campus group (dinamic group in Azure) ,the new license for CAMPUS will be assigned automatically 
                          $user = Get-MgUser -UserId "$upn" -Select Id,UserPrincipalName,AssignedLicenses
                          $licencesToRemove = $user.AssignedLicenses | Select -ExpandProperty SkuId
                          $username= $user.UserPrincipalName
                          $user = Set-MgUserLicense -UserId $user.UserPrincipalName -RemoveLicenses $licencesToRemove -AddLicenses @{} 
                          Write-Output "User:$username"
                          Write-Output "Removed licenses:  $licencesToRemove"

						#Update UPN to @campus in AZ
                        Set-MsolUserPrincipalName -UserPrincipalName "$upn" -NewUserPrincipalName "$NewName@campus.technion.ac.il";
                        Start-Sleep -s 5       
                         }

     #Update Prefix and MailNickName                    
     if($NewName -ne $OldName){ 
		 if($oldname -eq $null){}
		 else{
        Set-MsolUserPrincipalName -UserPrincipalName "$upn" -NewUserPrincipalName "$NewName@campus.technion.ac.il";
		
		Disable-RemoteMailbox  -domainController "staff-dc1.staff.technion.ac.il" $oldname
        Enable-RemoteMailbox -DomainController "staff-dc1.staff.technion.ac.il" "$username" -alias $NewName -RemoteRoutingAddress "$NewName@technionmail.mail.onmicrosoft.com"

        Set-ADUser $NewName -Server staff.technion.ac.il -Replace @{mailNickname = "$NewName"} -Credential $credLocal
        Write-Output "MailNickname and UPN changed from $Oldname to $newname"
        
        #Disable-RemoteMailbox $OldName
        #Enable-RemoteMailbox -Identity $campususer.UserPrincipalName -Alias $campususer.SamAccountName -RemoteRoutingAddress "$($_.SamAccountName)@technionmail.mail.onmicrosoft.com"
		 }
                  }   

}
