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
  @sys.description('Conditional. Required for "signin": Redirect Anonymous users to the Sign-In page. Required for "signup": Allow users to sign up on a developer portal.')
  enabled: bool

  @sys.description('Conditional. Required for "signup".')
  termsOfService: {
    @sys.description('Required. Ask user for consent to the terms of service.')
    consentRequired: bool
    @sys.description('Required. Display terms of service during a sign-up process.')
    enabled: bool
    @sys.description('Required. A terms of service text.')
    text: 'string'
  }

  @sys.description('Conditional. Required for "delegation". Subscriptions delegation settings.')
  subscriptions: {
    @sys.description('Required. Enable or disable delegation for subscriptions.')
    enabled: bool
  }

  @sys.description('Conditional. Required for "delegation". A delegation Url.')
  url: string
  userRegistration: {
    @sys.description('Required. Enable or disable delegation for user registration.')
    enabled: bool
  }

  @secure()
  @description('Conditional. Required for "delegation". A base64-encoded validation key to validate, that a request is coming from Azure API Management.')
  validationKey: string
}
