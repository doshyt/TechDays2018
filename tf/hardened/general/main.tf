provider "azurerm" {
    subscription_id = "xxx-yyy-zzz-aaa-bbb-ccc"
}
data "azurerm_subscription" "current" {}
resource "azurerm_policy_assignment" "securemonitoring" {
  name                 = "Secure-Monitoring"
  scope                = "${data.azurerm_subscription.current.id}"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/760a85ff-6162-42b3-8d70-698e268f648c"
  description          = "Policy Assignment for [Preview]: Monitor VM Vulnerabilities in Azure Security Center"
  display_name         = "Monitor VM Vulnerabilities in Azure Security Center"
}


resource "azurerm_resource_group" "keyvaultrg" {
        name = "keyvault2rg"
        location = "westeurope"
}
resource "azurerm_key_vault" "demovault" {
  name                        = "TechDaysVault2"
  location                    = "westeurope"
  resource_group_name         = "${azurerm_resource_group.keyvaultrg.name}"
  enabled_for_disk_encryption = true
  tenant_id                   = "xxx-yyy-zzz-aaa-bbb-ccc-sss-uuuu"

  sku {
    name = "standard"
  }


  access_policy {
    tenant_id = "aaaa-xxx-yyy-zzz-aaa-bbb-ccc-sss-uuu"
    object_id = "bbb-xxx-yyy-zzz-aaa-bbb-ccc-sss-uuu"

   key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]
    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set",
    ]
    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "setissuers",
      "update",
    ]
  }
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
}