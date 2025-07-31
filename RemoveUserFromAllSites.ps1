<#param(
    [Parameter(Mandatory = $true)]
    "https://mdho365.sharepoint.com/teams/oea/PMO/" = $SiteCollectionUrl,

    [Parameter(Mandatory = $true)]
    "Shanna Summons" = $UserLogin
)#>

$SiteCollectionUrl = "https://mdho365.sharepoint.com/sites/MMT-CERT"
$UserLogin = "Betty Edwards"

# Connect to the site collection
Connect-PnPOnline -Url $SiteCollectionUrl -UseWebLogin

# Get all webs (including root web)
$webs = Get-PnPSubWeb -Recurse
$webs += Get-PnPWeb

foreach ($web in $webs) {
    Write-Host "Processing site: $($web.Url)"
    try {
        # Remove user from the web
        Remove-PnPUser -LoginName $UserLogin -Web $web -ErrorAction Stop
        Write-Host "Removed $UserLogin from $($web.Url)"
    } catch {
        Write-Warning "Could not remove $UserLogin from $($web.Url): $_"
    }
}
