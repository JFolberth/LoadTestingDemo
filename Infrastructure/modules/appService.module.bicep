@description('Name for the App Service')
param appServiceName string
@description('Location for resource.')
param location string
@description('Resource ID of the App Service Plan')
param appServicePlanID string
@description('Instrumentation Key for App Insights')
param appInsightsInstrumentationKey string
@description('What language was used to deploy this resource')
param language string
@description('What version of NodeJS to use')
param nodeVersion string = '14.16.0'
@description('What version of PHP to use')
param phpVersion string = '7.1'
@description('CosmosDB Account Name')
param  cosmosDBConnectionString string



resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: toLower('app-${appServiceName}')
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: {
    displayName: 'Website'
    Language: language
  }
  properties: {
    serverFarmId: appServicePlanID
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      phpVersion: phpVersion
    }
  }
}
resource appServiceSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: '${appService.name}/appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
    WEBSITE_NODE_DEFAULT_VERSION: nodeVersion
    //CONNECTION_STRING: listConnectionStrings(cosmosAccount.id, '2022-08-15').connectionStrings[0].connectionString
    CONNECTION_STRING: cosmosDBConnectionString
    SCM_DO_BUILD_DURING_DEPLOYMENT:'true'

     }  
  }


