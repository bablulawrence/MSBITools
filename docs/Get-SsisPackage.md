---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# Get-SsisPackage

## SYNOPSIS
Get an instance of SSIS Package

## SYNTAX

### ParamSet2
```
Get-SsisPackage [-PackageName] <String> [-FolderName] <String> [-ProjectName] <String>
 [-SqlServerConnection] <SqlConnection> [<CommonParameters>]
```

### ParamSet1
```
Get-SsisPackage [-PackageName] <String> [-Project] <ProjectInfo> [<CommonParameters>]
```

## DESCRIPTION
Get an instance of SSIS Package by providing  SSIS folder name, SSIS package name and sql connection object as input.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisProject -ProjectName 'myproject' -FolderName 'myprojectfolder'|Get-SsisPackage -PackageName 'mypackage.dtsx'
```

Get an instance of SSIS package named 'mypackage.dtsx' under project 'myproject' in sql server instance 'localhost'

### Example 2
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisCatalog | Get-SsisCatalogFolder -FolderName 'myFolder' | Get-SsisProject -ProjectName 'myProject'|Get-SsisPackage -PackageName 'mypackage.dtsx'
```

Get an instance of SSIS package named 'mypackage.dtsx' under project 'myproject' in sql server instance 'localhost' through the pipeline from folder 'myfolder' in default ssis catalog 

### Example 3
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' |Get-SsisPackage -PackageName 'mypackage.dtsx' -FolderName 'myFolder' -ProjectName 'myproject'
```

Get an instance of SSIS package 'mypackage.dtsx' throguh pipeline in SSIS Project 'myproject' in SQL server instance 'localhost'

## PARAMETERS

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

### -PackageName
SSIS package name

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

### -Project
SSIS project object

```yaml
Type: ProjectInfo
Parameter Sets: ParamSet1
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ProjectName
SSIS project name

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

### -SqlServerConnection
SQL Server connection object

```yaml
Type: SqlConnection
Parameter Sets: ParamSet2
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
Microsoft.SqlServer.Management.IntegrationServices.ProjectInfo
System.Data.SqlClient.SqlConnection

## OUTPUTS

### Microsoft.SqlServer.Management.IntegrationServices.PackageInfo

## NOTES

## RELATED LINKS
