metadata name = 'API Management Service Subscriptions'
metadata description = 'This module deploys an API Management Service Subscription.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Required. Name of the workspace.')
param displayName string

@description('Optional. Description of the workspace.')
param workspaceDescription string?

@description('Required. The resource name.')
@minLength(1)
@maxLength(80)
param name string

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName
}

resource workspace 'Microsoft.ApiManagement/service/workspaces@2024-05-01' = {
  name: name
  parent: service
  properties: {
    description: workspaceDescription
    displayName: displayName
  }
}

module workspace_test 'api/main.bicep' = if (!empty(backupShortTermRetentionPolicy)) {
  name: '${uniqueString(deployment().name, location)}-shBakRetPol'
  params: {
    serverName: serverName
    databaseName: database.name
    diffBackupIntervalInHours: backupShortTermRetentionPolicy.?diffBackupIntervalInHours
    retentionDays: backupShortTermRetentionPolicy.?retentionDays
  }
}

// =============== //
//   Definitions   //
// =============== //
