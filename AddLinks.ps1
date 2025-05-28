# Variables
$siteUrl = "https://mdho365.sharepoint.com/sites/ePREP-CERT"
$csvPath = "C:\code\shiny-octo-garbanzo\TopNavLinks.csv" #csv path
 
# Connect to SharePoint site
Connect-PnPOnline -Url $siteUrl -UseWebLogin
$NavLocation="TopNavigationBar" #"QuickLaunch" 
 
# Import CSV data
$navItems = Import-Csv -Path $csvPath
 
# Iterate through each item in the CSV
foreach ($item in $navItems) {
    # If there's no ParentTitle, it's a top-level link
    if ([string]::IsNullOrEmpty($item.ParentTitle)) {
        $parentNode = Add-PnPNavigationNode -Title $item.Title -Url $item.Url -Location $NavLocation
    }
    else {
        # Find the parent node by title
        $parentNode = Get-PnPNavigationNode -Location $NavLocation | Where-Object { $_.Title -eq $item.ParentTitle }
        if ($parentNode) {
            Add-PnPNavigationNode -Title $item.Title -Url $item.Url -Location $NavLocation -Parent $parentNode
        }
        else {
            Write-Host "Parent node '$($item.ParentTitle)' not found for child '$($item.Title)'"
        }
    }
}
 
# Clean up and disconnect
Disconnect-PnPOnline