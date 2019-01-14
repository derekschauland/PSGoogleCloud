<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.156
	 Created on:   	1/13/2019 5:03 PM
	 Created by:   	 Derek
	 Organization: 	 
	 Filename:     	Disable-GCPDefaultFirewallRule.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

Function Disable-GCPDefaultFirewallRule
{
    [cmdletbinding()]
    Param (
        [string]$Project,
        [string]$Network
    )
    
    BEGIN 
    {
        If ($Project -ne $null)
        {
            $projects = Get-GcpProject
        }
        Else
        {
            $projects = $project
        }
    }
    Process
    {
        ForEach ($item In $projects)
        {
            gcloud config set project $item
            
            $rules = gcloud compute firewall-rules list
            $rules | Out-File "$item-rules.json"
            
            $rulesobj = Get-Content "$item-rules.json" | ConvertFrom-Json
            
            ForEach ($fwrule In $rulesobj)
            {
                If (($fwrule.name -match "default-allow-rdp") -and ($fwrule.disabled -eq $false))
                {
                    gcloud compute firewall-rules update default-allow-rdp --disabled
                    
                    "$fwrule.name-disabled-$(Get-Date -Format "yyyy-MM-dd")" | Out-File "$fwrule.name-disabled-$(Get-Date -Format "yyyy-MM-dd")".txt
                    
                    
                }
                ElseIf (($fwrule.name -match "default-allow-ssh") -and ($fwrule.disabled -eq $false))
                {
                    gcloud compute firewall-rules update default-allow-ssh --disabled
                    "$fwrule.name-disabled-$(Get-Date -Format "yyyy-MM-dd")" | Out-File "$fwrule.name-disabled-$(Get-Date -Format "yyyy-MM-dd")"
                }
                
                If ((Test-Path "$fwrule.name-disabled-*") -and (Get-ChildItem "$fwrule.name-disabled-*").Count -eq 1)
                {
                    #check date at end of file name for age 7 days older than today
                    (Get-ChildItem "$fwrule.name-disabled-*").name.Substring((Get-ChildItem "$fwrule.name-disabled-*").name.Length - 10)
                }
            }
            #check for status of rule - if disabled check date in file and delete 
            
            
            #write file with project name, rule-name, date to bucket in gcp
            
            #check for file in bucket - if file exists, read file - if project and rule listed and date is older than 7 days from get date
            #delete rule
            
            
            #write file with project name, rule-name, date to bucket in gcp
            
            #check for file in bucket - if file exists, read file - if project and rule listed and date is older than 7 days from get date
            #delete rule
            
        }
    }
    END
    {
    	#write log that rule was disabled or deleted
    }
}
