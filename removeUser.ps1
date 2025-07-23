#Parameters
<#$TenantURL =  "https://mdho365.sharepoint.com/"
$UserID="i:0#.f|membership|jmattis@health.maryland.gov"
 
 
#Frame Tenant Admin URL from Tenant URL
#$TenantAdminURL = $TenantURL.Insert($TenantURL.IndexOf("."),"-admin")
#Connect to PnP Online
Connect-PnPOnline -Url $TenantAdminURL -UseWebLogin
 
#Get All Site collections - Filter BOT and MySite Host
$Sites = Get-PnPTenantSite -Filter "Url -like '$TenantURL'"
 
#Iterate through all sites
$Sites | ForEach-Object {
    Write-host "Searching in Site Collection:"$_.URL -f Yellow
    #Connect to each site collection
    $SiteConn = Connect-PnPOnline -Url $_.URL -UseWebLogin -ReturnConnection
    If((Get-PnPUser | Where {$_.LoginName -eq $UserID}) -ne $NULL)
    {
        #Remove user from site collection
        Remove-PnPUser -Identity $UserID -Confirm:$false
        Write-host "`tRemoved the User from Site:"$_.URL -f Green
    }
    Disconnect-PnPOnline -Connection $SiteConn
}


#Read more: https://www.sharepointdiary.com/2018/07/sharepoint-online-powershell-to-remove-user-from-all-sites.html#ixzz7VkfGtM7K#>

$SiteURL = "https://mdho365.sharepoint.com/teams/oea/"   
Connect-PnPOnline -Url $SiteURL  -useWebLogin
Get-PnPUser -Identity "dmurphy@yourdomain.com"
# Define user email
$userEmail = "user@yourdomain.com"
# Remove user permissions
Remove-PnPUser -LoginName $userEmail