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

  cosmosdb_mongo_database = {
    mms-github = {
      resource_group_name = module.cosmosdb.cosmosdb_account["cdb-mms-github"].resource_group_name
      account_name        = module.cosmosdb.cosmosdb_account["cdb-mms-github"].name
    }
  }
}
