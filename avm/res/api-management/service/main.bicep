metadata name = 'API Management Services'
metadata description = 'This module deploys an API Management Service. The default deployment is set to use a Premium SKU to align with Microsoft WAF-aligned best practices. In most cases, non-prod deployments should use a lower-tier SKU.'

@description('Optional. Additional datacenter locations of the API Management service. Not supported with V2 SKUs.')
param additionalLocations additionalLocationType[]?

@description('Required. The name of the API Management service.')
param name string

@description('Optional. List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10.')
@maxLength(10)
param certificates array?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Custom properties of the API Management service. Not supported if SKU is Consumption.')
param customProperties resourceInput<'Microsoft.ApiManagement/service@2024-05-01'>.properties.customProperties = {
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA256': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_GCM_SHA256': 'False'
}

@description('Optional. Property only valid for an API Management service deployed in multiple locations. This can be used to disable the gateway in master region.')
param disableGateway bool = false

@description('Optional. Property only meant to be used for Consumption SKU Service. This enforces a client certificate to be presented on each request to the gateway. This also enables the ability to authenticate the certificate in the policy on the gateway.')
param enableClientCertificate bool = false

@description('Optional. Custom hostname configuration of the API Management service.')
param hostnameConfigurations resourceInput<'Microsoft.ApiManagement/service@2024-05-01'>.properties.hostnameConfigurations?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Limit control plane API calls to API Management service with version equal to or newer than this value.')
param minApiVersion string?

@description('Optional. The notification sender email address for the service.')
param notificationSenderEmail string = 'apimgmt-noreply@mail.windowsazure.com'

@description('Required. The email address of the owner of the service.')
param publisherEmail string

@description('Required. The name of the owner of the service.')
param publisherName string

@description('Optional. Undelete API Management Service if it was previously soft-deleted. If this flag is specified and set to True all other properties will be ignored.')
param restore bool = false

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. The pricing tier of this API Management service.')
@allowed([
  'Consumption'
  'Developer'
  'Basic'
  'Standard'
  'Premium'
  'StandardV2'
  'BasicV2'
])
param sku string = 'Premium'

@description('Conditional. The scale units for this API Management service. Required if using Basic, Standard, or Premium skus. For range of capacities for each sku, reference https://azure.microsoft.com/en-us/pricing/details/api-management/.')
param skuCapacity int = 3

@description('Optional. The full resource ID of a subnet in a virtual network to deploy the API Management service in. VNet injection is supported with Developer, Premium, and StandardV2 SKUs only.')
param subnetResourceId string?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.ApiManagement/service@2024-05-01'>.tags?

@description('Optional. The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only. VNet injection (External/Internal) is supported with Developer, Premium, and StandardV2 SKUs only.')
@allowed([
  'None'
  'External'
  'Internal'
])
param virtualNetworkType string = 'None'

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. A list of availability zones denoting where the resource needs to come from. Only supported by Premium sku.')
@allowed([
  1
  2
  3
])
param availabilityZones int[] = [
  1
  2
  3
]

@description('Optional. Necessary to create a new GUID.')
param newGuidValue string = newGuid()

@description('Optional. APIs.')
param apis apiType[]?

@description('Optional. API Version Sets.')
param apiVersionSets apiVersionSetType[]?

@description('Optional. Authorization servers.')
param authorizationServers authorizationServerType[]?

@description('Optional. Backends.')
param backends array?

@description('Optional. Caches.')
param caches array?

@description('Optional. API Diagnostics.')
param apiDiagnostics array?

@description('Optional. Identity providers.')
param identityProviders array?

@description('Optional. Loggers.')
param loggers array?

@description('Optional. Named values.')
param namedValues array?

@description('Optional. Policies.')
param policies array?

