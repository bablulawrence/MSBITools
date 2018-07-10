---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# Get-SsisProject

## SYNOPSIS
Gets SSIS Project

## SYNTAX

### ParamSet1
```
Get-SsisProject [-ProjectName] <String> [-Folder] <CatalogFolder> [<CommonParameters>]
```

### ParamSet2
```
Get-SsisProject [-ProjectName] <String> [-FolderName] <String> -SqlServerConnection <SqlConnection>
 [<CommonParameters>]
```

## DESCRIPTION
Gets SSIS project object in the given catalog folder by providing SSIS folder object or folder name and SQL connection object as parameters. 

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalog | Get-SsisCatalogFolder -FolderName 'myFolder' | Get-SsisProject -ProjectName 'myProject'
```

Gets project object for project 'myProject' in the catalog folder given through pipeline. 

### Example 2
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisProject -ProjectName 'myEnvironment' -FolderName 'myFolder'
```

Gets project object for project 'myProject' in folder 'myFolder' and server instance 'localhost'

## PARAMETERS

### -Folder
SSIS catalog folder object

```yaml
Type: CatalogFolder
Parameter Sets: ParamSet1
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -FolderName
SSIS catalog folder name

```yaml
Type: String
Parameter Sets: ParamSet2
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ProjectName
SSIS project name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SqlServerConnection
Sql Server connection object

```yaml
Type: SqlConnection
Parameter Sets: ParamSet2
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder

## OUTPUTS

### Microsoft.SqlServer.Management.IntegrationServices.ProjectInfo

## NOTES

## RELATED LINKS
