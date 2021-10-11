$url = "https://alabamagov.sharepoint.com/sites/Medicaid-MESModularity/MES-PROGRAM-Sandbox/" 
$connection = Connect-PnPOnline -Url $url -UseWebLogin
$listName = "Deliverables"

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="DateTime" DisplayName="Received Date" Required="FALSE" ID="'+ $columnId +'" Format="DateOnly" FriendlyDisplayFormat="Disabled" StaticName="ReceivedDate" Name="ReceivedDate"/>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName
