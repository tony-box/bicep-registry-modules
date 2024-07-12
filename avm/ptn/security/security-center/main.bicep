metadata name = 'Azure Security Center (Defender for Cloud)'
metadata description = 'This module deploys an Azure Security Center (Defender for Cloud) Configuration.'
metadata owner = 'Azure/module-maintainers'

targetScope = 'subscription'

@description('Required. The full resource Id of the Log Analytics workspace to save the data in.')
param workspaceResourceId string

@description('Required. All the VMs in this scope will send their security data to the mentioned workspace unless overridden by a setting with more specific scope.')
param workspaceScope string

@description('Optional. Describes what kind of security agent provisioning action to take. - On or Off.')
@allowed([
  'On'
  'Off'
])
param autoProvision string = 'On'

@description('Optional. Device Security group data.')
param deviceSecurityGroupProperties object = {}

@description('Optional. Security Solution data.')
param ioTSecuritySolutionProperties object = {}

@description('Optional. Pricing data.')
param pricings pricingsType

@description('Optional. Security contact data.')
param securityContactProperties object = {}

@description('Optional. Location deployment metadata.')
param location string = deployment().location

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.ptn.security-securitycenter.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
  location: location
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

@batchSize(1)
module pricing 'modules/pricings.bicep' = [
  for (pricing, index) in (pricings ?? []): {
    name: '${uniqueString(deployment().name)}-${pricing.name}-${index}'
    params: {
      name: pricing.name
      // enforce: pricing.?enforce
      extensions: pricing.?extensions
      pricingTier: pricing.?pricingTier
      subPlan: pricing.?subPlan
    }
  }
]

resource autoProvisioningSettings 'Microsoft.Security/autoProvisioningSettings@2017-08-01-preview' = {
  name: 'default'
  properties: {
    autoProvision: autoProvision
  }
}

resource deviceSecurityGroups 'Microsoft.Security/deviceSecurityGroups@2019-08-01' = if (!empty(deviceSecurityGroupProperties)) {
  name: 'deviceSecurityGroups'
  properties: {
    thresholdRules: deviceSecurityGroupProperties.thresholdRules
    timeWindowRules: deviceSecurityGroupProperties.timeWindowRules
    allowlistRules: deviceSecurityGroupProperties.allowlistRules
    denylistRules: deviceSecurityGroupProperties.denylistRules
  }
}

module iotSecuritySolutions 'modules/iotSecuritySolutions.bicep' = if (!empty(ioTSecuritySolutionProperties)) {
  name: '${uniqueString(deployment().name)}-ASC-IotSecuritySolutions'
  scope: resourceGroup(empty(ioTSecuritySolutionProperties) ? 'dummy' : ioTSecuritySolutionProperties.resourceGroup)
  params: {
    ioTSecuritySolutionProperties: ioTSecuritySolutionProperties
  }
}

resource securityContacts 'Microsoft.Security/securityContacts@2023-12-01-preview' = if (!empty(securityContactProperties)) {
  name: 'default'
  properties: {
    emails: securityContactProperties.emails
    isEnabled: securityContactProperties.isEnabled
    notificationsByRole: securityContactProperties.notificationsByRole
    notificationsSources: securityContactProperties.notificationSources
    phone: securityContactProperties.phone
  }
}

resource workspaceSettings 'Microsoft.Security/workspaceSettings@2017-08-01-preview' = {
  name: 'default'
  properties: {
    workspaceId: workspaceResourceId
    scope: workspaceScope
  }
  dependsOn: [
    autoProvisioningSettings
  ]
}

@description('The resource ID of the used log analytics workspace.')
output workspaceResourceId string = workspaceResourceId

@description('The name of the security center.')
output name string = 'Security'

// =============== //
//   Definitions   //
// =============== //

type pricingsType = {
  @description('Required. The pricing name. Use "az security pricing list" to find the latest list of pricing names.')
  name: string

  @description('Optional. List of extensions offered under a plan.')
  pricingTier: ('Standard' | 'Free')?

  @description('Optional. If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.')
  enforce: ('True' | 'False')?

  @description('Optional. List of extensions offered under a plan.')
  extensions: array?

  @description('Optional. The sub-plan selected for a Standard pricing configuration, when more than one sub-plan is available. Each sub-plan enables a set of security features. When not specified, full plan is applied. For VirtualMachines plan, available sub plans are "P1" & "P2", where for resource level only "P1" sub plan is supported.')
  subPlan: string?
}[]?
