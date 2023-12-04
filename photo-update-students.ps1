#Credentials

$psCred = Get-AutomationPSCredential -Name 'Outlook365'
$adpr = Get-AutomationPSCredential -Name 'Outlook365 local AD'
Connect-ExchangeOnline -Credential $psCred 

#############################################
#Map the Drive from Sapftp

New-PSDrive -Name "w" -Root "\\cis-hybridw.cc.technion.ac.il\c$\SFTP"  -PSProvider  "FileSystem" -Credential $adpr -Persist
$path = 'w:\'
$csvpath = "$PATH" + "shared-images-status-PROD.csv"
$imgpath = "\\cis-hybridw.cc.technion.ac.il\c$\SFTP\profile_images_PROD"

############################################
#Import the CSV

$csv = import-csv $csvpath

############################################
#Edit the Picture File , split after .jpg to read only the ID 

$picsnames=(Get-ChildItem -Path "$path\profile_images_PROD" | ? name -like "*.jpg" -ErrorAction SilentlyContinue|sort).name | % {($_).split(".")[0]}
#Write-Output "Pics file name : $picsnames"

#############################################
#For each line of the CSV ; we check if the request has been made in the last 7 days and update or remove by request

foreach ($line in $csv){
    #$dateline = (($line.pic_change_date).replace('.','-'))
    $timestamp = $line.date
    $dateupdate  = ((Get-Date 01.01.1970)+([System.TimeSpan]::fromseconds($timestamp))).ToString("dd-MM-yyyy") 
    $dateupdates = [datetime]::parseExact($dateupdate, 'dd-MM-yyyy', $null)

    $approve= $line.allow_picture

	#If the User allow to Publish Photo and the request was in the last 7 days
   if ($dateupdates -gt (get-date).AddDays(-7)) {
    
    #Found the user in AD by ID
    $id = $line.username
    $id = $id.PadLeft(9,'0')
    $user = Get-ADUser -Server staff.technion.ac.il -Properties employeenumber,mail,primaryaccount -Filter {employeenumber -eq $id -and primaryaccount -eq "TRUE"} -Credential $adpr
     
      if($approve -eq '1'){
              write-output "Allow pic for $line"
          
          if ($user -and ($id -in $picsnames)) {
          #Found the File Picture Relevant for the user (by ID)

          $pic = Get-ChildItem -Path $imgpath  | ? name -eq "$($id).jpg" -ErrorAction SilentlyContinue
          $picture = $pic.Name
          $data = [System.IO.File]::ReadAllBytes("$imgpath\$picture")

		  #Upload Photo
          Set-UserPhoto -Identity $user.UserPrincipalName -PictureData $data -Confirm:$false
          write-output "Upload Photo for $($user.userprincipalname)"
          }
        else {
          write-output "Photo not exist"
        }
        }
       
     ################################################
     #if the user not approve to publish the Photo - remove
     else {
	     #$user = Get-ADUser -Server staff.technion.ac.il -Properties employeenumber,mail,primaryaccount -Filter {employeenumber -eq $id -and primaryaccount -eq "TRUE"} -Credential $adpr
       remove-UserPhoto -Identity $user.UserPrincipalName -Confirm:$false 
       write-output "Remove Photo for $($user.userprincipalname)"  
     } 
        } 
    }  