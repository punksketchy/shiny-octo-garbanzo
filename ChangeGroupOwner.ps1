$siteURL="https://alabamagov.sharepoint.com/sites/Medicaid-MESModularity"
Connect-PnPOnline -Url $siteURL -Interactive

$groupOwner="SharePoint Group Owners"
$groupFile="C:\Users\217366\Downloads\SandboxGroups.csv"
$csv=Import-Csv $groupFile

foreach($group in $csv) {
    Write-Host "Changing Group Owners"
    Set-PnPGroup -Identity $csv -Owner $groupOwner
}


