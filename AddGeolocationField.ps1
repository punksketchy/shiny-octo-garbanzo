#Parameter
$SiteURL = "https://hardegree.sharepoint.com/scottsite"
$ListName = "Metrics"
$FieldName = "Location"
  
Try {
    #Connect to PnP Online
    Connect-PnPOnline -Url $SiteURL -UseWebLogin
   
    #Get the List
    $List = Get-PnPList -Identity $ListName
     
    #Add Geolocation field to the List
    Add-PnPField -List $List -Type GeoLocation -DisplayName $FieldName -InternalName $FieldName -AddToDefaultView -AddToAllContentTypes
 
    Write-host "Bing Map Geolocation Field Added to the List!" -f Green
}
catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}