@description('Optional. Portal settings.')
param portalsettings array?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Note: Private endpoints are supported with Developer, Basic, Standard, Premium, BasicV2, and StandardV2 SKUs only. Consumption SKU does not support private endpoints. \'virtualNetworkType\' must be set to \'None\' (or left empty which defaults to \'None\') on initial deployment of Private Endpoints.')
param privateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Products.')
param products array?

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. Note: Cannot be set to "Disabled" during initial service creation - must be changed post-deployment. If not specified, defaults to "Enabled".')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string?

@description('Optional. Subscriptions.')
param subscriptions array?

@description('Optional. Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the region. Supported only for Developer and Premium SKUs when deployed in Virtual Network.')
param publicIpAddressResourceId string?

@description('Optional. Enable the Developer Portal. The developer portal is not supported on the Consumption SKU.')
param enableDeveloperPortal bool = false

// =============== //
//   Validations   //
// =============== //

// Define SKU capabilities for validation
var skuCapabilities = {
  Consumption: {
    supportsPrivateEndpoints: false
    supportsVNetInjection: false
    supportsPublicIpAddress: false
    supportsAdditionalLocations: false
  }
  Developer: {
    supportsPrivateEndpoints: true
    supportsVNetInjection: true
    supportsPublicIpAddress: true
    supportsAdditionalLocations: false
  }
  Basic: {
    supportsPrivateEndpoints: true
    supportsVNetInjection: false
    supportsPublicIpAddress: false
    supportsAdditionalLocations: false
  }
  Standard: {
    supportsPrivateEndpoints: true
    supportsVNetInjection: false
    supportsPublicIpAddress: false
    supportsAdditionalLocations: false
  }
  Premium: {
    supportsPrivateEndpoints: true
    supportsVNetInjection: true
    supportsPublicIpAddress: true
    supportsAdditionalLocations: true
  }
  BasicV2: {
    supportsPrivateEndpoints: true
    supportsVNetInjection: false
    supportsPublicIpAddress: false
    supportsAdditionalLocations: false
  }
  StandardV2: {
    supportsPrivateEndpoints: true
    supportsVNetInjection: true // Outbound integration only
    supportsPublicIpAddress: false
    supportsAdditionalLocations: false
  }
}

// Validation: Private endpoints are only supported on specific SKUs
var privateEndpointsRequested = !empty(privateEndpoints)
var privateEndpointsSupportedForSku = skuCapabilities[sku].supportsPrivateEndpoints

// Validation: VNet injection is only supported on specific SKUs
var vnetInjectionRequested = virtualNetworkType != 'None' || !empty(subnetResourceId)
var vnetInjectionSupportedForSku = skuCapabilities[sku].supportsVNetInjection

// Validation: Public IP address is only supported on specific SKUs
var publicIpRequested = !empty(publicIpAddressResourceId)
var publicIpSupportedForSku = skuCapabilities[sku].supportsPublicIpAddress

// Validation: Additional locations are only supported on Premium SKU
var additionalLocationsRequested = !empty(additionalLocations)
var additionalLocationsSupportedForSku = skuCapabilities[sku].supportsAdditionalLocations

// Validation: Internal VNet mode requires VNet injection support
var internalVNetRequested = virtualNetworkType == 'Internal'

// Validation: Private endpoints and VNet injection cannot be used together
var privateEndpointsAndVNetConflict = privateEndpointsRequested && vnetInjectionRequested

// Validation logic - these will cause deployment to fail with clear messages if conditions are violated
var privateEndpointsAllowed = !privateEndpointsRequested || privateEndpointsSupportedForSku
var vnetInjectionAllowed = !vnetInjectionRequested || vnetInjectionSupportedForSku
var publicIpAllowed = !publicIpRequested || (publicIpSupportedForSku && vnetInjectionRequested)
var additionalLocationsAllowed = !additionalLocationsRequested || additionalLocationsSupportedForSku
var internalVNetAllowed = !internalVNetRequested || vnetInjectionSupportedForSku
var privateEndpointsAndVNetAllowed = !privateEndpointsAndVNetConflict

