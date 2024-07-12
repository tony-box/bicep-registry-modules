@description('Required. The pricing name. Use "az security pricing list" to find the latest list of pricing names.')
param name string

targetScope = 'subscription'

@description('Optional. List of extensions offered under a plan.')
@allowed([
  'Standard'
  'Free'
])
param pricingTier string = 'Free'

// @description('Optional. If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.')
// @allowed([
//   'True'
//   'False'
// ])
// param enforce string?

@description('Optional. List of extensions offered under a plan.')
param extensions array?

@description('Optional. The sub-plan selected for a Standard pricing configuration, when more than one sub-plan is available. Each sub-plan enables a set of security features. When not specified, full plan is applied. For VirtualMachines plan, available sub plans are "P1" & "P2", where for resource level only "P1" sub plan is supported.')
param subPlan string?

resource pricing_values 'Microsoft.Security/pricings@2023-01-01' = {
  name: name
  properties: {
    // enforce: enforce
    extensions: extensions
    pricingTier: pricingTier
    subPlan: subPlan
  }
}

@description('The name of the deployed Pricing.')
output name string = pricing_values.name

@description('The resource ID of the deployed Pricing.')
output resourceId string = pricing_values.id
