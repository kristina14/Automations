#Get all the PArameters (Responses) from the Form
Param
(
  [Parameter (Mandatory= $true)]
  [string] $Email,

  [Parameter (Mandatory= $true)]
  [string] $Question1,

  [Parameter (Mandatory= $true)]
  [string] $Question2,

  [Parameter (Mandatory= $true)]
  [string] $Question3
  
)

#Connect to Azure
$Cred = Get-AutomationPSCredential -Name "Outlook365";
Connect-MSOLService -Credential:$Cred;


######ADD item to list in Sharepoint
function write-sharepointlist ($UPN,$multiuser,$MfaEnabled) {

$newlist = Add-PnPListItem -List "MFA" -Values @{"UPN"="$UPN";"MultipleUsers"="$multiuser";"MFAEnabled"= $MfaEnabled}
}

$url = "https://technionmail.sharepoint.com/sites/CIS/infs/microsoft"

Connect-PnPOnline -Url "$url" -Credential ($cred)


Import-Module MSOnline;


if ((($Question1 -eq "כן") -or ($Question1 -eq "Yes")) -and (($Question3 -eq "כן")-or ($Question3 -eq "Yes")) )
{

$st = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
$st.RelyingParty = "*"
$st.State = "Enforced"
$sta = @($st)


Set-MsolUser -UserPrincipalName $email -StrongAuthenticationRequirements $sta

write-sharepointlist -upn $email -multiuser $Question2 -mfaenabled $Question3

}
 else {
    write-sharepointlist -upn $email -multiuser $Question2 -mfaenabled $Question3
  
 }


