
#$owner = "Muhammad.faraz@fnsconsulting.onmicrosoft.com"
# $owner = "Muhammad.faraz@nttdata.com"
Set-PnPTraceLog -On -LogFile DebugLog.txt -Level Debug
Set-PSBreakpoint -Variable StackTrace -Mode Write

#$url = "https://nttdatagroup.sharepoint.com/sites/SRVS-PS-SHC-DMT-DEV"
#$owner = "jeroen.swanborn@nttdata.com"
$url = "https://amagcc.sharepoint.com/sites/DMT-Stage"
$owner = "scott.hardegree@medicaid.alabama.gov"

$connection = Connect-PnPOnline -Url $url -UseWebLogin


$listName = "Vendor Master"
$output = New-PnPList -Title $listName -Template GenericList -Connection $connection
$output = Set-PnPField -List $listName -Identity "Title" -Values @{Title="Vendor Name"}
$output = Set-PnPField -List $listName -Identity "Title" -Values @{Indexed=$true}
$output = Set-PnPField -List $listName -Identity "Title" -Values @{EnforceUniqueValues=$true}
$output = Add-PnPField -List $listName -Type Text -InternalName "ContactEmail" -DisplayName "Contact Email" -AddToDefaultView 

$listName = "Project Master"
$lookupListName = "Vendor Master"
$output = New-PnPList -Title $listName -Template GenericList -Connection $connection
$lookupList = Get-PnPList -Identity $lookupListName -Connection $connection

$output = Set-PnPField -List $listName -Identity "Title" -Values @{Title="Project Name"}
$output = Set-PnPField -List $listName -Identity "Title" -Values @{Required=$true}
$output = Set-PnPField -List $listName -Identity "Title" -Values @{Indexed=$true}
$output = Set-PnPField -List $listName -Identity "Title" -Values @{EnforceUniqueValues=$true}

$lookupColumnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="Lookup" DisplayName="Vendor" Name="Vendor" ShowField="Title" EnforceUniqueValues="FALSE" Required="FALSE" ID="' + $lookupColumnId + '" RelationshipDeleteBehavior="None" List="' + $lookupList.Id + '" />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$output = Add-PnPField -List $listName -Type Text -InternalName "PlanAdmin" -DisplayName "Plan Admin Group"
$output = Add-PnPField -List $listName -Type Text -InternalName "Submitter" -DisplayName "Author/Submitter Group"
$output = Add-PnPField -List $listName -Type Text -InternalName "Reviewer" -DisplayName "Reviewer Group"
$output = Add-PnPField -List $listName -Type Text -InternalName "LeadReviewer" -DisplayName "Lead Reviewer Group"
$output = Add-PnPField -List $listName -Type Text -InternalName "Approver" -DisplayName "Approver Group"

#Set-PnPView -List $listName -Identity "All Items" -Fields "Title","Vendor","PlanAdmin","Submitter","Reviewer","LeadReviewer","Approver"

$listName = "Project Teams"
$lookupListName = "Project Master"
$output = New-PnPList -Title $listName -Template GenericList -Connection $connection
$lookupList = Get-PnPList -Identity $lookupListName -Connection $connection

$output = Set-PnPField -List $listName -Identity "Title" -Values @{Title="Project and Role"}
$output = Set-PnPField -List $listName -Identity "Title" -Values @{Required=$true}
$output = Set-PnPField -List $listName -Identity "Title" -Values @{Indexed=$true}
$output = Set-PnPField -List $listName -Identity "Title" -Values @{EnforceUniqueValues=$true}

$lookupColumnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="Lookup" DisplayName="Project" Name="Project" ShowField="Title" EnforceUniqueValues="FALSE" Required="FALSE" ID="' + $lookupColumnId + '" RelationshipDeleteBehavior="None" List="' + $lookupList.Id + '" />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="UserMulti" Mult="TRUE"  DisplayName="Members" List="UserInfo" Required="TRUE" ID="' + $columnId + '" ShowField="EMail" UserSelectionMode="PeopleOnly" StaticName="Members" Name="Members" Description=""/>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="Choice" DisplayName="Role" Required="TRUE" ID="' + $columnId + '" Format="RadioButtons" FillInChoice="FALSE" StaticName="Role" Name="Role" Description="Please select a Role">'+
   '<CHOICES>'+
     '<CHOICE>Deployment Admin</CHOICE>'+
	 '<CHOICE>Plan Admin</CHOICE>'+
     '<CHOICE>Author</CHOICE>'+
     '<CHOICE>Reviewer</CHOICE>'+
	 '<CHOICE>Lead Reviewer</CHOICE>'+
	 '<CHOICE>Approver</CHOICE>'+
   '</CHOICES>'+ 