// Error messages for invalid configurations
var configurationError = !privateEndpointsAllowed
  ? 'Private endpoints are not supported with the ${sku} SKU. Supported SKUs: Developer, Basic, Standard, Premium, BasicV2, StandardV2.'
  : !vnetInjectionAllowed
      ? 'Virtual network injection is not supported with the ${sku} SKU. Supported SKUs for VNet injection: Developer, Premium, StandardV2.'
      : !publicIpAllowed && publicIpRequested && !vnetInjectionRequested
          ? 'Public IP address can only be assigned when deploying to a virtual network (set virtualNetworkType or provide subnetResourceId).'
          : !publicIpAllowed
              ? 'Public IP address assignment is not supported with the ${sku} SKU. Supported SKUs: Developer, Premium (when deployed in VNet).'
              : !additionalLocationsAllowed
                  ? 'Additional locations are only supported with the Premium SKU.'
                  : !internalVNetAllowed
                      ? 'Internal virtual network mode is not supported with the ${sku} SKU. Supported SKUs: Developer, Premium, StandardV2.'
                      : !privateEndpointsAndVNetAllowed
                          ? 'Private endpoints and VNet injection cannot be used together. When using private endpoints, set virtualNetworkType to None and do not provide subnetResourceId.'
                          : ''

// This will cause the deployment to fail with a clear error message if any validation fails
var validationPassed = privateEndpointsAllowed && vnetInjectionAllowed && publicIpAllowed && additionalLocationsAllowed && internalVNetAllowed && privateEndpointsAndVNetAllowed

var enableReferencedModulesTelemetry = false

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  'API Management Developer Portal Content Editor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'c031e6a8-4391-4de0-8d69-4706a7ed3729'
  )
  'API Management Service Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '312a565d-c81f-4fd8-895a-4e21e48d571c'
  )
  'API Management Service Operator Role': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'e022efe7-f5ba-4159-bbe4-b44f577e9b61'
  )
  'API Management Service Reader Role': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '71522526-b88f-4d52-b57f-d31fc3546d0d'
  )
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.apimanagement-service.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource service 'Microsoft.ApiManagement/service@2024-05-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
    capacity: contains(sku, 'Consumption') ? 0 : contains(sku, 'Developer') ? 1 : skuCapacity
  }
  zones: contains(sku, 'Premium') ? map(availabilityZones, zone => string(zone)) : []
  identity: identity
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    notificationSenderEmail: notificationSenderEmail
    hostnameConfigurations: hostnameConfigurations
    additionalLocations: validationPassed && contains(sku, 'Premium') && !empty(additionalLocations)
      ? map((additionalLocations ?? []), additLoc => {
          location: additLoc.location
          sku: additLoc.sku
          disableGateway: additLoc.?disableGateway
          natGatewayState: additLoc.?natGatewayState
          publicIpAddressId: additLoc.?publicIpAddressResourceId
          virtualNetworkConfiguration: additLoc.?virtualNetworkConfiguration
          zones: map(additLoc.?availabilityZones ?? [], zone => string(zone))
        })
      : !validationPassed && !empty(additionalLocations) ? json('null /* ${configurationError} */') : []
    customProperties: contains(sku, 'Consumption') ? null : customProperties
    certificates: certificates
    enableClientCertificate: enableClientCertificate ? true : null
    disableGateway: disableGateway
    virtualNetworkType: validationPassed ? virtualNetworkType : 'None' // Force to None if validation fails
    virtualNetworkConfiguration: validationPassed && !empty(subnetResourceId)
      ? {
          subnetResourceId: subnetResourceId
        }
      : !validationPassed && !empty(subnetResourceId) ? json('null /* ${configurationError} */') : null
    publicIpAddressId: validationPassed
      ? publicIpAddressResourceId
      : (!empty(publicIpAddressResourceId) ? json('null /* ${configurationError} */') : null)
    publicNetworkAccess: !empty(publicNetworkAccess) ? publicNetworkAccess : 'Enabled'
    apiVersionConstraint: !empty(minApiVersion)
      ? {
          minApiVersion: minApiVersion
        }
      : {
          minApiVersion: '2021-08-01'
        }
    restore: restore
    developerPortalStatus: sku != 'Consumption' ? (enableDeveloperPortal ? 'Enabled' : 'Disabled') : null
  }
}

