#Get-AutomationPSCredential -Name 'Outlook365 local AD'Connection to Msolservice
$userCredentials = Get-AutomationPSCredential -Name "Outlook365"
Connect-MsolService -Credential:$userCredentials  


#Config Settings for MFA COnfiguration (Enforced)
$st = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
$st.RelyingParty = "*"
$st.State = "Enforced"
$sta = @($st)


[string]$reportdate = "{0:yyyy-MM-dd}" -f (Get-Date)
#$dc = (Get-ADDomainController -Discover -DomainName staff.technion.ac.il).hostname

$credAD = Get-AutomationPSCredential -Name 'Outlook365 local AD'


#Function To connecxt to Exchange Local
function Connect-local
{
	$Script:psSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://email.technion.ac.il/powershell -Credential $userCredentials -Authentication Basic -AllowRedirection;
	$Script:importSession = Import-PSSession $psSession -AllowClobber
}


Connect-local 
Set-ADServerSettings -ViewEntireForest $true

#All Users who MailNickname= NULL from Staff, Campus and Alumni only (All Users in AD without Attributte Mailnickname is a new user)
$users = Get-ADUser -Filter * -SearchBase "dc=staff,dc=technion,dc=ac,dc=il" -server staff.technion.ac.il -Properties name,mailnickname,mail,DistinguishedName |  ? { (($_.mailnickname -eq $null) -and ($_.mail -like "*technion.ac.il")) }

#Enable Remote Mailbox for NEW USers - Update UPN - Assign License 
foreach ($user in $users) {
    $ou = $user.DistinguishedName
    $nameuser = $user.SamAccountName
    $UPN = $user.UserPrincipalName #Include @Domain

	  #Hybrid work= Set user settings in Local Exchange and Sync to Exchange Online (Remote=Local EX)

      Enable-RemoteMailbox -DomainController "staff-dc1.staff.technion.ac.il" "$upn" -alias $nameuser -RemoteRoutingAddress "$nameuser@technionmail.mail.onmicrosoft.com"
      Write-Output "Create Remote Mailbox for $upn";
      
      #Set License for Staff;  Alumni/Student Get Licence from Dinamic Group from Azure

	  if ($upn -like "*@technion.ac.il") {
		#$UPN = (get-msoluser -SearchString $nameuser).UserPrincipalName
        Set-MsolUser -UserPrincipalName $upn -UsageLocation IL
        Set-MsolUserLicense -UserPrincipalName $upn -AddLicenses "technionmail:STANDARDWOFFPACK_IW_FACULTY"
                 Write-Output "Add Staff Licenses to $upn"

                                                }    
 
 #Set Mailnickname in AD 
 Set-ADUser -Credential $credad -server staff.technion.ac.il -identity $nameuser -Replace @{MailNickName = "$nameuser"}   

 #Set Password Change in the NExt Logon
 Set-aduser -server staff.technion.ac.il -Identity $nameuser -ChangePasswordAtLogon $true -Credential $credAD 

 #Set MFA Enforced
 Set-MsolUser -UserPrincipalName $upn -StrongAuthenticationRequirements $sta

         Write-Output "MFA was Enabled and Licenses was assigned for $upn";


}
                                             
