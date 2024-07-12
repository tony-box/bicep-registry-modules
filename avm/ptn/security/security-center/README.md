# Azure Security Center (Defender for Cloud) `[Security/SecurityCenter]`

This module deploys an Azure Security Center (Defender for Cloud) Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Security/autoProvisioningSettings` | [2017-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2017-08-01-preview/autoProvisioningSettings) |
| `Microsoft.Security/deviceSecurityGroups` | [2019-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2019-08-01/deviceSecurityGroups) |
| `Microsoft.Security/iotSecuritySolutions` | [2019-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2019-08-01/iotSecuritySolutions) |
| `Microsoft.Security/pricings` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2023-01-01/pricings) |
| `Microsoft.Security/securityContacts` | [2023-12-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2023-12-01-preview/securityContacts) |
| `Microsoft.Security/workspaceSettings` | [2017-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2017-08-01-preview/workspaceSettings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/security/security-center:<version>`.

- [Using default parameter set](#example-1-using-default-parameter-set)
- [Using default parameter set](#example-2-using-default-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using default parameter set_

This instance deploys the module with default parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module securityCenter 'br/public:avm/ptn/security/security-center:<version>' = {
  name: 'securityCenterDeployment'
  params: {
    // Required parameters
    workspaceResourceId: '<workspaceResourceId>'
    workspaceScope: '<workspaceScope>'
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
    },
    "workspaceScope": {
      "value": "<workspaceScope>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 2: _Using default parameter set_

This instance deploys the module with default parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module securityCenter 'br/public:avm/ptn/security/security-center:<version>' = {
  name: 'securityCenterDeployment'
  params: {
    // Required parameters
    workspaceResourceId: '<workspaceResourceId>'
    workspaceScope: '<workspaceScope>'
    // Non-required parameters
    location: '<location>'
    pricings: [
      {
        enforce: 'False'
        extensions: []
        name: 'VirtualMachines'
        pricingTier: 'Standard'
        subPlan: 'P1'
      }
      {
        name: 'KeyVaults'
      }
    ]
    securityContactProperties: {
      emails: 'foo@contoso.com'
      isEnabled: false
      notificationsByRole: {
        roles: [
          'Contributor'
        ]
        state: 'Off'
      }
      notificationSources: [
        {
          minimalRiskLevel: 'Critical'
          sourceType: 'AttackPath'
        }
      ]
      phone: '+12345678'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
    },
    "workspaceScope": {
      "value": "<workspaceScope>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "pricings": {
      "value": [
        {
          "enforce": "False",
          "extensions": [],
          "name": "VirtualMachines",
          "pricingTier": "Standard",
          "subPlan": "P1"
        },
        {
          "name": "KeyVaults"
        }
      ]
    },
    "securityContactProperties": {
      "value": {
        "emails": "foo@contoso.com",
        "isEnabled": false,
        "notificationsByRole": {
          "roles": [
            "Contributor"
          ],
          "state": "Off"
        },
        "notificationSources": [
          {
            "minimalRiskLevel": "Critical",
            "sourceType": "AttackPath"
          }
        ],
        "phone": "+12345678"
      }
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module securityCenter 'br/public:avm/ptn/security/security-center:<version>' = {
  name: 'securityCenterDeployment'
  params: {
    // Required parameters
    workspaceResourceId: '<workspaceResourceId>'
    workspaceScope: '<workspaceScope>'
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
    },
    "workspaceScope": {
      "value": "<workspaceScope>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workspaceResourceId`](#parameter-workspaceresourceid) | string | The full resource Id of the Log Analytics workspace to save the data in. |
| [`workspaceScope`](#parameter-workspacescope) | string | All the VMs in this scope will send their security data to the mentioned workspace unless overridden by a setting with more specific scope. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoProvision`](#parameter-autoprovision) | string | Describes what kind of security agent provisioning action to take. - On or Off. |
| [`deviceSecurityGroupProperties`](#parameter-devicesecuritygroupproperties) | object | Device Security group data. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ioTSecuritySolutionProperties`](#parameter-iotsecuritysolutionproperties) | object | Security Solution data. |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`pricings`](#parameter-pricings) | array | Pricing data. |
| [`securityContactProperties`](#parameter-securitycontactproperties) | object | Security contact data. |

### Parameter: `workspaceResourceId`

The full resource Id of the Log Analytics workspace to save the data in.

- Required: Yes
- Type: string

### Parameter: `workspaceScope`

All the VMs in this scope will send their security data to the mentioned workspace unless overridden by a setting with more specific scope.

- Required: Yes
- Type: string

### Parameter: `autoProvision`

Describes what kind of security agent provisioning action to take. - On or Off.

- Required: No
- Type: string
- Default: `'On'`
- Allowed:
  ```Bicep
  [
    'Off'
    'On'
  ]
  ```

### Parameter: `deviceSecurityGroupProperties`

Device Security group data.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `ioTSecuritySolutionProperties`

Security Solution data.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `location`

Location deployment metadata.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `pricings`

Pricing data.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-pricingsname) | string | The pricing name. Use "az security pricing list" to find the latest list of pricing names. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enforce`](#parameter-pricingsenforce) | string | If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing. |
| [`extensions`](#parameter-pricingsextensions) | array | List of extensions offered under a plan. |
| [`pricingTier`](#parameter-pricingspricingtier) | string | List of extensions offered under a plan. |
| [`subPlan`](#parameter-pricingssubplan) | string | The sub-plan selected for a Standard pricing configuration, when more than one sub-plan is available. Each sub-plan enables a set of security features. When not specified, full plan is applied. For VirtualMachines plan, available sub plans are "P1" & "P2", where for resource level only "P1" sub plan is supported. |

### Parameter: `pricings.name`

The pricing name. Use "az security pricing list" to find the latest list of pricing names.

- Required: Yes
- Type: string

### Parameter: `pricings.enforce`

If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'False'
    'True'
  ]
  ```

### Parameter: `pricings.extensions`

List of extensions offered under a plan.

- Required: No
- Type: array

### Parameter: `pricings.pricingTier`

List of extensions offered under a plan.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `pricings.subPlan`

The sub-plan selected for a Standard pricing configuration, when more than one sub-plan is available. Each sub-plan enables a set of security features. When not specified, full plan is applied. For VirtualMachines plan, available sub plans are "P1" & "P2", where for resource level only "P1" sub plan is supported.

- Required: No
- Type: string

### Parameter: `securityContactProperties`

Security contact data.

- Required: No
- Type: object
- Default: `{}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the security center. |
| `workspaceResourceId` | string | The resource ID of the used log analytics workspace. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
