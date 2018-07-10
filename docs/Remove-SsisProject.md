---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# Remove-SsisProject

## SYNOPSIS
Remove SSIS Job from SQL server Instance

## SYNTAX

### ParamSet2
```
Remove-SsisProject [-ProjectName] <String> [-ProjectFilePath] <String> [-FolderName] <String>
 [-SqlServerConnection] <SqlConnection> [<CommonParameters>]
```

### ParamSet1
```
Remove-SsisProject [-ProjectName] <String> [-ProjectFilePath] <String> [-Folder] <CatalogFolder>
 [<CommonParameters>]
```

### ParamSet3
```
Remove-SsisProject [-ParamFilePath] <String> [-SqlServerConnection] <SqlConnection> [<CommonParameters>]
```

## DESCRIPTION
Delete a SSIS project from SQL Server instance based on specified parameters.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Remove-SsisProject -ParamFilePath '.\example1.json'
```

Remove projects specified in parameter file 'example1.json'

### Example 2
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalog | Get-SsisCatalogFolder -FolderName 'myFolder' | Remove-SsisProject -ProjectName 'myProject'
```

Remove project 'myProject' in catalog folder provided through pipeline

### Example 3
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Remove-SsisProject -ProjectName 'myProject' -FolderName 'myFolder'
```

Removes project 'myProject' in catalog folder 'myFolder' in SQL Server instance 'localhost'

### Example 4
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Remove-SsisProject -ParamFilePath '.\example1.json' -ProjectFilePathPrefix "$pwd\"
```

Remove projects specified in parameter file 'example1.json' with project file path reference present in current directory

## PARAMETERS

### -Folder
SSIS catalog folder object

```yaml
Type: CatalogFolder
Parameter Sets: ParamSet1
Aliases:

Required: True
Position: 3
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
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ParamFilePath
Parameter file path

```yaml
Type: String
Parameter Sets: ParamSet3
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ProjectFilePath
Folder path containing Project

```yaml
Type: String
Parameter Sets: ParamSet2, ParamSet1
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ProjectName
SSIS Project Name

```yaml
Type: String
Parameter Sets: ParamSet2, ParamSet1
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SqlServerConnection
SQL Server connection object

```yaml
Type: SqlConnection
Parameter Sets: ParamSet2, ParamSet3
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder
System.Data.SqlClient.SqlConnection

## OUTPUTS

### System.Boolean

## NOTES

## RELATED LINKS
