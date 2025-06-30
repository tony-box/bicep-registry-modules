metadata name = 'API Management Service Portal Settings'
metadata description = 'This module deploys an API Management Service Portal Setting.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Required. Portal setting name.')
@allowed([
  'delegation'
  'signin'
  'signup'
])
param name string

@description('Required. Portal setting properties.')
param properties PortalSettingProperties

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName
}

resource portalSetting 'Microsoft.ApiManagement/service/portalsettings@2024-05-01' = {
  name: any(name)
  parent: service
  properties: properties
}

@description('The resource ID of the API management service portal setting.')
output resourceId string = portalSetting.id

@description('The name of the API management service portal setting.')
output name string = portalSetting.name

@description('The resource group the API management service portal setting was deployed into.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //

@description('Portal setting properties for delegation, signin, or signup. See documentation for which properties are required for each setting.')
type PortalSettingProperties = {
  // For 'signin' and 'signup'
  enabled: bool

  // For 'signup'
  termsOfService: object

  // For 'delegation'
  subscriptions: object
  url: string
  userRegistration: object
  validationKey: string
}