'</Field>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName
$output = Add-PnPField -List $listName -Type Boolean -InternalName "Processed" -DisplayName "Processed"
#Set-PnPView -List $listName -Identity "All Items" -Fields "Project","Role","Members"

$listName = "Review Cycles"
$output = New-PnPList -Title $listName -Template GenericList -Connection $connection
$output = Add-PnPField -List $listName -Type Number -InternalName "InitialReviewPeriod" -DisplayName "Days to Review (Initial)" -AddToDefaultView -Required
$output = Add-PnPField -List $listName -Type Number -InternalName "NextSubmitPeriod" -DisplayName "Days to Submit (Subsequent)" -AddToDefaultView -Required
$output = Add-PnPField -List $listName -Type Number -InternalName "NextReviewPeriod" -DisplayName "Days to Review (Subsequent)" -AddToDefaultView -Required
$output = Add-PnPField -List $listName -Type Number -InternalName "ApprovalPeriod" -DisplayName "Days to Approve" -AddToDefaultView -Required

#Set-PnPView -List $listName -Identity "All Items" -Fields "Title","InitialReviewPeriod","NextSubmitPeriod","NextReviewPeriod", "ApprovalPeriod"

$listName = "Functional Areas"
$output = New-PnPList -Title $listName -Template GenericList -Connection $connection

$listName = "Plan Tags"
$output = New-PnPList -Title $listName -Template GenericList -Connection $connection

$lookupListName = "Project Master"
$lookupList = Get-PnPList -Identity $lookupListName -Connection $connection
$lookupColumnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="Lookup" DisplayName="Project" Name="Project" ShowField="Title" EnforceUniqueValues="FALSE" Required="TRUE" ID="' + $lookupColumnId + '" RelationshipDeleteBehavior="None" List="' + $lookupList.Id + '" />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName


$listName = "Deliverable Plan"
$output = New-PnPList -Title $listName -Template GenericList -Connection $connection

$lookupListName = "Project Master"
$lookupList = Get-PnPList -Identity $lookupListName -Connection $connection
$lookupColumnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="Lookup" DisplayName="Project" Name="Project" ShowField="Title" EnforceUniqueValues="FALSE" Required="TRUE" ID="' + $lookupColumnId + '" RelationshipDeleteBehavior="None" List="' + $lookupList.Id + '" />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$lookupListName = "Plan Tags"
$lookupList = Get-PnPList -Identity $lookupListName -Connection $connection
$lookupColumnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="Lookup" DisplayName="Master Tag" Name="Tag" ShowField="Title" EnforceUniqueValues="FALSE" Required="FALSE" ID="' + $lookupColumnId + '" RelationshipDeleteBehavior="None" List="' + $lookupList.Id + '" />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$output = Add-PnPField -List $listName -Type Text -InternalName "Number" -DisplayName "Deliverable Number" -Required

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="DateTime" DisplayName="Due Date" Required="FALSE" ID="'+ $columnId +'" Format="DateOnly" FriendlyDisplayFormat="Disabled" StaticName="DueDate" Name="DueDate"/>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$lookupListName = "Functional Areas"
$lookupList = Get-PnPList -Identity $lookupListName -Connection $connection
$lookupColumnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="Lookup" DisplayName="Functional Area" Name="FunctionalArea" ShowField="Title" EnforceUniqueValues="FALSE" Required="FALSE" ID="' + $lookupColumnId + '" RelationshipDeleteBehavior="None" List="' + $lookupList.Id + '" />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="DateTime" DisplayName="Completion Date" Required="FALSE" ID="'+ $columnId +'" Format="DateOnly" FriendlyDisplayFormat="Disabled" StaticName="CompletionDate" Name="CompletionDate"/>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$output = Add-PnPField -List $listName -Type Number -InternalName "InitialReviewPeriod" -DisplayName "Days to Review (Initial)" -AddToDefaultView -Required
$output = Add-PnPField -List $listName -Type Number -InternalName "NextSubmitPeriod" -DisplayName "Days to Submit (Subsequent)" -AddToDefaultView -Required
$output = Add-PnPField -List $listName -Type Number -InternalName "NextReviewPeriod" -DisplayName "Days to Review (Subsequent)" -AddToDefaultView -Required
$output = Add-PnPField -List $listName -Type Number -InternalName "ApprovalPeriod" -DisplayName "Days to Approve" -AddToDefaultView -Required
$output = Add-PnPField -List $listName -Type Boolean -InternalName "SpecialReview" -DisplayName "Special Review?"
$output = Add-PnPField -List $listName -Type Boolean -InternalName "InProgress" -DisplayName "In Progress?"


