$Cred = Get-AutomationPSCredential -Name "Outlook365";


Connect-AzureAD -Credential $Cred


$users = Get-AzureADUser -All $true| where-object {$_.PasswordPolicies -contains "DisablePasswordExpiration" }

#$users = $users | ? {($_.userprincipalname -ne "dirsync@alumni.technion.ac.il") -or ($_.userprincipalname -ne "outlook365@technion.ac.il")}

$users = $users | ? userprincipalname -ne dirsync@alumni.technion.ac.il 
$users = $users | ? userprincipalname -ne outlook365@technion.ac.il 

foreach ($user in $users ) {

   $name = $user.userprincipalname

   Set-AzureADUser -ObjectId $name -PasswordPolicies None

   write-output "Change passwordneverexpired for $name"

   

}