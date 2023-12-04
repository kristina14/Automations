Param
(
 [string] $Email,
 [string] $user_id,
 [string] $image_type

)

write-output "Email is: $Email"
write-output "Id is: $user_id"
write-output "Id is: $image_type"


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
