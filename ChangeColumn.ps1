#Set Parameters
$url = "https://hardegree.sharepoint.com/"
$listName = "ChangeInternalName"
$fieldName = "YesNoTest" #Internal Name
$newFieldName = "YesAndNo"

Connect-PnPOnline -Url $url -UseWebLogin

Set-PnPField -List $listName -Identity $fieldName 