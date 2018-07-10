---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# Get-SsisEnvironment

## SYNOPSIS
Gets SSIS environment

## SYNTAX

### ParamSet1
```
Get-SsisEnvironment [-EnvName] <String> [-Folder] <CatalogFolder> [<CommonParameters>]
```

### ParamSet2
```
Get-SsisEnvironment [-EnvName] <String> [-FolderName] <String> -SqlServerConnection <SqlConnection>
 [<CommonParameters>]
```

## DESCRIPTION
Gets SSIS environment object in the given catalog folder. SSIS folder object or folder name along with Sql Server Connection object can be provided as parameters. 

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalog | Get-SsisCatalogFolder -FolderName 'myFolder' | Get-SsisEnvironment -EnvName 'myEnvironment'
```

Gets environment object for environment 'myEnvironment' in the catalog folder given through pipeline with an input as 'myFolder' for a given SQL server connection object of 'localhost'.

### Example 2
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisEnvironment -EnvName 'myEnvironment' -FolderName 'myFolder'
```

Gets environment object for environment 'myEnvironment' in folder 'myFolder' for the instance of sql Server connection object 'localhost'

## PARAMETERS

### -EnvName
SSIS environment name

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
Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder

## OUTPUTS

### Microsoft.SqlServer.Management.IntegrationServices.EnvironmentInfo

## NOTES

## RELATED LINKS
