$SiteUrl = "https://mdho365.sharepoint.com/sites/EPfMO/"
Connect-PnPOnline -Url $SiteUrl -UseWebLogin
Set-PnPTenantSite -Url $SiteUrl -DenyAddAndCustomizePages:$false