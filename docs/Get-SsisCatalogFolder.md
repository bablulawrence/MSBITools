---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# Get-SsisCatalogFolder

## SYNOPSIS
Gets SSIS catalog folder

## SYNTAX

### ParamSet1
```
Get-SsisCatalogFolder [-FolderName] <String> [-Catalog] <Catalog> [<CommonParameters>]
```

### ParamSet2
```
Get-SsisCatalogFolder [-FolderName] <String> -SqlServerConnection <SqlConnection> [<CommonParameters>]
```

## DESCRIPTION
Gets SSIS catalog folder object for the given catalog. Either catalog object or connection object to SQL Server instance can be provided as a parameter.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalog | Get-SsisCatalogFolder -FolderName 'myFolder'
```

Gets folder object for folder 'myFolder' in catalog given through pipeline for sql connection object of 'localhost'.

### Example 2
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalogFolder -FolderName 'myFolder'
```

Gets folder object for folder 'myFolder' in the default catalog(SSISDB) of SQL Server instance 'localhost'

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
Parameter Sets: (All)
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
Microsoft.SqlServer.Management.IntegrationServices.Catalog

## OUTPUTS

### Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder

## NOTES

## RELATED LINKS
