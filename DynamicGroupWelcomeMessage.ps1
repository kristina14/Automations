$Global:emailTemplate = @"
<style>
    .mdl-layout__container {
        position: absolute;
        width: 100%;
        height: 100%;
    }
    .mdl-layout {
        width: 100%;
        height: 100%;
        display: block;
        overflow-y: auto;
        overflow-x: hidden;
        position: relative;
        -webkit-overflow-scrolling: touch;
    }
    .mdl-layout__header {
        display: block;
        justify-content: right;
        box-sizing: border-box;
        width: 100%;
        margin: 0;
        padding: 0;
        border: none;
        min-height: 64px;
        max-height: 1000px;
        z-index: 3;
        background-color: rgb(63,81,181);
        color: rgb(255,255,255);
        box-shadow: 0 2px 2px 0 rgba(0,0,0,.14), 0 3px 1px -2px rgba(0,0,0,.2), 0 1px 5px 0 rgba(0,0,0,.12);
        transition-duration: .2s;
        transition-timing-function: cubic-bezier(.4,0,.2,1);
        transition-property: max-height,box-shadow;
    }
    .mdl-layout__header-row {
        border-radius: 10px 10px 0 0;
        direction: rtl;
        background-color: #000936;
        height: 120px;
    }
    .mdl-layout__header-row>* {
        -webkit-flex-shrink: 0;
        -ms-flex-negative: 0;
        flex-shrink: 0;
    }
    .mdl-layout__title, .mdl-layout-title {
        display: block;
        position: relative;
        font-size: 20px;
        line-height: 1;
        letter-spacing: .02em;
        font-weight: 400;
        box-sizing: border-box;
    }
    .mdl-layout__content {
        position: relative;
        display: inline-block;
        overflow-y: auto;
        overflow-x: hidden;
        direction: rtl;
        width: 100%;
        z-index: 1;
        -webkit-overflow-scrolling: touch;
    }
    .mdl-card {
        display: inline-block;
        font-size: 16px;
        font-weight: 400;
        min-height: 200px;
        overflow: hidden;
        width: 100%;
        z-index: 1;
        position: relative;
        box-sizing: border-box;
        background-color: transparent;/*#DCDAC0;*/
        direction: rtl;
        border-radius: 0 0 10px 10px;
        border-right: black solid 2px;
    }
    .mdl-shadow--2dp {
        box-shadow: 0 2px 2px 0 rgba(0,0,0,.14), 0 3px 1px -2px rgba(0,0,0,.2), 0 1px 5px 0 rgba(0,0,0,.12);
    }
    .mdl-card__title {
        -webkit-align-items: center;
        -ms-flex-align: center;
        align-items: center;
        color: #000;
        display: block;
        justify-content: stretch;
        line-height: normal;
        padding: 16px;
        -webkit-perspective-origin: 165px 56px;
        perspective-origin: 165px 56px;
        -webkit-transform-origin: 165px 56px;
        transform-origin: 165px 56px;
        box-sizing: border-box;
        direction: rtl;
    }
    .mdl-card__title-text {
        color: inherit;
        display: block;
        font-size: 24px;
        font-weight: 300;
        line-height: normal;
        overflow: hidden;
        direction: rtl;
        text-align: right;
        -webkit-transform-origin: 149px 48px;
        transform-origin: 149px 48px;
        margin: 0;
    }
    h1, h2, h3, h4, h5, h6, p {
        padding: 0;
    }
    .mdl-card__supporting-text {
        font-size: 1rem;
        line-height: 18px;
        overflow: hidden;
        padding: 16px;
        width: 90%;
        color: black;
    }
    .mdl-card__supporting-text.mdl-card--border {
        border-bottom: 1px solid rgba(0,0,0,.1);
    }
    #techlogo{
        height: 110px;
        margin: 5px;
    }

</style>
<div class="mdl-layout mdl-js-layout mdl-layout--fixed-header mdl-layout--no-desktop-drawer-button" style="width: 100%;height: 100%;display: block;overflow-y: auto;overflow-x: hidden;position: relative;-webkit-overflow-scrolling: touch;">
    <dvi class="mdl-layout__header" style="display: block;justify-content: right;box-sizing: border-box;width: 100%;margin: 0;padding: 0;border: none;min-height: 64px;max-height: 1000px;z-index: 3;background-color: rgb(63,81,181);color: rgb(255,255,255);box-shadow: 0 2px 2px 0 rgba(0,0,0,.14), 0 3px 1px -2px rgba(0,0,0,.2), 0 1px 5px 0 rgba(0,0,0,.12);transition-duration: .2s;transition-timing-function: cubic-bezier(.4,0,.2,1);transition-property: max-height,box-shadow;">
        <div class="mdl-layout__header-row" style="border-radius: 10px 10px 0 0;direction: rtl;background-color: #000936;height: 120px;">
            <img id="techlogo" class="mobile-hide" src="https://www.technion.ac.il/wp-content/themes/technion/images/heb/technionlogo270x105.png" style="-webkit-flex-shrink: 0;-ms-flex-negative: 0;flex-shrink: 0;height: 110px;margin: 5px;">
        </div>
    </dvi>
    <div class="mdl-layout__content" style="position: relative;display: inline-block;overflow-y: auto;overflow-x: hidden;direction: rtl;width: 100%;z-index: 1;-webkit-overflow-scrolling: touch;">
        <div class="mdl-card mdl-shadow--2dp" style="display: inline-block;font-size: 16px;font-weight: 400;min-height: 200px;overflow: hidden;width: 100%;z-index: 1;position: relative;box-sizing: border-box;background-color: transparent;direction: rtl;border-radius: 0 0 10px 10px;border-right: black solid 2px;box-shadow: 0 2px 2px 0 rgba(0,0,0,.14), 0 3px 1px -2px rgba(0,0,0,.2), 0 1px 5px 0 rgba(0,0,0,.12);">
            <div class="mdl-card__title" style="-webkit-align-items: center;-ms-flex-align: center;align-items: center;color: #000;display: block;justify-content: stretch;line-height: normal;padding: 16px;-webkit-perspective-origin: 165px 56px;perspective-origin: 165px 56px;-webkit-transform-origin: 165px 56px;transform-origin: 165px 56px;box-sizing: border-box;direction: rtl;">
                <h2 class="mdl-card__title-text" style="padding: 0;color: inherit;display: block;font-size: 24px;font-weight: 300;line-height: normal;overflow: hidden;direction: rtl;text-align: right;-webkit-transform-origin: 149px 48px;transform-origin: 149px 48px;margin: 0;">[MessageTitle]</h2>
            </div>
            <div class="mdl-card__supporting-text" style="font-size: 1rem;line-height: 18px;overflow: hidden;padding: 16px;width: 90%;color: black;">
                [EmailBody]
            </div>
        </div>
    </div>
