$userCredentials = Get-AutomationPSCredential -Name 'Outlook365'


	$Script:psSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://email.technion.ac.il/powershell -Credential $userCredentials -Authentication Basic -AllowRedirection;
	$Script:importSession = Import-PSSession $psSession -AllowClobber
    Set-ADServerSettings -ViewEntireForest $true

Get-EmailAddressPolicy  | ? RecipientContainer -like "staff.technion.ac.il/Staff/*" | Update-EmailAddressPolicy


Connect-ExchangeOnline -Credential $userCredentials
$mbx = get-user -Filter {RecipientType -eq "UserMailbox" -and AuthenticationPolicy -eq $null} -ResultSize unlimited
$mbx | % {Set-User -Identity $_.id -AuthenticationPolicy defaultAuthenticationPolicy -Confirm:$false}
