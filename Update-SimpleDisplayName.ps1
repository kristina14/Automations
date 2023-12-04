$userCredentials = Get-AutomationPSCredential -Name "Outlook365"

Connect-ExchangeOnline -Credential $userCredentials


$users = get-mailbox -resultsize unlimited -filter {(simpledisplayname -eq $null) -and (userprincipalname -like "*@technion.ac.il")}

   foreach ($user in $users){
     if (($user.name -like "*_*") -or ($user.name -like "*-*") -or ($user.name -like "*@*")) {} else {
     set-mailbox -identity $user.userprincipalname -simpledisplayname $user.name 

     write-output "$($user.name) was set for $($user.userprincipalname)"
     }
   }