$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="UserMulti" Mult="TRUE"  DisplayName="Plan Admin" List="UserInfo" Required="TRUE" ID="' + $columnId + '" ShowField="EMail" UserSelectionMode="PeopleOnly" StaticName="PlanAdmin" Name="PlanAdmin" Description=""/>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="UserMulti" Mult="TRUE"  DisplayName="Approvers" List="UserInfo" Required="TRUE" ID="' + $columnId + '" ShowField="EMail" UserSelectionMode="PeopleOnly" StaticName="Approvers" Name="Approvers" Description=""/>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="UserMulti" Mult="TRUE"  DisplayName="Lead Reviewers" List="UserInfo" Required="TRUE" ID="' + $columnId + '" ShowField="EMail" UserSelectionMode="PeopleOnly" StaticName="LeadReviewers" Name="LeadReviewers" Description=""/>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="UserMulti" Mult="TRUE"  DisplayName="Reviewers" List="UserInfo" Required="TRUE" ID="' + $columnId + '" ShowField="EMail" UserSelectionMode="PeopleOnly" StaticName="Reviewers" Name="Reviewers" Description=""/>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="Note" DisplayName="Comments" Required="FALSE" ID="'+ $columnId+'" NumLines="6" RichText="FALSE" Sortable="FALSE" StaticName="Comments" Name="Comments" Description=""/>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName



$listName = "Deliverable Submissions"
$output = New-PnPList -Title $listName -Template GenericList -Connection $connection

$lookupListName = "Deliverable Plan"
$lookupList = Get-PnPList -Identity $lookupListName -Connection $connection
$lookupColumnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="Lookup" DisplayName="Deliverable #" Name="Deliverable #" ShowField="Number" EnforceUniqueValues="FALSE" Required="TRUE" ID="' + $lookupColumnId + '" Indexed="TRUE" RelationshipDeleteBehavior="Restrict" List="' + $lookupList.Id + '" />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName


$lookupListName = "Deliverable Submissions"
$lookupList = Get-PnPList -Identity $lookupListName -Connection $connection
$lookupColumnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="Lookup" DisplayName="Previous Submission" Name="PreviousSubmission" ShowField="Title" EnforceUniqueValues="TRUE" Required="FALSE" ID="' + $lookupColumnId + '" Indexed="TRUE" RelationshipDeleteBehavior="Restrict" List="' + $lookupList.Id + '" />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$output = Add-PnPField -List $listName -Type Number -InternalName "MajorVersion" -DisplayName "Major Version" -Required
$output = Add-PnPField -List $listName -Type Number -InternalName "MinorVersion" -DisplayName "Minor Version" -Required

$output = Add-PnPField -List $listName -Type Text -InternalName "IncomingCorrespondence" -DisplayName "Incoming Correspondence" -Required

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="DateTime" DisplayName="Received Date" Required="FALSE" ID="'+ $columnId +'" Format="DateOnly" FriendlyDisplayFormat="Disabled" StaticName="ReceivedDate" Name="ReceivedDate"/>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="Choice" DisplayName="Stage" Required="TRUE" ID="' + $columnId + '" Format="RadioButtons" FillInChoice="FALSE" StaticName="Stage" Name="Stage" Description="">'+
	'<Default>Saved</Default>'+
   '<CHOICES>'+
        '<CHOICE>Saved</CHOICE>'+
     '<CHOICE>Submitted</CHOICE>'+
	 '<CHOICE>Received</CHOICE>'+
     '<CHOICE>Under Review</CHOICE>'+
     '<CHOICE>Pending Approval</CHOICE>'+
	 '<CHOICE>Approved</CHOICE>'+
	 '<CHOICE>Conditionally Approved</CHOICE>'+
	 '<CHOICE>Rework Required</CHOICE>'+
	 '<CHOICE>Canceled</CHOICE>'+
   '</CHOICES>'+ 
'</Field>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field ID="' + $columnId + '" Name="ReviewComplete" StaticName="ReviewComplete" DisplayName="Review Completed By" Type="Note" RichText="FALSE"  />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="UserMulti" Mult="TRUE"  DisplayName="Required Reviewers" List="UserInfo" Required="FALSE" ID="' + $columnId + '" ShowField="EMail" UserSelectionMode="PeopleOnly" StaticName="Reviewers" Name="Reviewers" Description=""/>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field ID="' + $columnId + '" Name="ReviewSummary" StaticName="ReviewSummary" DisplayName="Review Summary" Type="Note" RichText="TRUE" RichTextMode="FullHtml" />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$listName = "All Comments"
$output = New-PnPList -Title $listName -Template GenericList -Connection $connection

