
@description('Name for the Cosmos DB account.')
param cosmosDBName string
@description('Location for resource.')
param location string
@description('Cosmos Offer Type')
param databaseAccountOfferType string = 'Standard'
@description('What language was used to deploy this resource')
param language string

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  kind: 'MongoDB'
  name: 'cosmos-${cosmosDBName}'
  location: location
  properties: {
    databaseAccountOfferType: databaseAccountOfferType
    name: cosmosDBName
  }
  tags: {
    language: language
  }
 
}

output cosmosDBAccountNameOutput string = databaseAccount.name
output cosmosDBAccountConnectionStringOutput string = databaseAccount.listConnectionStrings().connectionStrings[0].connectionString
