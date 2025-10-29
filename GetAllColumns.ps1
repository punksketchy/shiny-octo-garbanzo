<#
.SYNOPSIS
    Exports all columns from a SharePoint library, including their type and all
    available options for Choice and MultiChoice columns.
#>

# ----------------------------------------------------------------------
# 1. SCRIPT PARAMETERS (CONFIGURE THESE)
# ----------------------------------------------------------------------
$SiteURL = "https://mdho365.sharepoint.com/sites/MDHInfoSecurityDocumentRepository"
$LibraryName = "Documents" # e.g., "Documents"
$ExportPath = "$([Environment]::GetFolderPath('Desktop'))\LibraryColumnReport.csv"

# ----------------------------------------------------------------------
# 2. CONNECT TO SHAREPOINT
# ----------------------------------------------------------------------
Try {
    Write-Host "Connecting to $SiteURL..." -ForegroundColor Yellow
    Connect-PnPOnline -Url $SiteURL -UseWebLogin -ErrorAction Stop
    Write-Host "Successfully connected." -ForegroundColor Green
}
Catch {
    Write-Host "Failed to connect to SharePoint. Please check the URL and permissions." -ForegroundColor Red
    return
}

# ----------------------------------------------------------------------
# 3. GET ALL FIELDS AND PROCESS THEM
# ----------------------------------------------------------------------
Write-Host "Fetching columns from '$LibraryName'..."
Try {
    # Get all fields (columns) from the specified library
    $fields = Get-PnPField -List $LibraryName -ErrorAction Stop
}
Catch {
    Write-Host "Failed to get library '$LibraryName'. Please check the name." -ForegroundColor Red
    return
}

$report = @() # This array will hold our results

ForEach ($field in $fields) {
    # We only want to report on columns that are not hidden
    If (-not $field.Hidden) {

        $fieldName = $field.Title
        $fieldType = $field.TypeAsString
        $choiceValues = "" # Default to empty

        # Check if the field is a Choice or MultiChoice field
        If ($fieldType -eq "Choice" -or $fieldType -eq "MultiChoice") {
            
            Try {
                # Cast the field's SchemaXml string into an XML object
                [xml]$schemaXml = $field.SchemaXml
                
                # Navigate the XML to find all <CHOICE> nodes
                $choices = $schemaXml.Field.CHOICES.CHOICE
                
                If ($choices) {
                    # Join all choice values into a single string separated by a pipe |
                    $choiceValues = $choices -join " | "
                }
            }
            Catch {
                $choiceValues = "Error parsing choices"
            }
        }

        # Add the details to our report array
        $report += [PSCustomObject]@{
            LibraryName    = $LibraryName
            ColumnName     = $fieldName
            FieldType      = $fieldType
            ChoiceOptions  = $choiceValues
            InternalName   = $field.InternalName
        }
    }
}

# ----------------------------------------------------------------------
# 4. EXPORT THE REPORT TO CSV
# ----------------------------------------------------------------------
If ($report.Count -gt 0) {
    $report | Export-Csv -Path $ExportPath -NoTypeInformation
    Write-Host "Success! Report saved to $ExportPath" -ForegroundColor Green
    # Optional: Open the file automatically
    # Invoke-Item $ExportPath
}
Else {
    Write-Host "No user-facing columns were found in the library." -ForegroundColor Yellow
}

# Disconnect the session
Disconnect-PnPOnline