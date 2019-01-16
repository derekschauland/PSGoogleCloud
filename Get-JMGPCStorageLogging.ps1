<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.156
	 Created on:   	1/10/2019 10:51 AM
	 Created by:   	dschauland
	 Organization: 	
	 Filename:     	Get-JMGCPStorageLog.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

function Get-JMGCPStorageLog
{
	[cmdletbinding()]
	param (
		[Parameter(Mandatory)]
		[string]$Project,
		[switch]$logonly
	)
	
	BEGIN 
	{
		gcloud config set project $Project
		
	}
	PROCESS
	{
		$buckets = gsutil ls
		
		foreach ($bucket in $buckets)
		{
			

			
			If (!($logonly))
			{
				$Message = "$(gsutil logging get $bucket)"
				$LogFilePath = "C:\temp\$Project-log-current.txt"
				("{0} - {1}" -f @((Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message)) | Out-File -FilePath $LogFilePath -Encoding utf8 -Append
				
				gsutil logging get $bucket
			}
			Else
			{
				$Message = "$(gsutil logging get $bucket)"
				$LogFilePath = "C:\temp\$Project-log-current.txt"
				("{0} - {1}" -f @((Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message)) | Out-File -FilePath $LogFilePath -Encoding utf8 -Append
				
			}
			
		}
	}
	End
	{
		If ((gsutil ls -b gs://$project-logs) -eq "$project-logs")
		{
			
			gsutil cp "C:\temp\$Project-log-current.txt" "gs://$project-logs"
		}
		Else
		{
			gsutil mb -l us-central1 "gs://$project-logs"
			gsutil cp "C:\temp\$Project-log-current.txt" "gs://$project-logs"
		}
		
	}
}
