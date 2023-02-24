@description('The name of the Cosmos DB account')
param cosmosAccountName string 
@description('The name of the Mongo DB')
param mongoDBName string = 'sampledatabase'
@description('The name of the Mongo collection')
param mongoCollectionName string = 'samplecollection'


resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing= {
  name: cosmosAccountName
}
resource cosmosDB 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2022-08-15' = {
  name: '${cosmosAccount.name}/${mongoDBName}'
  properties: {
    resource: {
      id: mongoDBName
    }
    options: {
    }
  }
}


resource cosmosCollection 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2022-08-15' = {
  name: mongoCollectionName
  parent: cosmosDB
  properties: {
    resource: {
      id: mongoCollectionName
      indexes: []
    }

    options: {
    }
  }
}

