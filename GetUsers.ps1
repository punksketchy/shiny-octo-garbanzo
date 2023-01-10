Connect-PnPOnline -Url "https://mdho365.sharepoint.com/teams/oea/edms/" -UseWebLogin
$web = Get-PnPWeb -Includes RoleAssignments
foreach($ra in $web.RoleAssignments)  {
    $member = ra.Member
    $loginName = Get-PnPProperty -ClientObject $member -Property LoginName
    $rolebindings = Get-PnPProperty -ClientObject $ra -Property RoleDefinitionBindings
    Write-Host "$($loginName) - $($rolebindings.Name)"
    Write-Host
}