
# Requires -Modules PnP.PowerShell

param(
	[Parameter(Mandatory=$true)]
	[string]$UserLogin,
	[Parameter(Mandatory=$true)]
	[string]$CsvPath
)

if (!(Test-Path $CsvPath)) {
	Write-Error "CSV file not found: $CsvPath"
	exit 1
}

$sites = Import-Csv -Path $CsvPath

foreach ($site in $sites) {
	$siteUrl = $site.SiteUrl
	Write-Host "Processing site: $siteUrl" -ForegroundColor Cyan
	try {
		Connect-PnPOnline -Url $siteUrl -UseWebLogin
		Remove-PnPUser -Identity $UserLogin -ErrorAction Stop
		Write-Host "Removed $UserLogin from $siteUrl" -ForegroundColor Green
	} catch {
		Write-Host ("Failed to remove {0} from {1}: {2}" -f $UserLogin, $siteUrl, $_) -ForegroundColor Red
	}
	Disconnect-PnPOnline
}

#how to use: .\RemoveUsersAllSites.ps1 -UserLogin "user@domain.com" -CsvPath "SiteCollections.csv"