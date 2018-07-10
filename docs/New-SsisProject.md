---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# New-SsisProject

## SYNOPSIS
Creates SSIS project

## SYNTAX

### ParamSet2
```
New-SsisProject [-ProjectName] <String> [-ProjectFilePath] <String> [-FolderName] <String>
 -SqlServerConnection <SqlConnection> [<CommonParameters>]
```

### ParamSet1
```
New-SsisProject [-ProjectName] <String> [-ProjectFilePath] <String> [-Folder] <CatalogFolder>
 [<CommonParameters>]
```

### ParamSet3
```
New-SsisProject [-ParamFilePath] <String> [-ProjectFilePathPrefix <String>]
 -SqlServerConnection <SqlConnection> [<CommonParameters>]
```

## DESCRIPTION
Creates SSIS project in the given folder from the ISPAC file with an input of folder object or folder name and SQL Server connection

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalog | Get-SsisCatalogFolder -FolderName 'myFolder' | New-SsisProject -ProjectName 'myProject'
```

Creates project 'myProject' in catalog folder provided through pipeline

### Example 2
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | New-SsisProject -ProjectName 'myProject' -FolderName 'myFolder'
```

Creates project 'myProject' in catalog folder 'myFolder' in SQL Server instance 'localhost'

### Example 3
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | New-SsisProject -ParamFilePath '.\example1.json'
```

Creates projects(s) specified in parameter file 'example1.json'

### Example 4
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | New-SsisProject -ParamFilePath '.\example1.json' -ProjectFilePathPrefix "$pwd\"
```

Creates projects(s) specified in parameter file 'example1.json' with project file path reference present in current directory

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
ISPAC file path

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
SSIS project name

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
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ProjectFilePathPrefix
Folder path containing Project

```yaml
Type: String
Parameter Sets: ParamSet3
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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
