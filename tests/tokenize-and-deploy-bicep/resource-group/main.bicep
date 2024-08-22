targetScope = 'resourceGroup'

param configurationStoreName string
param configurationKeyName string

@secure()
param configurationValue string

resource configurationStore 'Microsoft.AppConfiguration/configurationStores@2023-09-01-preview' = {
  name: configurationStoreName
  location: resourceGroup().location
  sku: {
    name: 'Standard'
  }
}

resource secretConfiguration 'Microsoft.AppConfiguration/configurationStores/keyValues@2023-09-01-preview' = {
  parent: configurationStore
  name: configurationKeyName
  properties: {
    value: configurationValue
  }
}
