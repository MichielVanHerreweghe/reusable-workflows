targetScope = 'subscription'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'rg-tokenization_librarytest'
  location: 'westeurope'
  tags: {
    TEST_SECRET: 'SuperSecret!'
    TEST_VARIABLE: 'TESTVARIABLE'
  }
}
