$url = "https://nttdatagroup.sharepoint.com/sites/SRVS-PS-SHC-DMT-DEV"
$connection = Connect-PnPOnline -Url $url -UseWebLogin

$allLists = Get-PnPList

foreach ($list in $allLists) {
    Remove-PnPListItem -List $list.Title -Force
}