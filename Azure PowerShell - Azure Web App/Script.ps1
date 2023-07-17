<#
Command Reference

1. New-AzAppServicePlan
https://docs.microsoft.com/en-us/powershell/module/az.websites/new-azappserviceplan?view=azps-7.3.0

2. New-AzWebApp
https://docs.microsoft.com/en-us/powershell/module/az.websites/new-azwebapp?view=azps-7.3.0

#>

# Input variables
$ResourceGroupName = Read-Host "Enter the resource group name"
$Location = Read-Host "Enter the location"
$AppServicePlanName = Read-Host "Enter the App Service Plan name"
$WebAppName = Read-Host "Enter the Web App name"

Connect-AzAccount

New-AzResouceGroup -Name $ResourceGroupName -Location $Location

# Create an App Service Plan
New-AzAppServicePlan -ResourceGroupName $ResourceGroupName `
-Location $Location -Tier "B1" -NumberofWorkers 1 -Name $AppServicePlanName

# Create the Azure Web App
New-AzWebApp -ResourceGroupName $ResourceGroupName -Name $WebAppName `
-Location $Location -AppServicePlan $AppServicePlanName
