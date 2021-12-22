$url = "https://alabamagov.sharepoint.com/sites/medicaid/MES"
$connection = Connect-PnPOnline -Url $url -UseWebLogin

$lists = Get-PnPList -Includes Fields

$output = "ListTitle,FieldTitle,FieldInternalName`n"
foreach($list in $lists) {
    $fields = $list.Fields | Select-Object Title, InternalName
    foreach ($field in $fields) {
        $output += "$($list.Title),$($field.Title),$($field.InternalName)`n"
    }
}
$output | Out-File -FilePath .\MES-Fields.csv