module service_apis 'api/main.bicep' = [
  for (api, index) in (apis ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Api-${index}'
    params: {
      apiManagementServiceName: service.name
      displayName: api.displayName
      name: api.name
      path: api.path
      description: api.?description
      apiRevision: api.?apiRevision
      apiRevisionDescription: api.?apiRevisionDescription
      apiType: api.?apiType
      apiVersion: api.?apiVersion
      apiVersionDescription: api.?apiVersionDescription
      apiVersionSetName: api.?apiVersionSetName
      authenticationSettings: api.?authenticationSettings
      format: api.?format
      isCurrent: api.?isCurrent
      protocols: api.?protocols
      policies: api.?policies
      serviceUrl: api.?serviceUrl
      sourceApiId: api.?sourceApiId
      subscriptionKeyParameterNames: api.?subscriptionKeyParameterNames
      subscriptionRequired: api.?subscriptionRequired
      type: api.?type
      value: api.?value
      wsdlSelector: api.?wsdlSelector
    }
    dependsOn: [
      service_apiVersionSets
    ]
  }
]

module service_apiVersionSets 'api-version-set/main.bicep' = [
  for (apiVersionSet, index) in (apiVersionSets ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-ApiVersionSet-${index}'
    params: {
      apiManagementServiceName: service.name
      name: apiVersionSet.name
      displayName: apiVersionSet.displayName
      versioningScheme: apiVersionSet.versioningScheme
      description: apiVersionSet.?description
      versionHeaderName: apiVersionSet.?versionHeaderName
      versionQueryName: apiVersionSet.?versionQueryName
    }
  }
]

module service_authorizationServers 'authorization-server/main.bicep' = [
  for (authorizationServer, index) in (authorizationServers ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-AuthorizationServer-${index}'
    params: {
      apiManagementServiceName: service.name
      name: authorizationServer.name
      displayName: authorizationServer.displayName
      authorizationEndpoint: authorizationServer.authorizationEndpoint
      authorizationMethods: authorizationServer.?authorizationMethods ?? ['GET']
      bearerTokenSendingMethods: authorizationServer.?bearerTokenSendingMethods ?? ['authorizationHeader']
      clientAuthenticationMethod: authorizationServer.?clientAuthenticationMethod ?? ['Basic']
      clientId: authorizationServer.clientId
      clientSecret: authorizationServer.clientSecret
      clientRegistrationEndpoint: authorizationServer.?clientRegistrationEndpoint ?? ''
      defaultScope: authorizationServer.?defaultScope ?? ''
      grantTypes: authorizationServer.grantTypes
      resourceOwnerPassword: authorizationServer.?resourceOwnerPassword ?? ''
      resourceOwnerUsername: authorizationServer.?resourceOwnerUsername ?? ''
      serverDescription: authorizationServer.?serverDescription ?? ''
      supportState: authorizationServer.?supportState ?? false
      tokenBodyParameters: authorizationServer.?tokenBodyParameters ?? []
      tokenEndpoint: authorizationServer.?tokenEndpoint ?? ''
    }
  }
]

module service_backends 'backend/main.bicep' = [
  for (backend, index) in (backends ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Backend-${index}'
    params: {
      apiManagementServiceName: service.name
      url: backend.url
      description: backend.?description
      credentials: backend.?credentials
      name: backend.name
      protocol: backend.?protocol
      proxy: backend.?proxy
      resourceId: backend.?resourceId
      serviceFabricCluster: backend.?serviceFabricCluster
      title: backend.?title
      tls: backend.?tls ?? { validateCertificateChain: true, validateCertificateName: true }
    }
  }
]

