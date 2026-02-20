output "cosmosdb_account" {
  description = "Outputs all attributes of azurerm_cosmosdb_account."
  value = {
    for cosmosdb_account in keys(azurerm_cosmosdb_account.cosmosdb_account) :
    cosmosdb_account => {
      for key, value in azurerm_cosmosdb_account.cosmosdb_account[cosmosdb_account] :
      key => value
    }
  }
}

output "cosmosdb_mongo_collection" {
  description = "Outputs all attributes of azurerm_cosmosdb_mongo_collection."
  value = {
    for cosmosdb_mongo_collection in keys(azurerm_cosmosdb_mongo_collection.cosmosdb_mongo_collection) :
    cosmosdb_mongo_collection => {
      for key, value in azurerm_cosmosdb_mongo_collection.cosmosdb_mongo_collection[cosmosdb_mongo_collection] :
      key => value
    }
  }
}

output "cosmosdb_mongo_database" {
  description = "Outputs all attributes of azurerm_cosmosdb_mongo_database."
  value = {
    for cosmosdb_mongo_database in keys(azurerm_cosmosdb_mongo_database.cosmosdb_mongo_database) :
    cosmosdb_mongo_database => {
      for key, value in azurerm_cosmosdb_mongo_database.cosmosdb_mongo_database[cosmosdb_mongo_database] :
      key => value
    }
  }
}

output "variables" {
  description = "Displays all configurable variables passed by the module. __default__ = predefined values per module. __merged__ = result of merging the default values and custom values passed to the module"
  value = {
    default = {
      for variable in keys(local.default) :
      variable => local.default[variable]
    }
    merged = {
      cosmosdb_account = {
        for key in keys(var.cosmosdb_account) :
        key => local.cosmosdb_account[key]
      }
      cosmosdb_mongo_collection = {
        for key in keys(var.cosmosdb_mongo_collection) :
        key => local.cosmosdb_mongo_collection[key]
      }
      cosmosdb_mongo_database = {
        for key in keys(var.cosmosdb_mongo_database) :
        key => local.cosmosdb_mongo_database[key]
      }
    }
  }
}
