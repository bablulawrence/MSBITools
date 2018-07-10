$sqlConnection = New-SqlServerConnection -ServerName 'localhost'
Remove-SsisEnvironment -ParamFilePath '.\ImportToCSV.param.json' -SqlServerConnection $sqlConnection
Remove-SsisProject -ParamFilePath '.\ImportToCSV.param.json' -SqlServerConnection $sqlConnection
Remove-SsisCatalogFolder -ParamFilePath  '.\ImportToCSV.param.json' -SqlServerConnection $sqlConnection





