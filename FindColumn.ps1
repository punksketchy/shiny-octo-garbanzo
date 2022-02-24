#To Use, replace the $url with the site you are getting the fields
$url = "https://amagcc.sharepoint.com/sites/MESModularity/AMMP-Procurement-Services/AMMP-Procurement-SI/"
$connection = Connect-PnPOnline -Url $url -UseWebLogin

$lists = Get-PnPList -Includes Fields

$output = "ListTitle,FieldTitle,FieldInternalName`n"
foreach($list in $lists) {
    $fields = $list.Fields | Select-Object Title, InternalName
    foreach ($field in $fields) {
        $output += "$($list.Title),$($field.Title),$($field.InternalName)`n"
    }
}
#Then change the File Path to where you would like to output the csv
$output | Out-File -FilePath .\ProcSI-AMAGCC-Fields.csv