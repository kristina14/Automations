Param (
    [object] $WebhookData
)
# Structure Webhook Input Data
If ($WebhookData.WebhookName) {
    $WebhookName     =     $WebhookData.WebhookName
    $WebhookHeaders  =     $WebhookData.RequestHeader
    $WebhookBody     =     $WebhookData.RequestBody

} ElseIf ($WebhookData) {
    $WebhookJSON = ConvertFrom-Json -InputObject $WebhookData
    $WebhookName     =     $WebhookJSON.WebhookName
    $WebhookHeaders  =     $WebhookJSON.RequestHeader
    $WebhookBody     =     $WebhookJSON.RequestBody
} Else {
   Write-Error -Message 'Runbook was not started from Webhook' -ErrorAction stop
}
$data = $WebhookBody | ConvertFrom-Json
$email= $data[0].email
$image_type= $data[0].image_type
$user_id= $data[0].user_id
write-output "$email ,$image_type,  $user_id "

#Credentials
$psCred = Get-AutomationPSCredential -Name 'Outlook365'
$adpr = Get-AutomationPSCredential -Name 'Outlook365 local AD'
Connect-ExchangeOnline -Credential $psCred 

#Map the Drive from Sapftp
#New-PSDrive -Name "s" -Root "\\sapftp.sap.technion.ac.il\hr$\TDP\PHONEBOOK\Pictures"  -PSProvider  "FileSystem" -Credential $adpr -Persist
$path = 'p:\'

#Complete IdNum to 9 digits
$user_id = $user_id.PadLeft(9,'0')
write-output "Id after complete: $user_id"


#Get user from local AD by ID
$user = Get-ADUser -Server staff.technion.ac.il -Properties employeenumber,mail,primaryaccount -Filter {employeenumber -eq $user_id -and primaryaccount -eq "TRUE"} -Credential $adpr
    

#Edit the Picture File , split after .jpg to read only the ID 
$picsnames=(Get-ChildItem -Path $path | ? name -like "*.jpg" -ErrorAction SilentlyContinue|sort).name | % {($_).split(".")[0]}

if ($user -and ($user_id -in $picsnames)) {
          #Found the File Picture Relevant for the user (by ID)
          $pic = Get-ChildItem -Path $path | ? name -eq "$($user_id).jpg" -ErrorAction SilentlyContinue
          $picture = $pic.Name
          write-output "Picture name : $picture"

          $data = [System.IO.File]::ReadAllBytes("\\sapftp.sap.technion.ac.il\hr$\TDP\PHONEBOOK\Pictures\$picture")

          #Upload the Photo
          Set-UserPhoto -Identity $user.UserPrincipalName -PictureData $data -Confirm:$false
          write-output "Upload Photo for user: $($user.userprincipalname) id: $user_id"
}