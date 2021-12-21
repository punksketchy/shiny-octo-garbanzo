$siteCollection = "https://alabamagov.sharepoint.com/sites/Medicaid-MESModularity/MESPMO"
$connection = Connect-PnPOnline -Url $siteCollection -PnPManagementShell

$lists = Get-PnPList -Includes Fields
$listTitle = Get-PnPList
foreach($list in $lists) {
    $list.Fields | Select-Object Title, InternalName, @{
        label='List Title'
        expression={$listTitle | Select-Object Title}
    }
}