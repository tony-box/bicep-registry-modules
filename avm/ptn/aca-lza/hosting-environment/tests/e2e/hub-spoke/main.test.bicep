metadata name = 'Using a hub and spoke deployment.'
metadata description = 'This instance deploys the module including a Hub to peer to.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cahub'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

// ================= //
// Variables Section //
// ================= //

var certificateName = 'appgwcert'

// ============ //
// Dependencies //
// // ============ //
module hubdeployment 'deploy.hub.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-hub-${serviceShort}'
  params: {
    location: resourceLocation
    tags: {
      environment: 'test'
    }
    workloadName: serviceShort
  }
}

// ============== //
// Test Execution //
// ============== //
module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    workloadName: serviceShort
    hubVirtualNetworkResourceId: hubdeployment.outputs.hubVNetId
    networkApplianceIpAddress: hubdeployment.outputs.networkApplianceIpAddress
    tags: {
      environment: 'test'
    }
    environment: 'dev'
    location: resourceLocation
    vmSize: 'Standard_B1s'
    storageAccountType: 'Premium_LRS'
    vmAdminPassword: password
    vmAuthenticationType: 'sshPublicKey'
    vmJumpboxOSType: 'linux'
    vmJumpBoxSubnetAddressPrefix: '10.1.2.32/27'
    spokeVNetAddressPrefixes: [
      '10.1.0.0/21'
    ]
    spokeInfraSubnetAddressPrefix: '10.1.0.0/23'
    spokePrivateEndpointsSubnetAddressPrefix: '10.1.2.0/27'
    spokeApplicationGatewaySubnetAddressPrefix: '10.1.3.0/24'
    deploymentSubnetAddressPrefix: '10.1.4.0/24'
    enableApplicationInsights: true
    enableDaprInstrumentation: false
    applicationGatewayCertificateKeyName: certificateName
    deployZoneRedundantResources: true
    exposeContainerAppsWith: 'applicationGateway'
    enableDdosProtection: true
  }
}

output testDeploymentOutputs object = testDeployment.outputs
