targetScope = 'subscription'

param resourceGroupName string
param location string

@secure()
param tagSecret string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: {
    SECRET: tagSecret
  }
}
