---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# Remove-SsisEnvironment

## SYNOPSIS
Delete SSIS Environment

## SYNTAX

### ParamSet2
```
Remove-SsisEnvironment [-EnvName] <String> [-FolderName] <String> [-SqlServerConnection] <SqlConnection>
 [<CommonParameters>]
```

### ParamSet1
```
Remove-SsisEnvironment [-EnvName] <String> [-Folder] <CatalogFolder> [<CommonParameters>]
```

### ParamSet3
```
Remove-SsisEnvironment [-ParamFilePath] <String> [-SqlServerConnection] <SqlConnection> [<CommonParameters>]
```

## DESCRIPTION
Delete SSIS environment in the given catalog folder input as SSIS folder object or folder name and SQL Server connection object.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalog | Get-SsisCatalogFolder -FolderName 'myFolder' | Remove-SsisEnvironment -EnvName 'myEnvironment'
```

Delete environment 'myEnvironment' in catalog folder provided through pipeline

### Example 2
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Remove-SsisEnvironment -EnvName 'myEnvironment' -FolderName 'myFolder'
```

Delete environment 'myEnvironment' in catalog folder 'myFolder' in SQL Server instance 'localhost'

### Example 3
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Remove-SsisEnvironment -ParamFilePath '.\example1.json'
```

Deletes environment(s) specified in parameter file 'example1.json'

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
