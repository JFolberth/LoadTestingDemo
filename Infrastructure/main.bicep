@description('Location for all resources.')
param location string
@description('Base name that will appear for all resources.') 
param baseName string = 'loadtestbicep'
@description('Three letter environment abreviation to denote environment that will appear in all resource names') 
param environmentName string = 'dev'
@description('App Service Plan Sku')
param appServicePlanSKU string
@description('How many days to retain Log Analytics Logs')
param retentionDays int
targetScope = 'subscription'

var regionReference = {
  centralus: 'cus'
  eastus: 'eus'
  westus: 'wus'
  westus2: 'wus2'
}
var nameSuffix = toLower('${baseName}-${environmentName}-${regionReference[location]}')
var nameSuffixData = toLower('${baseName}-data-${environmentName}-${regionReference[location]}')
var language = 'Bicep'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' ={
  name: toLower('rg-${nameSuffix}')
  location: location
}
resource resourceGroupData 'Microsoft.Resources/resourceGroups@2021-04-01' ={
  name: toLower('rg-${nameSuffixData}')
  location: location
}

module appService 'modules/appService.module.bicep' ={
  name: 'appServiceModule'
  scope: resourceGroup
  params:{
    location: location
    appServicePlanID: appServicePlan.outputs.appServicePlanID
    appServiceName: nameSuffix
    appInsightsInstrumentationKey: appInsights.outputs.appInsightsInstrumentationKey
    language: language
    cosmosDBConnectionString: mongoCosmosAccount.outputs.cosmosDBAccountConnectionStringOutput
  }
}

module appInsights 'modules/appInsights.module.bicep' ={
  name: 'appInsightsModule'
  scope: resourceGroup
  params:{
    location: location
    appInsightsName: nameSuffix
    language: language
    logAnalyticsWorkspaceID: logAnalytics.outputs.logAnalyticsWorkspaceID
  }
}
module logAnalytics 'modules/logAnalytics.module.bicep' ={
  name: 'logAnalyticsModule'
  scope: resourceGroup
  params:{
    location: location
    logAnalyticsName: nameSuffix
    language: language
    retentionDays: retentionDays
  }
}
module appServicePlan 'modules/appServicePlan.module.bicep' ={
  name: 'appServicePlanModule'
  scope: resourceGroup
  params:{
    location: location
    appServicePlanName: nameSuffix
    language: language
    appServicePlanSKU: appServicePlanSKU
  }
}
module mongoCosmosAccount 'modules/mongoCosmosAccount.module.bicep' ={
  name: 'mongoCosmosAccountModule'
  scope: resourceGroupData
  params:{
    location: location
    cosmosDBName: nameSuffix
    language: language
  }
}

module mongoDB 'modules/mongoDB.module.bicep' ={
  name: 'mongoDBModule'
  scope: resourceGroupData
  params:{
    cosmosAccountName: mongoCosmosAccount.outputs.cosmosDBAccountNameOutput
  }
}