$output = Add-PnPField -List $listName -Type Number -InternalName "CommentID" -DisplayName "Comment ID" -Required

$lookupListName = "Project Master"
$lookupList = Get-PnPList -Identity $lookupListName -Connection $connection
$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="Lookup" DisplayName="Project" Name="Project" ShowField="Title" EnforceUniqueValues="FALSE" Required="FALSE" ID="' + $columnId + '" RelationshipDeleteBehavior="None" List="' + $lookupList.Id + '" />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName



$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field ID="' + $columnId + '" Name="Comment" StaticName="Comment" DisplayName="Comment" Type="Note" RichText="TRUE" RichTextMode="FullHtml" />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName


#$lookupListName = "Deliverable Submissions"
#$lookupList = Get-PnPList -Identity $lookupListName -Connection $connection
#$columnId = [guid]::NewGuid().Guid
#$schemaXml = '<Field ID="' + $columnId + '" Name="Deliverable" StaticName="Deliverable" DisplayName="Deliverable" Type="Lookup" List="' + $lookupList.Id + '" ShowField="Title" />'
#$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$lookupListName = "Deliverable Plan"
$lookupList = Get-PnPList -Identity $lookupListName -Connection $connection
$lookupColumnId = [guid]::NewGuid().Guid
$schemaXml = '<Field Type="Lookup" DisplayName="Deliverable #" Name="Deliverable #" ShowField="Number" EnforceUniqueValues="FALSE" Required="TRUE" ID="' + $lookupColumnId + '" Indexed="TRUE" RelationshipDeleteBehavior="Restrict" List="' + $lookupList.Id + '" />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$output = Add-PnPField -List $listName -Type Number -InternalName "MajorVersion" -DisplayName "Major Version" -Required
$output = Add-PnPField -List $listName -Type Number -InternalName "MinorVersion" -DisplayName "Minor Version" -Required

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field ID="' + $columnId + '" Name="IsPublic" StaticName="IsPublic" DisplayName="IsPublic" Type="Boolean"><Default>0</Default></Field>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field ID="' + $columnId + '" Name="DocumentName" StaticName="DocumentName" DisplayName="Document Name" Type="Text"  />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field ID="' + $columnId + '" Name="Section" StaticName="Section" DisplayName="Section" Type="Text"  />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field ID="' + $columnId + '" Name="PageNumber" StaticName="PageNumber" DisplayName="Page Number" Type="Text"  />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field ID="' + $columnId + '" Name="Location" StaticName="Location" DisplayName="Identifier/Location" Type="Text"  />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field ID="' + $columnId + '" Name="Type" StaticName="Type" DisplayName="Type" Type="Choice" FillInChoice="FALSE" >
                                            <Default></Default>
                                            <CHOICES>
                                                <CHOICE></CHOICE>
                                                <CHOICE>NC-Non-Compliance</CHOICE>
                                                <CHOICE>R-Required</CHOICE>
                                                <CHOICE>Q-Question</CHOICE>
                                                <CHOICE>R/C-Recommendation/Cosmetic</CHOICE>        
                                            </CHOICES>
                                        </Field>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field ID="' + $columnId + '" Name="Agency" StaticName="Agency" DisplayName="Agency" Type="Text" />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field ID="' + $columnId + '" Name="Response" StaticName="Response" DisplayName="Reviewer Response" Type="Note" RichText="TRUE" RichTextMode="FullHtml" />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field ID="' + $columnId + '" Name="AuthorResponse" StaticName="AuthorResponse" DisplayName="Author Response" Type="Note" RichText="TRUE" RichTextMode="FullHtml" />'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName

$columnId = [guid]::NewGuid().Guid
$schemaXml = '<Field ID="' + $columnId + '" Name="Status" StaticName="Status" DisplayName="Status" Type="Choice" FillInChoice="FALSE" >
                                            <Default>Open</Default>
                                            <CHOICES>
                                                <CHOICE>Open</CHOICE>
                                                <CHOICE>Closed</CHOICE>
                                                <CHOICE>Conditionally Closed</CHOICE>                                                   
                                            </CHOICES>
                                        </Field>'
$output = Add-PnPFieldFromXml -FieldXml $schemaXml  -List $listName




    

$output = New-PnPGroup -Title "Deployment Admin" -Description "Group to maintain non project-specific data." -Owner $owner
$output = New-PnPGroup -Title "All Internal Groups" -Description "Group to hold all reviewers & approvers." -Owner $owner
$output = New-PnPGroup -Title "All External Groups" -Description "Group to hold all authors." -Owner $owner
