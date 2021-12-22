$url = "https://alabamagov.sharepoint.com/sites/Medicaid-DMT-Stage"
$connection = Connect-PnPOnline -Url $url -UseWebLogin

$allLists = Get-PnPList
foreach ($list in $allLists) {
    if($list.Title -match ' Comments$')
    {
        $fields = Get-PnPField -List $list
        $field = $fields | where{$_.Title -eq "Document Name"}
        
        #if((Get-PnPField -List $list -Identity DocumentName) -ne $null)
        if(-Not $field)
        {
            Write-Output $list.Title

            #$columnId = [guid]::NewGuid().Guid
            #$schemaXml = '<Field Type="Text" Name="DocumentName" StaticName="DocumentName" DisplayName="Document Name"  ID="'+ $columnId+'" />'
            #Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName
        }
        
    }
   
 }