---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# New-SsisEnvironment

## SYNOPSIS
Creates SSIS environment

## SYNTAX

### ParamSet2
```
New-SsisEnvironment [-EnvName] <String> [-FolderName] <String> -SqlServerConnection <SqlConnection>
 [<CommonParameters>]
```

### ParamSet1
```
New-SsisEnvironment [-EnvName] <String> [-Folder] <CatalogFolder> [<CommonParameters>]
```

### ParamSet3
```
New-SsisEnvironment [-ParamFilePath] <String> -SqlServerConnection <SqlConnection> [<CommonParameters>]
```

## DESCRIPTION
Creates SSIS environment in the given catalog folder with an input of folder object or folder name and SQL Server connection connection object.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalog | Get-SsisCatalogFolder -FolderName 'myFolder' | New-SsisEnvironment -EnvName 'myEnvironment'
```

Creates environment 'myEnvironment' in catalog folder provided through pipeline

### Example 2
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | New-SsisEnvironment -EnvName 'myEnvironment' -FolderName 'myFolder'
```

Creates environment 'myEnvironment' in catalog folder 'myFolder' in SQL Server instance 'localhost'

### Example 3
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | New-SsisEnvironment -ParamFilePath '.\example1.json'
```

Creates environment(s) specified in parameter file 'example1.json'

## PARAMETERS

### -EnvName
SSIS environment name

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

### -Folder
SSIS catalog folder object

```yaml
Type: CatalogFolder
Parameter Sets: ParamSet1
Aliases:

Required: True
Position: 1
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
Position: 1
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder

## OUTPUTS

### Microsoft.SqlServer.Management.IntegrationServices.EnvironmentInfo

## NOTES

## RELATED LINKS
