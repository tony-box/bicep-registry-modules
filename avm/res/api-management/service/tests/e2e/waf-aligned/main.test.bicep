targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-apimanagement.service-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apiswaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The secret to leverage for authorization server authentication.')
@secure()
param customSecret string = newGuid()

// Enforcing locations to not have conflicting availability zones
@description('Optional. The primary location to deploy resources to.')
var enforcedLocation = 'ukSouth'

@description('Optional. The secondary location to deploy resources to.')
var secondaryEnforcedLocation = 'northeurope'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    location: enforcedLocation
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    networkSecurityGroupName: 'dep-${namePrefix}-nsg-${serviceShort}'
    lawReplicationRegion: secondaryEnforcedLocation
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}azsa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
      publisherName: '${namePrefix}-az-amorg-x-001'
      additionalLocations: [
        {
          location: secondaryEnforcedLocation
          sku: {
            name: 'Premium'
            capacity: 3
          }
          availabilityZones: [
            1
            2
            3
          ]
          disableGateway: false
        }
      ]
      customProperties: {
        'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'False'
        'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'False'
        'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30': 'False'
        'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'False'
        'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'False'
        'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'False'
        'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'True'
        'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168': 'False'
        'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA': 'False'
        'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA': 'False'
        'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256': 'False'
        'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA': 'False'
        'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA256': 'False'
        'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA': 'False'
        'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_GCM_SHA256': 'False'
      }
      minApiVersion: '2022-08-01'
      apis: [
        {
          displayName: 'Echo API'
          description: 'An echo API service'
          name: 'echo-api'
          path: 'echo'
          serviceUrl: 'https://echoapi.cloudapp.net/api'
          protocols: [
            'https'
          ]
          apiVersionSetName: 'echo-version-set'
        }
      ]
      apiVersionSets: [
        {
          name: 'echo-version-set'
          description: 'An echo API version set'
          displayName: 'Echo version set'
          versioningScheme: 'Segment'
        }
      ]
      authorizationServers: [
        {
          authorizationEndpoint: '${environment().authentication.loginEndpoint}651b43ce-ccb8-4301-b551-b04dd872d401/oauth2/v2.0/authorize'
          clientId: 'apimClientid'
          clientSecret: customSecret
          clientRegistrationEndpoint: 'https://localhost'
          grantTypes: [
            'authorizationCode'
          ]
          name: 'AuthServer1'
          displayName: 'AuthServer1'
          tokenEndpoint: '${environment().authentication.loginEndpoint}651b43ce-ccb8-4301-b551-b04dd872d401/oauth2/v2.0/token'
        }
      ]
      backends: [
        {
          name: 'backend'
          tls: {
            validateCertificateChain: true
            validateCertificateName: true
          }
          url: 'https://echoapi.cloudapp.net/api'
        }
      ]
      caches: [
        {
          connectionString: 'connectionstringtest'
          name: 'westeurope'
          useFromLocation: 'westeurope'
        }
      ]
      diagnosticSettings: [
        {
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      identityProviders: [
        {
          name: 'aad'
          clientId: 'apimClientid'
          clientLibrary: 'MSAL-2'
          clientSecret: customSecret
          authority: split(environment().authentication.loginEndpoint, '/')[2]
          signinTenant: 'mytenant.onmicrosoft.com'
          allowedTenants: [
            'mytenant.onmicrosoft.com'
          ]
        }
      ]
      loggers: [
        {
          name: 'logger'
          loggerType: 'applicationInsights'
          isBuffered: false
          description: 'Logger to Azure Application Insights'
          credentials: {
            instrumentationKey: nestedDependencies.outputs.appInsightsInstrumentationKey
          }
          resourceId: nestedDependencies.outputs.appInsightsResourceId
        }
      ]
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      namedValues: [
        {
          displayName: 'apimkey'
          name: 'apimkey'
          secret: true
        }
      ]
      policies: [
        {
          format: 'xml'
          value: '<policies> <inbound> <rate-limit-by-key calls=\'250\' renewal-period=\'60\' counter-key=\'@(context.Request.IpAddress)\' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>'
        }
      ]
      portalsettings: [
        {
          name: 'signup'
          properties: {
            enabled: false
            termsOfService: {
              consentRequired: true
              enabled: true
              text: 'Terms of service text'
            }
            subscriptions: {
              enabled: false
            }
            url: ''
            userRegistration: {
              enabled: false
            }
            validationKey: ''
          }
        }
        {
          name: 'signin'
          properties: {
            enabled: false
            termsOfService: {
              consentRequired: true
              enabled: true
              text: 'Terms of service text'
            }
            subscriptions: {
              enabled: false
            }
            url: ''
            userRegistration: {
              enabled: false
            }
            validationKey: ''
          }
        }
      ]
      privateEndpoints: [
        {
          service: 'Gateway'
          subnetResourceId: nestedDependencies.outputs.privateEndpointSubnetResourceId
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          tags: {
            'hidden-title': 'This is visible in the resource name'
            Environment: 'Non-Prod'
            Role: 'DeploymentValidation'
          }
        }
        {
          service: 'Gateway'
          subnetResourceId: nestedDependencies.outputs.privateEndpointSubnetResourceId
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
        }
      ]
      products: [
        {
          apis: [
            {
              name: 'echo-api'
            }
          ]
          approvalRequired: true
          groups: [
            {
              name: 'developers'
            }
          ]
          name: 'Starter'
          subscriptionRequired: true
          displayName: 'Echo API'
          description: 'This is an echo API'
          terms: 'By accessing or using the services provided by Echo API through Azure API Management, you agree to be bound by these Terms of Use. These terms may be updated from time to time, and your continued use of the services constitutes acceptance of any changes.'
        }
      ]
      subscriptions: [
        {
          name: 'testArmSubscriptionAllApis'
          scope: '/apis'
          displayName: 'testArmSubscriptionAllApis'
        }
      ]
      virtualNetworkType: 'None' // Required for private endpoints
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
