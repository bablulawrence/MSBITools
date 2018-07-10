---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# New-SsisCatalogFolder

## SYNOPSIS
Creates SSIS catalog folder

## SYNTAX

### ParamSet2
```
New-SsisCatalogFolder [-FolderName] <String> -SqlServerConnection <SqlConnection> [<CommonParameters>]
```

### ParamSet1
```
New-SsisCatalogFolder [-FolderName] <String> [-Catalog] <Catalog> [<CommonParameters>]
```

### ParamSet3
```
New-SsisCatalogFolder [-ParamFilePath] <String> -SqlServerConnection <SqlConnection> [<CommonParameters>]
```

## DESCRIPTION
Creates SSIS catalog folder in the given catalog with an input of catalog object or SQL Server connection object.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalog | New-SsisCatalogFolder -FolderName 'myFolder'
```

Creates catalog folder 'myFolder' in the catalog provided through pipeline

### Example 2
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | New-SsisCatalogFolder -FolderName 'myFolder'
```

Creates catalog folder 'myFolder' in the default catalog(SSISDB) of SQL Server instance 'localhost'

### Example 3
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | New-SsisCatalogFolder -ParamFilePath '.\example1.json'
```

Creates catalog folder(s) specified in the parameter file 'example1.json'

## PARAMETERS

### -Catalog
SSIS catalog object

```yaml
Type: Catalog
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
Parameter Sets: ParamSet2, ParamSet1
Aliases:

Required: True
Position: 0
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
Microsoft.SqlServer.Management.IntegrationServices.Catalog

## OUTPUTS

### Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder

## NOTES

## RELATED LINKS
