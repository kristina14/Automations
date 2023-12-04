Param
(
  [Parameter (Mandatory= $true)]
  [object] $DisplayName,

  [Parameter (Mandatory= $true)]
  [object] $Email,

  [Parameter (Mandatory= $true)]
  [object] $Message
)

<#
Example Data
@{"DisplayName"="Stossel Yarden";"Email"="yarden6260@gmail.com";"Message"="Hello World"}
#>

Connect-AzureAD -Credential (Get-AutomationPSCredential -Name "Sharepoint");

$userName = $DisplayName;
$userEmail = $Email;
$message = $Message;
$redirectUrl = 'https://bookme.technion.ac.il';
$messageInfo = New-Object Microsoft.Open.MSGraph.Model.InvitedUserMessageInfo;
$messageInfo.customizedMessageBody = $redirectUrl;
$bookme_guest_group_oid = '83190442-3a46-4d66-8ff8-903dff96e252';

if($message.Length -gt 0){
    New-AzureADMSInvitation -InvitedUserDisplayName $userName -InvitedUserEmailAddress $userEmail -SendInvitationMessage $true -InvitedUserMessageInfo $messageInfo -InviteRedirectUrl $redirectUrl 
}
else{
    New-AzureADMSInvitation -InvitedUserDisplayName $userName -InvitedUserEmailAddress $userEmail -SendInvitationMessage $false -InviteRedirectUrl $redirectUrl 
}

$user = Get-AzureADUser -Filter ("mail eq '{0}'" -f $userEmail)
Add-AzureADGroupMember -ObjectId $bookme_guest_group_oid -RefObjectId $user.ObjectId