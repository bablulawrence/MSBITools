---
external help file: MSBITools-help.xml
Module Name: MSBITools
online version:
schema: 2.0.0
---

# Invoke-SsisPackage

## SYNOPSIS
Invoke SSIS Package

## SYNTAX

### ParamSet2
```
Invoke-SsisPackage [-Package] <PackageInfo> [-EnvReference] <EnvironmentReference>
 [[-use32RuntimeOn64] <Boolean>] [[-TimeOutInSeconds] <Int32>] [-Synchronized] [<CommonParameters>]
```

### ParamSet1
```
Invoke-SsisPackage [-Package] <PackageInfo> [[-use32RuntimeOn64] <Boolean>] [[-TimeOutInSeconds] <Int32>]
 [-Synchronized] [<CommonParameters>]
```

### ParamSet4
```
Invoke-SsisPackage [-PackageName] <String> [-EnvName] <String> [-EnvFolderName] <String>
 [-ProjectName] <String> [-ProjectFolderName] <String> [-SqlServerConnection] <SqlConnection>
 [[-use32RuntimeOn64] <Boolean>] [[-TimeOutInSeconds] <Int32>] [-Synchronized] [<CommonParameters>]
```

### ParamSet3
```
Invoke-SsisPackage [-PackageName] <String> [-ProjectName] <String> [-ProjectFolderName] <String>
 [-SqlServerConnection] <SqlConnection> [[-use32RuntimeOn64] <Boolean>] [[-TimeOutInSeconds] <Int32>]
 [-Synchronized] [<CommonParameters>]
```

## DESCRIPTION
Invoke SSIS package based on specified inpus like provide project name, folder name, environmanet name and refrences and sql connection object

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Invoke-SsisPackage -PackageName 'myPackage.dtsx' -EnvName 'myEnvironment' -EnvFolderName 'myEnvironmentFolderName' -ProjectName 'myProjectName' -ProjectFolderName 'myProjectFolderName' -Synchronized
```

Call SSIS package from SSIS catalog folder based on the values on names of package, folder and SQL connection along with reference to Environment as input.

### Example 2
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Invoke-SsisPackage -PackageName 'myPacakge.dtsx' -ProjectName 'myProject' -FolderName 'myFolder' -SqlServerConnection $sqlConnection -Synchronized
```

Call SSIS package from SSIS catalog folder depending on the values on names of package, folder in which package is present along with SQL connection.

### Example 3
```powershell
PS C:\> New-SqlServerConnection -ServerName 'localhost' | Get-SsisProject -ProjectName 'myProject' -FolderName 'myfolder' | Get-SsisPackage -PackageName 'myPackage' -Project 'myProject' | Invoke-SsisPackage -Synchronized
```

Call SSIS package based in references to SSIS Project, package along with SQL server connection as input

## PARAMETERS

### -EnvFolderName
SSIS environment folder name


```yaml
Type: String
Parameter Sets: ParamSet4
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EnvName
SSIS environment name

```yaml
Type: String
Parameter Sets: ParamSet4
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EnvReference
SSIS environment reference

```yaml
Type: EnvironmentReference
Parameter Sets: ParamSet2
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Package
SSIS Package object

```yaml
Type: PackageInfo
Parameter Sets: ParamSet2, ParamSet1
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PackageName
SSIS Package name

```yaml
Type: String
Parameter Sets: ParamSet4, ParamSet3
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ProjectFolderName
SSIS project folder name

```yaml
Type: String
Parameter Sets: ParamSet4, ParamSet3
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ProjectName
{{Fill ProjectName Description}}

```yaml
Type: String
Parameter Sets: ParamSet4, ParamSet3
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SqlServerConnection
SQL Server connection object

```yaml
Type: SqlConnection
Parameter Sets: ParamSet4, ParamSet3
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Synchronized
{{Fill Synchronized Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeOutInSeconds
{{Fill TimeOutInSeconds Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -use32RuntimeOn64
{{Fill use32RuntimeOn64 Description}}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.SqlServer.Management.IntegrationServices.PackageInfo
System.String
Microsoft.SqlServer.Management.IntegrationServices.EnvironmentReference
System.Data.SqlClient.SqlConnection
System.Boolean
System.Int32

## OUTPUTS

### System.Int64

## NOTES

## RELATED LINKS