</div>
"@;
function Get-AzureADSuperCreds(){
    $Cred = Get-AutomationPSCredential -Name "Sharepoint";
    return $Cred;
}
function Get-AzureADNormalCreds(){
    $Cred = Get-AutomationPSCredential -Name "Outlook365";
    return $Cred;
}
function Get-DynamicGroupEnvGroups(){
    $groups = @();

    $filter = "(user.userPrincipalName -contains ""stossel"") -or (user.userPrincipalName -contains ""ymoti"")";
    $groups+=@{'Name' = 'DynamicTestGroupA'; 'MailNickname' = 'DynamicTestGroupA'; 'Type' = 'user'; 'Filter' = $filter; 'Description' = 'Dynamic Group Test Env - GroupA'};

    return $groups;
}
function Get-DynamicGroupEnvGroupsFromSp(){
    $items = (Get-DynamicGroupEnvSpoListItems 'Lists/GroupsWelcomeMessage', @("ID","Title","AzureGroup","MessageTitle","MessageGreeting","MessageBody","MessageReturnEmail","FirstProcess"));
    $groups = @();
    foreach($item in $items){
        $groups+=@{
            'Id' = $item.ID;
            'AzureGroup' = ($item.AzureGroup).LookupValue;
            'MessageTitle' = $item.MessageTitle;
            'MessageGreeting' = $item.MessageGreeting;
            'MessageBody' = $item.MessageBody;
            'MessageReturnEmail' = $item.MessageReturnEmail;
            'FirstProcess' = $item.FirstProcess;
        };
    }
    return $groups;
}
function Install-DynamicGroupEnv(){

    $groups = Get-DynamicGroupEnvGroups;

    foreach($group in $groups){
        $groupName = $group.Name;
        $foundGroup = Get-AzureADMSGroup -Filter "DisplayName eq '$groupName'";
        if($null -ne $foundGroup){
            Write-Output "Found group in Azure: '$groupName'";
            if($foundGroup.groupTypes[0] -eq 'DynamicMembership'){
                Write-Output "Dynamic group: True";
                if($foundGroup.MembershipRule -ne $group.Filter){
                    Write-Output "Filter differ: True";
                    try{
                        $null = Set-AzureADMSGroup -Id $foundGroup.Id -MembershipRule $group.Filter -Description $group.Description
                    }
                    catch{
                        Write-Warning "Unable to update $groupName";
                    }
                }
                else{
                    Write-Output "Filter differ: False";
                }
            }
            else{
                Write-Output "  Dynamic group: FALSE"
                Write-Warning "  Unable to update group as it is not dynamic!"
            }
        }
        else{
            Write-Output "New Dynamic Group: $groupName"
            try {
                New-AzureADMSGroup -DisplayName $groupName -MailNickname $groupName -MembershipRule $group.Filter -Description $group.Description -MailEnabled:$false -MembershipRuleProcessingState 'On' -GroupTypes 'DynamicMembership' -SecurityEnabled:$true
            }
            catch {
                Write-Warning "  Unable to create the dynamic group!"
            }
        }
    }
}
function Uninstall-DynamicGroupEnv(){
    $groups = Get-DynamicGroupEnvGroups;

    foreach($group in $groups){
        $groupName = $group.Name;
        $foundGroup = Get-AzureADMSGroup -Filter "DisplayName eq '$groupName'";
        if($null -ne $foundGroup){
            Write-Output "Found group in Azure: '$groupName'";
            if($foundGroup.groupTypes[0] -eq 'DynamicMembership'){
                Write-Output "Dynamic group: True";
                try{
                    $null = Remove-AzureADMSGroup -Id $foundGroup.Id
                    Write-Warning " $groupName deleted";
                }
                catch{
                    Write-Warning " Unable to delete $groupName";
                }
            }
            else{
                Write-Output "  Dynamic group: FALSE"
                Write-Warning "  Unable to delete group as it is not dynamic!"
            }
        }
        else{
            Write-Output " Unable to delete group as dynamic group $groupName was not found!"
        }
    }
}
function Get-DynamicGroupEnvStatus(){
    $groups = Get-DynamicGroupEnvGroups;
    $flag = $true;

    foreach($group in $groups){
        $groupName = $group.Name;
        $foundGroup = Get-AzureADMSGroup -Filter "DisplayName eq '$groupName'";
        if($null -ne $foundGroup){
            Write-Output "Found group in Azure: '$groupName'";
            $foundGroup.ToJson();
        }
        else{
            Write-Output " Unable to find dynamic group $groupName!"
            $flag = $false;
        }
    }

    if($flag){
        Write-Output " Dynamic Groups Test Env setup correctly"
    }
    else{
        Write-Warning " Dynamic Groups Test Env failed to setup correctly"
    }
}
function Get-DynamicGroupEnvGroupsMembers(){
    $returnArray = @();
    $groups = Get-DynamicGroupEnvGroups;
    foreach($group in $groups){
        $currentGroupReturn = @{'Name' = $group.Name; 'Members' = @{};};
        $currentGroupsMemebers = @();
        $groupName = $group.Name;
        $foundGroup = Get-AzureADMSGroup -Filter "DisplayName eq '$groupName'";
        if($null -ne $foundGroup){
            #Write-Host "Found group in Azure: '$groupName'";
            foreach($member in (Get-AzureADGroupMember -ObjectId $foundGroup.Id))
            {
                $currentGroupsMemebers+=$member.userPrincipalName
            }
            $currentGroupReturn.Members = $currentGroupsMemebers;
            $returnArray+=$currentGroupReturn;
        }
        else{
            #Write-Host " Unable to find dynamic group $groupName!"
        }
    }

    return $returnArray;
}
function Get-DynamicGroupEnvGroupMembers($groupName){
    $GroupsMemebers = @();
    $foundGroup = Get-AzureADMSGroup -Filter "DisplayName eq '$groupName'";
    if($null -ne $foundGroup){
        #Write-Host "Found group in Azure: '$groupName'";
        foreach($member in (Get-AzureADGroupMember -ObjectId $foundGroup.Id))
        {
            $GroupsMemebers+=$member.userPrincipalName
        }
    }
    else{
        #Write-Host " Unable to find dynamic group $groupName!"
    }

    return $GroupsMemebers;
}
function Get-DynamicGroupEnvCustomAttributeValue($azureEmail){
    $customAttributeName = 'extension_6f9a371defc34621b3e6976c5bfdc5f6_technion_devops_group_welcome_message';
    return (Get-AzureADUserExtension -ObjectId (Get-AzureADUser -ObjectId $azureEmail).ObjectId)['extension_6f9a371defc34621b3e6976c5bfdc5f6_technion_devops_group_welcome_message']
}
function Send-DynamicGroupEnvWelcomeMessage($group, $to){

    $memberObj = Get-AzureADUser -ObjectId $to;
    $generalEmailTemplet = $Global:emailTemplate; #Get-Content -Path "emailTemplet.html";
    $bodtHtmlTemplet = "<p style='direction: rtl; text-align: right;'><b>[MessageGreeting]</b><br><br>[MessageBody]</p>";
    $generalEmailTemplet = $generalEmailTemplet.Replace('[EmailBody]', $bodtHtmlTemplet);

    $generalEmailTemplet = $generalEmailTemplet.replace("[MessageTitle]",$group.MessageTitle);
    $generalEmailTemplet = $generalEmailTemplet.replace("[MessageGreeting]",$group.MessageGreeting);
    $generalEmailTemplet = $generalEmailTemplet.replace("[MessageBody]",$group.MessageBody);

    $generalEmailTemplet = $generalEmailTemplet.replace("[GroupDisplayName]",$group.AzureGroup);
    $generalEmailTemplet = $generalEmailTemplet.replace("[UserDisplayName]",$memberObj.DisplayName);

    $generalEmailTemplet = $generalEmailTemplet.replace("[GroupDisplayName]",$group.AzureGroup);
    $generalEmailTemplet = $generalEmailTemplet.replace("[UserDisplayName]",$memberObj.DisplayName);

    $generalEmailTemplet = Start-DynamicGroupEnvYouTubeIframeEmbeder $generalEmailTemplet

    #if($to -eq "stossel@campus.technion.ac.il"){
        # -or $to -eq "ymoti@technion.ac.il"
        if((Get-DynamicGroupEnvIsUserGotMessage $to $group.AzureGroup) -eq 0){
            if(($group.MessageReturnEmail).Length -eq 0){
                Send-MailMessage -From "stossel@campus.technion.ac.il"   -To $to -BodyAsHtml "$generalEmailTemplet" -Subject "הודעת צירוף לקבוצה אוטומטית"  -Credential (Get-AzureADNormalCreds)  -smtpserver smtp.office365.com -Port 587 -UseSsl -Encoding UTF8 
            }
            else{
                Send-MailMessage2 -From "DoNotReply@technion.ac.il"   -To $to -BodyAsHtml "$generalEmailTemplet" -Subject "הודעת צירוף לקבוצה אוטומטית"  -Credential (Get-AzureADNormalCreds)  -smtpserver smtp.office365.com -Port 587 -UseSsl -ReplyTo $group.MessageReturnEmail 
            }
        }
    #}
}
function Start-DynamicGroupEnvYouTubeIframeEmbeder($string){
    $templateFrom = "[iframe_youtube]{Value:VideoId}[/iframe_youtube]";
    $templateTo = "<a href='https://www.youtube.com/watch?v=[VideoId]'><img style='margin: auto;' width='50%' src='https://img.youtube.com/vi/[VideoId]/0.jpg' frameborder='0' allow='autoplay; encrypted-media' allowfullscreen/></a>"
        
    try{
        $flag = $true;
        while($flag){
            $found = ($string | ConvertFrom-String -TemplateContent $templateFrom) | Select-Object -ExpandProperty Value
            $foundArray = $found.ToCharArray()
        
            $lastLetter =$foundArray[$foundArray.Length-1];
            if([int]$lastLetter -eq 8203){
                $foundArray = $foundArray[0..($foundArray.Length-2)]
            }
            
            $foundTest = -join $foundArray
            $string = $string.Replace("[iframe_youtube]$found[/iframe_youtube]", $templateTo.Replace("[VideoId]", $foundTest));
        }
    }
    catch{
        $flag = $false;
    }
    return $string;
}
function Set-DynamicGroupEnvFirstProcessStatus($group, $status){
    $nowDate = "{0:dd-MM-yyy hh:mm:ss}" -f (Get-Date);
    Set-PnPListItem -List "Lists/GroupsWelcomeMessage" -Identity $group.Id -Values @{"FirstProcess" = $status; "LastSync"=$nowDate} | Out-Null
}
function Send-MailMessage2
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true)]
        [Alias('PsPath')]
        [ValidateNotNullOrEmpty()]
        [string[]]
        ${Attachments},

        [ValidateNotNullOrEmpty()]
        [Collections.HashTable]
        ${InlineAttachments},
        
        [ValidateNotNullOrEmpty()]
        [Net.Mail.MailAddress[]]
        ${Bcc},
    
        [Parameter(Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]
        ${Body},
        
        [Alias('BAH')]
        [switch]
        ${BodyAsHtml},
    
        [ValidateNotNullOrEmpty()]
        [Net.Mail.MailAddress[]]
        ${Cc},

        [ValidateNotNullorEmpty()]
        [Net.Mail.MailAddress]
        ${ReplyTo},
    
        [Alias('DNO')]
        [ValidateNotNullOrEmpty()]
        [Net.Mail.DeliveryNotificationOptions]
        ${DeliveryNotificationOption},
    
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Net.Mail.MailAddress]
        ${From},
    
        [Parameter(Mandatory = $true, Position = 3)]
        [Alias('ComputerName')]
        [string]
        ${SmtpServer},
    
        [ValidateNotNullOrEmpty()]
        [Net.Mail.MailPriority]
        ${Priority},
        
        [Parameter(Mandatory=$true, Position=1)]
        [Alias('sub')]
        [ValidateNotNullOrEmpty()]
        [string]
        ${Subject},
    
        [Parameter(Mandatory=$true, Position=0)]
        [Net.Mail.MailAddress[]]
        ${To},
    
        [ValidateNotNullOrEmpty()]
        [Management.Automation.PSCredential]
        ${Credential},
    
        [switch]
        ${UseSsl},
    
        [ValidateRange(0, 2147483647)]
        [int]
        ${Port} = 25
    )
    
    begin
    {
        function FileNameToContentType
        {
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [string]
                $FileName
            )

            $mimeMappings = @{
                '.323' = 'text/h323'
                '.aaf' = 'application/octet-stream'
                '.aca' = 'application/octet-stream'
                '.accdb' = 'application/msaccess'
                '.accde' = 'application/msaccess'
                '.accdt' = 'application/msaccess'
                '.acx' = 'application/internet-property-stream'
                '.afm' = 'application/octet-stream'
                '.ai' = 'application/postscript'
                '.aif' = 'audio/x-aiff'
                '.aifc' = 'audio/aiff'
                '.aiff' = 'audio/aiff'
                '.application' = 'application/x-ms-application'
                '.art' = 'image/x-jg'
                '.asd' = 'application/octet-stream'
                '.asf' = 'video/x-ms-asf'
                '.asi' = 'application/octet-stream'
                '.asm' = 'text/plain'
                '.asr' = 'video/x-ms-asf'
                '.asx' = 'video/x-ms-asf'
                '.atom' = 'application/atom+xml'
                '.au' = 'audio/basic'
                '.avi' = 'video/x-msvideo'
                '.axs' = 'application/olescript'
                '.bas' = 'text/plain'
                '.bcpio' = 'application/x-bcpio'
                '.bin' = 'application/octet-stream'
                '.bmp' = 'image/bmp'
                '.c' = 'text/plain'
                '.cab' = 'application/octet-stream'
                '.calx' = 'application/vnd.ms-office.calx'
                '.cat' = 'application/vnd.ms-pki.seccat'
                '.cdf' = 'application/x-cdf'
                '.chm' = 'application/octet-stream'
                '.class' = 'application/x-java-applet'
                '.clp' = 'application/x-msclip'
                '.cmx' = 'image/x-cmx'
                '.cnf' = 'text/plain'
                '.cod' = 'image/cis-cod'
                '.cpio' = 'application/x-cpio'
                '.cpp' = 'text/plain'
                '.crd' = 'application/x-mscardfile'
                '.crl' = 'application/pkix-crl'
                '.crt' = 'application/x-x509-ca-cert'
                '.csh' = 'application/x-csh'
                '.css' = 'text/css'
                '.csv' = 'application/octet-stream'
                '.cur' = 'application/octet-stream'
                '.dcr' = 'application/x-director'
                '.deploy' = 'application/octet-stream'
                '.der' = 'application/x-x509-ca-cert'
                '.dib' = 'image/bmp'
                '.dir' = 'application/x-director'
                '.disco' = 'text/xml'
                '.dll' = 'application/x-msdownload'
                '.dll.config' = 'text/xml'
                '.dlm' = 'text/dlm'
                '.doc' = 'application/msword'
                '.docm' = 'application/vnd.ms-word.document.macroEnabled.12'
                '.docx' = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                '.dot' = 'application/msword'
                '.dotm' = 'application/vnd.ms-word.template.macroEnabled.12'
                '.dotx' = 'application/vnd.openxmlformats-officedocument.wordprocessingml.template'
                '.dsp' = 'application/octet-stream'
                '.dtd' = 'text/xml'
                '.dvi' = 'application/x-dvi'
                '.dwf' = 'drawing/x-dwf'
                '.dwp' = 'application/octet-stream'
                '.dxr' = 'application/x-director'
                '.eml' = 'message/rfc822'
                '.emz' = 'application/octet-stream'
                '.eot' = 'application/octet-stream'
                '.eps' = 'application/postscript'
                '.etx' = 'text/x-setext'
                '.evy' = 'application/envoy'
                '.exe' = 'application/octet-stream'
                '.exe.config' = 'text/xml'
                '.fdf' = 'application/vnd.fdf'
                '.fif' = 'application/fractals'
                '.fla' = 'application/octet-stream'
                '.flr' = 'x-world/x-vrml'
                '.flv' = 'video/x-flv'
                '.gif' = 'image/gif'
                '.gtar' = 'application/x-gtar'
                '.gz' = 'application/x-gzip'
                '.h' = 'text/plain'
                '.hdf' = 'application/x-hdf'
                '.hdml' = 'text/x-hdml'
                '.hhc' = 'application/x-oleobject'
                '.hhk' = 'application/octet-stream'
                '.hhp' = 'application/octet-stream'
                '.hlp' = 'application/winhlp'
                '.hqx' = 'application/mac-binhex40'
                '.hta' = 'application/hta'
                '.htc' = 'text/x-component'
                '.htm' = 'text/html'
                '.html' = 'text/html'
                '.htt' = 'text/webviewhtml'
                '.hxt' = 'text/html'
                '.ico' = 'image/x-icon'
                '.ics' = 'application/octet-stream'
                '.ief' = 'image/ief'
                '.iii' = 'application/x-iphone'
                '.inf' = 'application/octet-stream'
                '.ins' = 'application/x-internet-signup'
                '.isp' = 'application/x-internet-signup'
                '.IVF' = 'video/x-ivf'
                '.jar' = 'application/java-archive'
                '.java' = 'application/octet-stream'
                '.jck' = 'application/liquidmotion'
                '.jcz' = 'application/liquidmotion'
                '.jfif' = 'image/pjpeg'
                '.jpb' = 'application/octet-stream'
                '.jpe' = 'image/jpeg'
                '.jpeg' = 'image/jpeg'
                '.jpg' = 'image/jpeg'
                '.js' = 'application/x-javascript'
                '.jsx' = 'text/jscript'
                '.latex' = 'application/x-latex'
                '.lit' = 'application/x-ms-reader'
                '.lpk' = 'application/octet-stream'
                '.lsf' = 'video/x-la-asf'
                '.lsx' = 'video/x-la-asf'
                '.lzh' = 'application/octet-stream'
                '.m13' = 'application/x-msmediaview'
                '.m14' = 'application/x-msmediaview'
                '.m1v' = 'video/mpeg'
                '.m3u' = 'audio/x-mpegurl'
                '.man' = 'application/x-troff-man'
                '.manifest' = 'application/x-ms-manifest'
                '.map' = 'text/plain'
                '.mdb' = 'application/x-msaccess'
                '.mdp' = 'application/octet-stream'
                '.me' = 'application/x-troff-me'
                '.mht' = 'message/rfc822'
                '.mhtml' = 'message/rfc822'
                '.mid' = 'audio/mid'
                '.midi' = 'audio/mid'
                '.mix' = 'application/octet-stream'
                '.mmf' = 'application/x-smaf'
                '.mno' = 'text/xml'
                '.mny' = 'application/x-msmoney'
                '.mov' = 'video/quicktime'
                '.movie' = 'video/x-sgi-movie'
                '.mp2' = 'video/mpeg'
                '.mp3' = 'audio/mpeg'
                '.mpa' = 'video/mpeg'
                '.mpe' = 'video/mpeg'
                '.mpeg' = 'video/mpeg'
                '.mpg' = 'video/mpeg'
                '.mpp' = 'application/vnd.ms-project'
                '.mpv2' = 'video/mpeg'
                '.ms' = 'application/x-troff-ms'
                '.msi' = 'application/octet-stream'
                '.mso' = 'application/octet-stream'
                '.mvb' = 'application/x-msmediaview'
                '.mvc' = 'application/x-miva-compiled'
                '.nc' = 'application/x-netcdf'
                '.nsc' = 'video/x-ms-asf'
                '.nws' = 'message/rfc822'
                '.ocx' = 'application/octet-stream'
                '.oda' = 'application/oda'
                '.odc' = 'text/x-ms-odc'
                '.ods' = 'application/oleobject'
                '.one' = 'application/onenote'
                '.onea' = 'application/onenote'
                '.onetoc' = 'application/onenote'
                '.onetoc2' = 'application/onenote'
                '.onetmp' = 'application/onenote'
                '.onepkg' = 'application/onenote'
                '.osdx' = 'application/opensearchdescription+xml'
                '.p10' = 'application/pkcs10'
                '.p12' = 'application/x-pkcs12'
                '.p7b' = 'application/x-pkcs7-certificates'
                '.p7c' = 'application/pkcs7-mime'
                '.p7m' = 'application/pkcs7-mime'
                '.p7r' = 'application/x-pkcs7-certreqresp'
                '.p7s' = 'application/pkcs7-signature'
                '.pbm' = 'image/x-portable-bitmap'
                '.pcx' = 'application/octet-stream'
                '.pcz' = 'application/octet-stream'
                '.pdf' = 'application/pdf'
                '.pfb' = 'application/octet-stream'
                '.pfm' = 'application/octet-stream'
                '.pfx' = 'application/x-pkcs12'
                '.pgm' = 'image/x-portable-graymap'
                '.pko' = 'application/vnd.ms-pki.pko'
                '.pma' = 'application/x-perfmon'
                '.pmc' = 'application/x-perfmon'
                '.pml' = 'application/x-perfmon'
                '.pmr' = 'application/x-perfmon'
                '.pmw' = 'application/x-perfmon'
                '.png' = 'image/png'
                '.pnm' = 'image/x-portable-anymap'
                '.pnz' = 'image/png'
                '.pot' = 'application/vnd.ms-powerpoint'
                '.potm' = 'application/vnd.ms-powerpoint.template.macroEnabled.12'
                '.potx' = 'application/vnd.openxmlformats-officedocument.presentationml.template'
                '.ppam' = 'application/vnd.ms-powerpoint.addin.macroEnabled.12'
                '.ppm' = 'image/x-portable-pixmap'
                '.pps' = 'application/vnd.ms-powerpoint'
                '.ppsm' = 'application/vnd.ms-powerpoint.slideshow.macroEnabled.12'
                '.ppsx' = 'application/vnd.openxmlformats-officedocument.presentationml.slideshow'
                '.ppt' = 'application/vnd.ms-powerpoint'
                '.pptm' = 'application/vnd.ms-powerpoint.presentation.macroEnabled.12'
                '.pptx' = 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
                '.prf' = 'application/pics-rules'
                '.prm' = 'application/octet-stream'
                '.prx' = 'application/octet-stream'
                '.ps' = 'application/postscript'
                '.psd' = 'application/octet-stream'
                '.psm' = 'application/octet-stream'
                '.psp' = 'application/octet-stream'
                '.pub' = 'application/x-mspublisher'
                '.qt' = 'video/quicktime'
                '.qtl' = 'application/x-quicktimeplayer'
                '.qxd' = 'application/octet-stream'
                '.ra' = 'audio/x-pn-realaudio'
                '.ram' = 'audio/x-pn-realaudio'
                '.rar' = 'application/octet-stream'
                '.ras' = 'image/x-cmu-raster'
                '.rf' = 'image/vnd.rn-realflash'
                '.rgb' = 'image/x-rgb'
                '.rm' = 'application/vnd.rn-realmedia'
                '.rmi' = 'audio/mid'
                '.roff' = 'application/x-troff'
                '.rpm' = 'audio/x-pn-realaudio-plugin'
                '.rtf' = 'application/rtf'
                '.rtx' = 'text/richtext'
                '.scd' = 'application/x-msschedule'
                '.sct' = 'text/scriptlet'
                '.sea' = 'application/octet-stream'
                '.setpay' = 'application/set-payment-initiation'
                '.setreg' = 'application/set-registration-initiation'
                '.sgml' = 'text/sgml'
                '.sh' = 'application/x-sh'
                '.shar' = 'application/x-shar'
                '.sit' = 'application/x-stuffit'
                '.sldm' = 'application/vnd.ms-powerpoint.slide.macroEnabled.12'
                '.sldx' = 'application/vnd.openxmlformats-officedocument.presentationml.slide'
                '.smd' = 'audio/x-smd'
                '.smi' = 'application/octet-stream'
                '.smx' = 'audio/x-smd'
                '.smz' = 'audio/x-smd'
                '.snd' = 'audio/basic'
                '.snp' = 'application/octet-stream'
                '.spc' = 'application/x-pkcs7-certificates'
                '.spl' = 'application/futuresplash'
                '.src' = 'application/x-wais-source'
                '.ssm' = 'application/streamingmedia'
                '.sst' = 'application/vnd.ms-pki.certstore'
                '.stl' = 'application/vnd.ms-pki.stl'
                '.sv4cpio' = 'application/x-sv4cpio'
                '.sv4crc' = 'application/x-sv4crc'
                '.swf' = 'application/x-shockwave-flash'
                '.t' = 'application/x-troff'
                '.tar' = 'application/x-tar'
                '.tcl' = 'application/x-tcl'
                '.tex' = 'application/x-tex'
                '.texi' = 'application/x-texinfo'
                '.texinfo' = 'application/x-texinfo'
                '.tgz' = 'application/x-compressed'
                '.thmx' = 'application/vnd.ms-officetheme'
                '.thn' = 'application/octet-stream'
                '.tif' = 'image/tiff'
                '.tiff' = 'image/tiff'
                '.toc' = 'application/octet-stream'
                '.tr' = 'application/x-troff'
                '.trm' = 'application/x-msterminal'
                '.tsv' = 'text/tab-separated-values'
                '.ttf' = 'application/octet-stream'
                '.txt' = 'text/plain'
                '.u32' = 'application/octet-stream'
                '.uls' = 'text/iuls'
                '.ustar' = 'application/x-ustar'
                '.vbs' = 'text/vbscript'
                '.vcf' = 'text/x-vcard'
                '.vcs' = 'text/plain'
                '.vdx' = 'application/vnd.ms-visio.viewer'
                '.vml' = 'text/xml'
                '.vsd' = 'application/vnd.visio'
                '.vss' = 'application/vnd.visio'
                '.vst' = 'application/vnd.visio'
                '.vsto' = 'application/x-ms-vsto'
                '.vsw' = 'application/vnd.visio'
                '.vsx' = 'application/vnd.visio'
                '.vtx' = 'application/vnd.visio'
                '.wav' = 'audio/wav'
                '.wax' = 'audio/x-ms-wax'
                '.wbmp' = 'image/vnd.wap.wbmp'
                '.wcm' = 'application/vnd.ms-works'
                '.wdb' = 'application/vnd.ms-works'
                '.wks' = 'application/vnd.ms-works'
                '.wm' = 'video/x-ms-wm'
                '.wma' = 'audio/x-ms-wma'
                '.wmd' = 'application/x-ms-wmd'
                '.wmf' = 'application/x-msmetafile'
                '.wml' = 'text/vnd.wap.wml'
                '.wmlc' = 'application/vnd.wap.wmlc'
                '.wmls' = 'text/vnd.wap.wmlscript'
                '.wmlsc' = 'application/vnd.wap.wmlscriptc'
                '.wmp' = 'video/x-ms-wmp'
                '.wmv' = 'video/x-ms-wmv'
                '.wmx' = 'video/x-ms-wmx'
                '.wmz' = 'application/x-ms-wmz'
                '.wps' = 'application/vnd.ms-works'
                '.wri' = 'application/x-mswrite'
                '.wrl' = 'x-world/x-vrml'
                '.wrz' = 'x-world/x-vrml'
                '.wsdl' = 'text/xml'
                '.wvx' = 'video/x-ms-wvx'
                '.x' = 'application/directx'
                '.xaf' = 'x-world/x-vrml'
                '.xaml' = 'application/xaml+xml'
                '.xap' = 'application/x-silverlight-app'
                '.xbap' = 'application/x-ms-xbap'
                '.xbm' = 'image/x-xbitmap'
                '.xdr' = 'text/plain'
                '.xla' = 'application/vnd.ms-excel'
                '.xlam' = 'application/vnd.ms-excel.addin.macroEnabled.12'
                '.xlc' = 'application/vnd.ms-excel'
                '.xlm' = 'application/vnd.ms-excel'
                '.xls' = 'application/vnd.ms-excel'
                '.xlsb' = 'application/vnd.ms-excel.sheet.binary.macroEnabled.12'
                '.xlsm' = 'application/vnd.ms-excel.sheet.macroEnabled.12'
                '.xlsx' = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                '.xlt' = 'application/vnd.ms-excel'
                '.xltm' = 'application/vnd.ms-excel.template.macroEnabled.12'
                '.xltx' = 'application/vnd.openxmlformats-officedocument.spreadsheetml.template'
                '.xlw' = 'application/vnd.ms-excel'
                '.xml' = 'text/xml'
                '.xof' = 'x-world/x-vrml'
                '.xpm' = 'image/x-xpixmap'
                '.xps' = 'application/vnd.ms-xpsdocument'
                '.xsd' = 'text/xml'
                '.xsf' = 'text/xml'
                '.xsl' = 'text/xml'
                '.xslt' = 'text/xml'
                '.xsn' = 'application/octet-stream'
                '.xtp' = 'application/octet-stream'
                '.xwd' = 'image/x-xwindowdump'
                '.z' = 'application/x-compress'
                '.zip' = 'application/x-zip-compressed'
            }

            $extension = [System.IO.Path]::GetExtension($FileName)
            $contentType = $mimeMappings[$extension]

            if ([string]::IsNullOrEmpty($contentType))
            {
                return New-Object System.Net.Mime.ContentType
            }
            else
            {
                return New-Object System.Net.Mime.ContentType($contentType)
            }
        }

        try
        {
            $_smtpClient = New-Object Net.Mail.SmtpClient
        
            $_smtpClient.Host = $SmtpServer
            $_smtpClient.Port = $Port
            $_smtpClient.EnableSsl = $UseSsl

            if ($null -ne $Credential)
            {
                # In PowerShell 2.0, assigning the results of GetNetworkCredential() to the SMTP client sometimes fails (with gmail, in testing), but
                # building a new NetworkCredential object containing only the UserName and Password works okay.

                $_tempCred = $Credential.GetNetworkCredential()
                $_smtpClient.Credentials = New-Object Net.NetworkCredential($Credential.UserName, $_tempCred.Password)
            }
            else
            {
                $_smtpClient.UseDefaultCredentials = $true
            }

            $_message = New-Object Net.Mail.MailMessage
        
            $_message.From = $From
            $_message.Subject = $Subject
            
            $Encode = [System.Text.Encoding]::UTF8;
            $_message.Body = $Body;
            $_message.BodyEncoding = [System.Text.Encoding]::UTF8;
            $_message.IsBodyHtml = $true;
            
            <#
            if ($BodyAsHtml)
            {
                $_bodyPart = [Net.Mail.AlternateView]::CreateAlternateViewFromString($Body, $Encode, [Net.Mime.MediaTypeNames]::Text.html)
            }
            else
            {
                $_bodyPart = [Net.Mail.AlternateView]::CreateAlternateViewFromString($Body, $Encode, [Net.Mime.MediaTypeNames]::Text.Plain)
            } 
            #>  

            #$_message.AlternateViews.Add($_bodyPart)

            if ($PSBoundParameters.ContainsKey('DeliveryNotificationOption')) { $_message.DeliveryNotificationOptions = $DeliveryNotificationOption }
            if ($PSBoundParameters.ContainsKey('Priority')) { $_message.Priority = $Priority }

            foreach ($_address in $To)
            {
                if (-not $_message.To.Contains($_address)) { $_message.To.Add($_address) }
            }

            if ($null -ne $Cc)
            {
                foreach ($_address in $Cc)
                {
                    if (-not $_message.CC.Contains($_address)) { $_message.CC.Add($_address) }
                }
            }

            if ($null -ne $Bcc)
            {
                foreach ($_address in $Bcc)
                {
                    if (-not $_message.Bcc.Contains($_address)) { $_message.Bcc.Add($_address) }
                }
            }

            if ($null -ne $ReplyTo)
            {
                $_message.ReplyTo = $ReplyTo
            }
        }
        catch
        {
            $_message.Dispose()
            throw
        }

        if ($PSBoundParameters.ContainsKey('InlineAttachments'))
        {
            foreach ($_entry in $InlineAttachments.GetEnumerator())
            {
                $_file = $_entry.Value.ToString()
                
                if ([string]::IsNullOrEmpty($_file))
                {
                    $_message.Dispose()
                    throw "Send-MailMessage: Values in the InlineAttachments table cannot be null."
                }

                try
                {
                    $_contentType = FileNameToContentType -FileName $_file
                    $_attachment = New-Object Net.Mail.LinkedResource($_file, $_contentType)
                    $_attachment.ContentId = $_entry.Key

                    $_bodyPart.LinkedResources.Add($_attachment)
                }
                catch
                {
                    $_message.Dispose()
                    throw
                }
            }
        }
    }

    process
    {
        if ($null -ne $Attachments)
        {
            foreach ($_file in $Attachments)
            {
                try
                {
                    $_contentType = FileNameToContentType -FileName $_file
                    $_message.Attachments.Add((New-Object Net.Mail.Attachment($_file, $_contentType)))
                }
                catch
                {
                    $_message.Dispose()
                    throw
                }
            }
        }
    }
    
    end
    {
        try
        {
            $_smtpClient.Send($_message)
        }
        catch
        {
            throw
        }
        finally
        {
            $_message.Dispose()
        }
    }

} # function Send-MailMessage
function Start-DynamicGroupEnvEmailSend(){
    $groups = Get-DynamicGroupEnvGroupsFromSp;
    foreach($group in $groups){
        $members = Get-DynamicGroupEnvGroupMembers $group.AzureGroup
        if($group.FirstProcess -eq 0){
            foreach($member in $members){
                Send-DynamicGroupEnvWelcomeMessage $group $member;
            }
        }
        else{
            foreach($member in $members){
                Get-DynamicGroupEnvIsUserGotMessage $member $group.AzureGroup
            }
        } 
        (Set-DynamicGroupEnvFirstProcessStatus $group 0) | Out-Null
    }

    return 1;
}
function Start-PsoSession($un = $False, $pass = $False){
    $connection = Connect-PnPOnline -Url "https://technionmail.sharepoint.com/sites/CIS/infs/dev/365ext" -Credential (Get-AzureADSuperCreds);
    return $connection;
}
function Get-DynamicGroupEnvSpoListItems($listId, $properties){
    $connection = Start-PsoSession;
    $listObj = Get-PnPList -Identity ("{0}" -f ($listId)) -Connection $connection
    $listItems = Get-PnPListItem -List $listObj -Connection $connection;
    $Items = New-Object System.Collections.ArrayList($null); 
    
    foreach($item in $listItems){
        $id = $item | Select-Object -ExpandProperty "Id";
        $returnItem = (Get-PnPListItem -List $listObj -Id $id -Fields $properties -Connection $connection);
        $fields = $returnItem.FieldValues
        $Items.Add($fields) | Out-Null;
    }

    return $Items;
}
function Get-DynamicGroupEnvIsUserGotMessage($user, $groupName){

    $groupId = (Get-AzureADGroup -SearchString "$groupName").ObjectId;
    $technion_devops_group_welcome_message = (Get-AzureADUserExtension -ObjectId (Get-AzureADUser -ObjectId $user).ObjectId)['extension_6f9a371defc34621b3e6976c5bfdc5f6_technion_devops_group_welcome_message'];
    if($technion_devops_group_welcome_message.Length -eq 0){
        Set-DynamicGroupEnvIsUserGotMessage $user $groupId $technion_devops_group_welcome_message;
        return 0;
    }
    else{
        $groupIdArray = $technion_devops_group_welcome_message.Split(',');
        if(($groupIdArray | Where-Object { $_ -eq $groupId}).count -eq 0){
            Set-DynamicGroupEnvIsUserGotMessage $user $groupId $technion_devops_group_welcome_message;
            return 0;
        }
        else{
            return 1;
        }
    }
}
function Set-DynamicGroupEnvIsUserGotMessage($user, $groupId, $technion_devops_group_welcome_message){
    if($technion_devops_group_welcome_message.Length -eq 0){
        $groupIdArray = @("$groupId");
        $groupIdString = [system.String]::Join(',', $groupIdArray);
    }
    else{
        $groupIdArray = $technion_devops_group_welcome_message.Split(',');
        $groupIdArray+=@("$groupId")
        $groupIdString = [system.String]::Join(',', $groupIdArray);
    }

    $properyId = 'extension_6f9a371defc34621b3e6976c5bfdc5f6_technion_devops_group_welcome_message';
    Set-AzureADUserExtension -ObjectId (Get-AzureADUser -ObjectId $user).ObjectId -ExtensionName $properyId -ExtensionValue $groupIdString
}

Connect-AzureAD -Credential (Get-AzureADSuperCreds);
#Add-AzureAccount -Credential (Get-AzureADSuperCreds);
Start-DynamicGroupEnvEmailSend
