<#
Command Reference

1. Set-AzAppServicePlan
https://docs.microsoft.com/en-us/powershell/module/az.websites/set-azappserviceplan?view=azps-7.3.0

2. New-AzWebAppSlot
https://docs.microsoft.com/en-us/powershell/module/az.websites/new-azwebappslot?view=azps-7.3.0

3. Switch-AzWebAppSlot
https://docs.microsoft.com/en-us/powershell/module/az.websites/switch-azwebappslot?view=azps-7.3.0

#>

# Prompt for input values
$ResourceGroupName = Read-Host "Enter the resource group name"
$WebAppName = Read-Host "Enter the web app name"
$AppServicePlanName = Read-Host "Enter the app service plan name"
$SlotName = Read-Host "Enter the name of the deployment slot"
$TargetSlot = Read-Host "Enter the target slot for switching"

# Connect to Azure account
Connect-AzAccount

# Set the Azure App Service Plan to Standard tier
Set-AzAppServicePlan -Name $AppServicePlanName -ResourceGroupName $ResourceGroupName -Tier Standard

# Create a new Web App slot
New-AzWebAppSlot -Name $WebAppName -ResourceGroupName $ResourceGroupName -Slot $SlotName

# Deploy the application onto the staging slot
# Ensure to use your own GitHub URL
$Properties = @{
    repoUrl = ""
    branch = "master"
    isManualIntegration = "true"
}
Set-AzResource -ResourceGroupName $ResourceGroupName -Properties $Properties `
    -ResourceType Microsoft.Web/sites/slots/sourcecontrols `
    -ResourceName "$WebAppName/$SlotName/web" -ApiVersion 2015-08-01 -Force

# Switch the slots
Switch-AzWebAppSlot -Name $WebAppName -ResourceGroupName $ResourceGroupName `
    -SourceSlotName $SlotName -DestinationSlotName $TargetSlot
