# Prompt the user to enter the Log Query
$LogQuery = Read-Host "Enter the Log Query (e.g., Heartbeat | where TimeGenerated > ago(30m))"

# Prompt the user to enter the Resource Group
$ResourceGroupName = Read-Host "Enter the Resource Group name"

# Prompt the user to enter the Action Group
$ActionGroupId = Read-Host "Enter the Action Group ID"

# Set the data source ID for the Log Analytics workspace
$DataSourceId = "/subscriptions/6912d7a0-bc28-459a-9407-33bbba641c07/resourceGroups/app-grp/providers/Microsoft.OperationalInsights/workspaces/appworkspace"

# Connect to Azure account
Connect-AzAccount

# Create the Scheduled Query Rule source
$RuleSource = New-AzScheduledQueryRuleSource -Query $LogQuery `
                  -DataSourceId $DataSourceId `
                  -QueryType "ResultCount"

# Create the Scheduled Query Rule schedule
$RuleSchedule = New-AzScheduledQueryRuleSchedule -FrequencyInMinutes 5 -TimeWindowInMinutes 5

# Create the trigger condition
$TriggerCondition = New-AzScheduledQueryRuleTriggerCondition -ThresholdOperator "GreaterThan" -Threshold 3

# Create the Scheduled Query Rule action group
$ActionGroup = New-AzScheduledQueryRuleAznsActionGroup -ActionGroup @($ActionGroupId) -EmailSubject "Log Alert"

# Create the alert action
$AlertAction = New-AzScheduledQueryRuleAlertingAction -AznsAction $ActionGroup -Severity "1" -Trigger $TriggerCondition

# Create the Scheduled Query Rule
New-AzScheduledQueryRule -ResourceGroupName $ResourceGroupName -Location "North Europe" `
-Action $AlertAction -Enable $true -Description "This is an alert based on Log Analytics" `
-Schedule $RuleSchedule -Source $RuleSource -Name "Log Analytics alert"