module service_caches 'cache/main.bicep' = [
  for (cache, index) in (caches ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Cache-${index}'
    params: {
      apiManagementServiceName: service.name
      description: cache.?description
      connectionString: cache.connectionString
      name: cache.name
      resourceId: cache.?resourceId
      useFromLocation: cache.useFromLocation
    }
  }
]

module service_apiDiagnostics 'api/diagnostics/main.bicep' = [
  for (apidiagnostic, index) in (apiDiagnostics ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Api-Diagnostic-${index}'
    params: {
      apiManagementServiceName: service.name
      apiName: apidiagnostic.apiName
      loggerName: apidiagnostic.?loggerName
      name: apidiagnostic.?name
      alwaysLog: apidiagnostic.?alwaysLog
      backend: apidiagnostic.?backend
      frontend: apidiagnostic.?frontend
      httpCorrelationProtocol: apidiagnostic.?httpCorrelationProtocol
      logClientIp: apidiagnostic.?logClientIp
      metrics: apidiagnostic.?metrics
      operationNameFormat: apidiagnostic.?operationNameFormat
      samplingPercentage: apidiagnostic.?samplingPercentage
      verbosity: apidiagnostic.?verbosity
    }
    dependsOn: [
      service_apis
      service_loggers
    ]
  }
]

module service_identityProviders 'identity-provider/main.bicep' = [
  for (identityProvider, index) in (identityProviders ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-IdentityProvider-${index}'
    params: {
      apiManagementServiceName: service.name
      name: identityProvider.name
      allowedTenants: identityProvider.?allowedTenants ?? []
      authority: identityProvider.?authority ?? ''
      clientId: identityProvider.?clientId ?? ''
      clientLibrary: identityProvider.?clientLibrary ?? ''
      clientSecret: identityProvider.?clientSecret ?? ''
      passwordResetPolicyName: identityProvider.?passwordResetPolicyName ?? ''
      profileEditingPolicyName: identityProvider.?profileEditingPolicyName ?? ''
      signInPolicyName: identityProvider.?signInPolicyName ?? ''
      signInTenant: identityProvider.?signInTenant ?? ''
      signUpPolicyName: identityProvider.?signUpPolicyName ?? ''
      type: identityProvider.?type ?? 'aad'
    }
  }
]

module service_loggers 'logger/main.bicep' = [
  for (logger, index) in (loggers ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Logger-${index}'
    params: {
      name: logger.name
      apiManagementServiceName: service.name
      credentials: logger.?credentials ?? {}
      isBuffered: logger.?isBuffered
      description: logger.?loggerDescription
      type: logger.?loggerType ?? 'azureMonitor'
      targetResourceId: logger.?targetResourceId ?? ''
    }
    dependsOn: [
      service_namedValues
    ]
  }
]

module service_namedValues 'named-value/main.bicep' = [
  for (namedValue, index) in (namedValues ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-NamedValue-${index}'
    params: {
      apiManagementServiceName: service.name
      displayName: namedValue.displayName
      keyVault: namedValue.?keyVault ?? {}
      name: namedValue.name
      tags: namedValue.?tags // Note: these are not resource tags
      secret: namedValue.?secret ?? false
      value: namedValue.?value ?? newGuidValue
    }
  }
]

module service_portalsettings 'portalsetting/main.bicep' = [
  for (portalsetting, index) in (portalsettings ?? []): if (!empty(portalsetting.properties)) {
    name: '${uniqueString(deployment().name, location)}-Apim-PortalSetting-${index}'
    params: {
      apiManagementServiceName: service.name
      name: portalsetting.name
      properties: portalsetting.properties
    }
  }
]

module service_policies 'policy/main.bicep' = [
  for (policy, index) in (policies ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Policy-${index}'
    params: {
      apiManagementServiceName: service.name
      value: policy.value
      format: policy.?format ?? 'xml'
    }
  }
]

