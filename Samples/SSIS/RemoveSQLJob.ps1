$sqlConnection = New-SqlServerConnection -ServerName 'localhost'
Remove-SqlServerAgentJob -SqlServerConnection $sqlConnection -ParamFilePath '.\ImportToCSV.param.json'

