$SiteURL = "https://hardegree.sharepoint.com/scottsite"
$BingMapKey = "ApkZglqtZeV6sEMHzPGpIW-RONKCkiGxCU4pBDlPF-NMhOEAqakr6GRpwfXtHDkA"

Connect-PnPOnline -Url $SiteURL -UseWebLogin

Set-PnPPropertyBagValue -Key "BING_MAPS_KEY" -Value $BingMapKey