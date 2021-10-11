#Vars
$SourceSiteUrl = "https://alabamagov.sharepoint.com/sites/Medicaid-MESModularity/MES-PROCUREMENT-Sandbox"
$SourceLibraryName = "Procurement Library"
$DestinationSiteUrl = "https://alabamagov.sharepoint.com/sites/Medicaid-MESModularity/MES-PROGRAM-Sandbox/"
$DestinationLibraryName = "Procurement Library"

try {
    #Connect to the site
    Connect-PnPOnline -Url $SourceSiteUrl -UseWebLogin

    #Get Source Library
    $SourceLibrary = Get-PnPList -Identity $SourceLibraryName -Includes RootFolder

    #Step 1: Save the Source Library as a template
    $SourceLibrary.SaveAsTemplate($SourceLibrary.Title, $SourceLibrary.Title, "", $false)
    Invoke-PnPQuery

    #Get the Library Template created
    $Ctx = Get-PnPContext
    $Web = Get-PnPWeb
    $RootWeb = $Ctx.Site.$RootWeb
    $LitsTemplates = $Ctx.Site.GetCustomListTemplates($RootWeb)
    $Ctx.Load($RootWeb)
    $Ctx.Load($LitsTemplates)
    Invoke-PnPQuery
    $LitsTemplates = $LitsTemplates | Where {$_.Name -eq $SourceLibraryName}
}
catch {
    
}