module service_products 'product/main.bicep' = [
  for (product, index) in (products ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Product-${index}'
    params: {
      displayName: product.displayName
      apiManagementServiceName: service.name
      apis: product.?apis ?? []
      approvalRequired: product.?approvalRequired ?? false
      groups: product.?groups ?? []
      name: product.name
      description: product.?description ?? ''
      state: product.?state ?? 'published'
      subscriptionRequired: product.?subscriptionRequired ?? false
      subscriptionsLimit: product.?subscriptionsLimit ?? 1
      terms: product.?terms ?? ''
    }
    dependsOn: [
      service_apis
    ]
  }
]

module service_subscriptions 'subscription/main.bicep' = [
  for (subscription, index) in (subscriptions ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Subscription-${index}'
    params: {
      apiManagementServiceName: service.name
      name: subscription.name
      displayName: subscription.displayName
      allowTracing: subscription.?allowTracing
      ownerId: subscription.?ownerId
      primaryKey: subscription.?primaryKey
      scope: subscription.?scope
      secondaryKey: subscription.?secondaryKey
      state: subscription.?state
    }
  }
]

resource service_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: service
}

resource service_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: service
  }
]

resource service_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(service.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: service
  }
]

module service_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.11.0' = [
  for (privateEndpoint, index) in (validationPassed ? (privateEndpoints ?? []) : []): {
    name: '${uniqueString(deployment().name, location)}-service-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(service.id, '/'))}-${privateEndpoint.?service ?? 'Gateway'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(service.id, '/'))}-${privateEndpoint.?service ?? 'Gateway'}-${index}'
              properties: {
                privateLinkServiceId: service.id
                groupIds: [
                  privateEndpoint.?service ?? 'Gateway'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(service.id, '/'))}-${privateEndpoint.?service ?? 'Gateway'}-${index}'
              properties: {
                privateLinkServiceId: service.id
                groupIds: [
                  privateEndpoint.?service ?? 'Gateway'
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      subnetResourceId: privateEndpoint.subnetResourceId
      enableTelemetry: enableReferencedModulesTelemetry
      location: privateEndpoint.?location ?? reference(
        split(privateEndpoint.subnetResourceId, '/subnets/')[0],
        '2020-06-01',
        'Full'
      ).location
      lock: privateEndpoint.?lock ?? lock
      privateDnsZoneGroup: privateEndpoint.?privateDnsZoneGroup
      roleAssignments: privateEndpoint.?roleAssignments
      tags: privateEndpoint.?tags ?? tags
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
  }
]

@description('The name of the API management service.')
output name string = service.name

@description('The resource ID of the API management service.')
output resourceId string = service.id

@description('The resource group the API management service was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = service.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = service.location

@description('The configuration validation status.')
output configurationValid bool = validationPassed

@description('Configuration error message (if any).')
output configurationErrorMessage string = validationPassed ? '' : configurationError

@description('The private endpoints of the API management service.')
output privateEndpoints privateEndpointOutputType[] = [
  for (pe, index) in (validationPassed ? (privateEndpoints ?? []) : []): {
    name: service_privateEndpoints[index].outputs.name
    resourceId: service_privateEndpoints[index].outputs.resourceId
    groupId: service_privateEndpoints[index].outputs.?groupId!
    customDnsConfigs: service_privateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: service_privateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

// =============== //
//   Definitions   //
// =============== //
import { tokenBodyParameterType } from 'authorization-server/main.bicep'

@export()
@description('The type for an authorization server.')
type authorizationServerType = {
  @description('Required. Identifier of the authorization server.')
  name: string

  @description('Required. API Management Service Authorization Servers name. Must be 1 to 50 characters long.')
  @maxLength(50)
  displayName: string

  @description('Required. OAuth authorization endpoint. See <http://tools.ietf.org/html/rfc6749#section-3.2>.')
  authorizationEndpoint: string

  @description('Optional. HTTP verbs supported by the authorization endpoint. GET must be always present. POST is optional. - HEAD, OPTIONS, TRACE, GET, POST, PUT, PATCH, DELETE.')
  authorizationMethods: string[]?

  @description('Optional. Specifies the mechanism by which access token is passed to the API. - authorizationHeader or query.')
  bearerTokenSendingMethods: string[]?

  @description('Optional. Method of authentication supported by the token endpoint of this authorization server. Possible values are Basic and/or Body. When Body is specified, client credentials and other parameters are passed within the request body in the application/x-www-form-urlencoded format. - Basic or Body.')
  clientAuthenticationMethod: string[]?

  @description('Required. Client or app ID registered with this authorization server.')
  @secure()
  clientId: string

  @description('Optional. Optional reference to a page where client or app registration for this authorization server is performed. Contains absolute URL to entity being referenced.')
  clientRegistrationEndpoint: string?

  @description('Required. Client or app secret registered with this authorization server. This property will not be filled on \'GET\' operations! Use \'/listSecrets\' POST request to get the value.')
  @secure()
  clientSecret: string

  @description('Optional. Access token scope that is going to be requested by default. Can be overridden at the API level. Should be provided in the form of a string containing space-delimited values.')
  defaultScope: string?

  @description('Optional. Description of the authorization server. Can contain HTML formatting tags.')
  serverDescription: string?

  @description('Required. Form of an authorization grant, which the client uses to request the access token. - authorizationCode, implicit, resourceOwnerPassword, clientCredentials.')
  grantTypes: ('authorizationCode' | 'clientCredentials' | 'implicit' | 'resourceOwnerPassword')[]

  @description('Optional. Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner password.')
  @secure()
  resourceOwnerPassword: string?

  @description('Optional. Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner username.')
  resourceOwnerUsername: string?

  @description('Optional. If true, authorization server will include state parameter from the authorization request to its response. Client may use state parameter to raise protocol security.')
  supportState: bool?

  @description('Optional. Additional parameters required by the token endpoint of this authorization server represented as an array of JSON objects with name and value string properties, i.e. {"name" : "name value", "value": "a value"}. - TokenBodyParameterContract object.')
  tokenBodyParameters: tokenBodyParameterType[]?

  @description('Optional. OAuth token endpoint. Contains absolute URI to entity being referenced.')
  tokenEndpoint: string?
}

import { diagnosticType, operationType, policyType } from 'api/main.bicep'

@export()
@description('The type of an API Management service API.')
type apiType = {
  @description('Required. API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.')
  name: string

  @description('Optional. Array of Policies to apply to the Service API.')
  policies: policyType[]?

  @description('Optional. Array of diagnostics to apply to the Service API.')
  diagnostics: diagnosticType[]?

  @description('Optional. The operations of the api.')
  operations: operationType[]?

  @description('Optional. Describes the Revision of the API. If no value is provided, default revision 1 is created.')
  apiRevision: string?

  @description('Optional. Description of the API Revision.')
  apiRevisionDescription: string?

  @description('Optional. Type of API to create. * http creates a REST API * soap creates a SOAP pass-through API * websocket creates websocket API * graphql creates GraphQL API.')
  apiType: ('graphql' | 'http' | 'soap' | 'websocket')?

  @description('Optional. Indicates the Version identifier of the API if the API is versioned.')
  apiVersion: string?

  @description('Optional. The name of the API version set to link.')
  apiVersionSetName: string?

  @description('Optional. Description of the API Version.')
  apiVersionDescription: string?

  @description('Optional. Collection of authentication settings included into this API.')
  authenticationSettings: resourceInput<'Microsoft.ApiManagement/service/apis@2024-05-01'>.properties.authenticationSettings?

  @description('Optional. Description of the API. May include HTML formatting tags.')
  description: string?

  @description('Required. API name. Must be 1 to 300 characters long.')
  @maxLength(300)
  displayName: string

  @description('Optional. Format of the Content in which the API is getting imported.')
  format: (
    | 'wadl-xml'
    | 'wadl-link-json'
    | 'swagger-json'
    | 'swagger-link-json'
    | 'wsdl'
    | 'wsdl-link'
    | 'openapi'
    | 'openapi+json'
    | 'openapi-link'
    | 'openapi+json-link')?

  @description('Optional. Indicates if API revision is current API revision.')
  isCurrent: bool?

  @description('Required. Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.')
  path: string

  @description('Optional. Describes on which protocols the operations in this API can be invoked. - HTTP or HTTPS.')
  protocols: string[]?

  @description('Optional. Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long.')
  @maxLength(2000)
  serviceUrl: string?

  @description('Optional. API identifier of the source API.')
  sourceApiId: string?

  @description('Optional. Protocols over which API is made available.')
  subscriptionKeyParameterNames: resourceInput<'Microsoft.ApiManagement/service/apis@2024-05-01'>.properties.subscriptionKeyParameterNames?

  @description('Optional. Specifies whether an API or Product subscription is required for accessing the API.')
  subscriptionRequired: bool?

  @description('Optional. Type of API.')
  type: ('graphql' | 'http' | 'soap' | 'websocket')?

  @description('Optional. Content value when Importing an API.')
  value: string?
}

@export()
@description('The type of an API Management service API Version Set.')
type apiVersionSetType = {
  @sys.description('Required. API Version set name.')
  name: string

  @sys.description('Required. The display name of the Name of API Version Set.')
  @minLength(1)
  @maxLength(100)
  displayName: string

  @sys.description('Required. An value that determines where the API Version identifier will be located in a HTTP request.')
  versioningScheme: ('Header' | 'Query' | 'Segment')

  @sys.description('Optional. Description of API Version Set.')
  description: string?

  @sys.description('Optional. Name of HTTP header parameter that indicates the API Version if versioningScheme is set to header.')
  @minLength(1)
  @maxLength(100)
  versionHeaderName: string?

  @sys.description('Optional. Name of query parameter that indicates the API Version if versioningScheme is set to query.')
  @minLength(1)
  @maxLength(100)
  versionQueryName: string?
}

@export()
@description('The type of an API Management service additional location.')
type additionalLocationType = {
  @sys.description('Optional. Property only valid for an Api Management service deployed in multiple locations. This can be used to disable the gateway in this additional location.')
  disableGateway: bool?

  @sys.description('Required. The location name of the additional region among Azure Data center regions.')
  location: string

  @sys.description('Optional. Property can be used to enable NAT Gateway for this API Management service.')
  natGatewayState: ('Disabled' | 'Enabled')?

  @sys.description('Optional. Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the location. Supported only for Premium SKU being deployed in Virtual Network.')
  publicIpAddressResourceId: string?

  @sys.description('Required. SKU properties of the API Management service.')
  sku: {
    @sys.description('Required. Capacity of the SKU (number of deployed units of the SKU). For Consumption SKU capacity must be specified as 0.')
    capacity: int

    @sys.description('Required. Name of the Sku.')
    name: ('Basic' | 'BasicV2' | 'Consumption' | 'Developer' | 'Isolated' | 'Premium' | 'Standard' | 'StandardV2')
  }

  @sys.description('Optional. Virtual network configuration for the location.')
  virtualNetworkConfiguration: {
    @sys.description('Required. The full resource ID of a subnet in a virtual network to deploy the API Management service in.')
    subnetResourceId: string
  }?

  @sys.description('Optional. A list of availability zones denoting where the resource needs to come from.')
  availabilityZones: (1 | 2 | 3)[]?
}

@export()
@description('The type for a private endpoint output.')
type privateEndpointOutputType = {
  @description('The name of the private endpoint.')
  name: string

  @description('The resource ID of the private endpoint.')
  resourceId: string

  @description('The group Id for the private endpoint Group.')
  groupId: string?

  @description('The custom DNS configurations of the private endpoint.')
  customDnsConfigs: {
    @description('FQDN that resolves to private endpoint IP address.')
    fqdn: string?

    @description('A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]

  @description('The IDs of the network interfaces associated with the private endpoint.')
  networkInterfaceResourceIds: string[]
}
