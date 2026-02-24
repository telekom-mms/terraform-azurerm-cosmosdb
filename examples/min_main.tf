module "cosmosdb" {
  source = "registry.terraform.io/telekom-mms/cosmosdb/azurerm"

  cosmosdb_account = {
    cdb-mms-github = {
      resource_group_name = "rg-mms-github"
      location            = "westeurope"
      offer_type          = "Standard"
      kind                = "MongoDB"
      consistency_policy = {
        consistency_level = "Strong"
      }
      geo_location = {
        location          = "westeurope"
        failover_priority = 0
      }
    }
  }
}
