$SiteUrl = "https://hardegree.sharepoint.com/scottsite/"
$LibraryName = "Test Library"
$NewLibName = "TestLibrary"

Connect-PnPOnline -Url $SiteUrl -Interactive
$List = Get-PnPList -Identity $LibraryName -Includes RootFolder

$List.RootFolder.MoveTo($NewLibName)
Invoke-PnPQuery