# MSBITools - A utility for Automated Deployment of MSBI Projects with Powershell

## Introduction

MSBITools module provides resources which will allow developers and administrators alike to seamlessly deploy and manage MSBI projects.

## Getting Started

### Installation

If you have the [PowerShellGet](https://msdn.microsoft.com/powershell/gallery/readme) module installed
you can enter the following command:

``` PowerShell
Install-Module MSBITools 
```

Alternatively you can clone or download zip of this repo and run the following command

``` PowerShell
Import-Module ./MSBITools.psd1
```
## SSIS Deployment in MSBI Tools

There are resources in this module which will take an ispac file and deploy SSIS packages it contains to the Integration catalog. It handles activities like create folder in SSIS catalog, deploy dtsx packages within above created folder, create and link environment refrerences and in addition create SQL jobs to run the same pacakges based on certain input parameters. Input parameters are SQL server name, Folder name which should be created to contain SSIS package, environment name and references between environment and project.These paraments can be specified either in a JSON template file or inline during execution of cmdlets.

### How to use MSBITools to deploy SSIS Projects?

We will use a sample project and walkthrough you through steps to deploy project.

### About Project

ImportToCSV is a SSIS project which will take a csv file as input and rows from csv are added as records in a SQL table.

 ### Before we start

Download SSIS folder from Samples section of the repository.
You may access it from [Link](#/Samples/SSIS)

* CreateTable.sql - This file will help to create table in SQL server needed for the demo.
* ImportToCSV.ispac - ISPAC file which we will be using for deployment
* Package.dtsx - SSIS package for the project
* ImportToCSV.Data.csv - CSV file with sample data

### Deployment After Project Setup

In addition to files used in above section, there are additional powershell scripts and we will go through each one in this section.

To execute these scripts, Open Powershell and navigate to the downloaded SSIS folder.

For this example, SSIS folder is downloaded to C drive. Path to this folder is 'C:/SSIS'

Open powershell console and navigate to above folder using Change directory command

~~~
 cd c:/ssis
~~~

#### DeploySSISProject.ps1

This script is used to deploy ssis project and it will deploy ImportToCSV.ispac and its related package to the SQL Server.

script is executed as below

~~~
.\DeploySSISProject.ps1
~~~

Code inside the script is as below 

~~~ Powershell
Import-Module .\MSBITools.psd1 -Force

$sqlConnection = New-SqlServerConnection -ServerName 'localhost'

New-SsisCatalogFolder -ParamFilePath '.\ImportToCSV.param.json' -SqlServerConnection $sqlConnection
New-SsisProject -ParamFilePath '.\ImportToCSV.param.json' -ProjectFilePathPrefix 'C:\SSIS' -SqlServerConnection $sqlConnection 
New-SsisEnvironment -ParamFilePath '.\ImportToCSV.param.json' -SqlServerConnection $sqlConnection
New-SsisProjectEnvReference -ParamFilePath '.\ImportToCSV.param.json' -SqlServerConnection $sqlConnection
New-SsisEnvironmentVariable -ParamFilePath '.\ImportToCSV.param.json' -SqlServerConnection $sqlConnection
~~~

#### RemoveSSISProject.ps1

This script is used to remove SSIS project which was deployed in previous step.

script is executed as below

~~~
.\RemoveSSISProject.ps1
~~~


code in this script is as below.

~~~ Powershell
Import-Module .\MSBITools.psd1 -Force

$sqlConnection = New-SqlServerConnection -ServerName 'localhost'

Import-Module .\MSBITools.psd1 -Force

$sqlConnection = New-SqlServerConnection -ServerName 'localhost'

Remove-SsisEnvironment -ParamFilePath '.\ImportToCSV.param.json' -SqlServerConnection $sqlConnection
Remove-SsisProject -ParamFilePath '.\ImportToCSV.param.json' -SqlServerConnection $sqlConnection
Remove-SsisCatalogFolder -ParamFilePath  '.\ImportToCSV.param.json' -SqlServerConnection $sqlConnection

~~~


#### DeploySQLJob.ps1

This script will allow to create SQL jobs which would can run SSIS package deployed in step above.

script is executed as below

~~~
.\DeploySQLJob.ps1
~~~


Code inside this script is as below.

~~~ Powershell
Import-Module .\MSBITools.psm1 -Force
 
$sqlConnection = New-SqlServerConnection -ServerName 'localhost'

New-SqlServerAgentJob -SqlServerConnection $sqlConnection -ParamFilePath '.\ImportToCSV.param.json' 

New-SQLAgentJobEnvReference -SqlServerConnection $sqlConnection -ParamFilePath '.\ImportToCSV.param.json'
~~~

#### RemoveSQLJob.ps1

This script will allow to remove SQL jobs created in the step above. 

script is executed as below

~~~
.\RemoveSQLJob.ps1
~~~

Code inside this script is as below.

~~~ Powershell
Import-Module .\MSBITools.psm1 -Force

$sqlConnection = New-SqlServerConnection -ServerName 'localhost'

Remove-SqlServerAgentJob -SqlServerConnection $sqlConnection -ParamFilePath '.\ImportToCSV.param.json'

~~~

###  what is JSON file used in all scripts?

The template to contain parameters is a JSON file structured as per the hierarchy seen in SQL Server.

Lets breakdown template now.
 
There are two levels of parameters called Catalog and Jobs. Catalog is the section to define values required for deployment of SSIS pacakges and Jobs is the section to define values to set up SQL Jobs.

~~~~~~~~~~~~~~~~
{
    "Catalog":{......},
    "Jobs":[...]
}
~~~~~~~~~~~~~~~~~~

Inside Catalog, next section is the folder and it has values like its name and details about the Project.
Project section contains name of the project, file path containing location of ispac file in local computer and environment references.

Environment section is used to define variables to be used with environment. Variable will have details like its name, type, value and description.


~~~~~~~~~~~~~~~~~~~~~~~~~~

    "Catalog": { 
        "Name": "SSISDB",
        "Folder": [ 
            {
                "Name":"", 
                "Project": [
                    {
                        "Name": "",
                        "FilePath": "",
                        "Reference": [
                            {
                                "EnvName": "",
                                "EnvFolderName": ""
                            },
                            {
                                "EnvName": "",
                                "EnvFolderName": ""
                            }
                        ]
                    }
                ],    
                "Environment": [
                    {
                        "Name": "",
                        "Variable": [
                            {
                                "Name": "",
                                "Type": "",
                                "Value": "",
                                "Sensitive": false,
                                "Description": ""
                            },
                            {
                                "Name": "",
                                "Type": "",
                                "Value": "",
                                "Sensitive": true,
                                "Description": ""
                            }
                        ]
                    },
                    {
                        "Name": "",
                        "Variable": [
                            {
                                "Name": "",
                                "Type": "",
                                "Value": "",
                                "Sensitive": false,
                                "Description": ""
                            },
                            {
                                "Name": "",
                                "Type": "",
                                "Value": "",
                                "Sensitive": true,
                                "Description": ""
                            }
                        ]
                    } 
                ]                  
            },
            {
                "Name":"", 
                "Project": [
                ],    
                "Environment": [    
                ]                  
            }
        ]                
    } 

~~~~~~~~~~~~~~~~~~~~~~~~~~

Next section is the jobs which should have details like the name of the job, details about step, environment to be used in the step and the frequency.
Step will have values like its name, path of the package which is known by values of folder, project and package and finally the environment. Job can contain multiple steps and multiple jobs can be created using this module.
~~~~~~~~~~~~~~~~~~~~~~~
"Job":[
        {
            "Name":"",
             "Step":[
                 {
                   
                        "Name":"",    
                        "Folder":"",
                        "Project":"",
                        "Package":"",
                        "Environment":
                        {
                            "Name":"",
                            "Folder":""

                        }
                 },
                 {
                            "Name":"",    
                            "Folder":"",
                            "Project":"",
                            "Package":"",
                            "Environment":
                            {
                                "Name":"",
                                "Folder":""
    
                            }
                }
                 
             ],
             "Frequency":{
                "Name":"",
                "Type":"",
                "SubType":"",
                "Interval":"",
                "StartDate":"",
                "StartTime":"",
                "EndDate":"",
                "EndTime":""

            }
            
        },
       
        {
            "Name":"",
             "Step":[
                 {
                   
                        "Name":"",    
                        "Folder":"",
                        "Project":"",
                        "Package":""
                 },
                 {
                            "Name":"",    
                            "Folder":"",
                            "Project":"",
                            "Package":""
                }
                 
             ],
             "Frequency":{
                "Name":"",
                "Type":"",
                "SubType":"",
                "Interval":"",
                "StartDate":"",
                "StartTime":"",
                "EndDate":"",
                "EndTime":""

            }
            
        }
    ]
~~~~~~~~~~~~~~~~~~~~~~~


### Can I run SSIS package without SQL job?

Yes. MSBITools has a function called 'Invoke-SsisPackage' for this.

To invoke package which is deployed in above steps. Create a Powershell shell file. Lets call it 'InvokeSSISPackage.ps1'.

Insert code as below.
~~~ Powershell
Import-Module .\MSBITools.psd1 -Force

$sqlConnection = New-SqlServerConnection -ServerName 'localhost'

Invoke-SsisPackage -PackageName 'Package.dtsx' -EnvName 'sit' -EnvFolderName 'ImportToCSV' -ProjectName 'ImportToCSV' -ProjectFolderName 'ImportToCSV' -SqlServerConnection $sqlConnection -Synchronized

~~~

Once done save the file.

To execute, open powershell console and change directory to the folder where the script is saved.

Execute this script as below

~~~ Powershell
.\InvokeSSISPackage.ps1
~~~