targetScope = 'subscription'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: '<<RESOURCE_GROUP_NAME>>'
  location: '<<RESOURCE_GROUP_LOCATION>>'
}
