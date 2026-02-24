module "cosmosdb" {
  source = "registry.terraform.io/telekom-mms/cosmosdb/azurerm"

  cosmosdb_account = {
    mms-github = {
      name                 = "cdb-mms-github"
      resource_group_name  = "rg-mms-github"
      location             = "westeurope"
      offer_type           = "Standard"
      kind                 = "MongoDB"
      mongo_server_version = "4.2"
      consistency_policy = {
        consistency_level = "Strong"
      }
      geo_location = {
        location          = "westeurope"
        failover_priority = 0
      }
      backup = {
        type = "Continuous"
      }
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
  }

  cosmosdb_mongo_database = {
    mms-github = {
      resource_group_name = module.cosmosdb.cosmosdb_account["mms-github"].resource_group_name
      account_name        = module.cosmosdb.cosmosdb_account["mms-github"].name
    }
  }
}
