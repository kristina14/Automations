<#
Param
(
  [Parameter (Mandatory= $true)]
  [object] $DisplayName,

  [Parameter (Mandatory= $true)]
  [object] $Email,

  [Parameter (Mandatory= $true)]
  [object] $Message

  [Parameter (Mandatory= $false)]
  [object] $guest_group_oid = 'ef73e3f7-a0e0-4d1b-abb5-2931aba14dad' # The default oid is of 'EI Guest Users'
)

<#
Example Data
@{"DisplayName"="Stossel Yarden";"Email"="yarden6260@gmail.com";"Message"="Hello World"}
#>

<#
Connect-AzureAD -Credential (Get-AutomationPSCredential -Name "Outlook365");

$userName = $DisplayName;
$userEmail = $Email;
$message = $Message;
$redirectUrl = 'https://technion.ac.il';
$messageInfo = New-Object Microsoft.Open.MSGraph.Model.InvitedUserMessageInfo;
$messageInfo.customizedMessageBody = $message;

if($message.Length -gt 0){
    New-AzureADMSInvitation -InvitedUserDisplayName $userName -InvitedUserEmailAddress $userEmail -SendInvitationMessage $true -InvitedUserMessageInfo $messageInfo -InviteRedirectUrl $redirectUrl 
}
else{
    New-AzureADMSInvitation -InvitedUserDisplayName $userName -InvitedUserEmailAddress $userEmail -SendInvitationMessage $false -InviteRedirectUrl $redirectUrl 
}

$user = Get-AzureADUser -Filter ("mail eq '{0}'" -f $userEmail)
Add-AzureADGroupMember -ObjectId $guest_group_oid -RefObjectId $user.ObjectId

