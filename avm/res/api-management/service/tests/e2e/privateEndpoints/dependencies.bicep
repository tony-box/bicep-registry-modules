@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the NSG to create.')
param networkSecurityGroupName string

var addressPrefix = '10.0.0.0/16'

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: []
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 0)
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
      {
        name: 'privateEndpointSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 1)
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.azure-api.net'
  location: 'global'
  properties: {}
}

resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZone
  name: '${virtualNetworkName}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}

@description('The resource ID of the created Virtual Network.')
output virtualNetworkResourceId string = virtualNetwork.id

@description('The resource ID of the created subnet for private endpoints.')
output privateEndpointSubnetResourceId string = virtualNetwork.properties.subnets[1].id

@description('The resource ID of the created private DNS zone.')
output privateDNSZoneResourceId string = privateDnsZone.id
