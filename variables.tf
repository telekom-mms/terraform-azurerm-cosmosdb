variable "cosmosdb_account" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "cosmosdb_mongo_collection" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "cosmosdb_mongo_database" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}

locals {
  default = {
    # resource definition
    cosmosdb_account = {
      name                                  = ""
      offer_type                            = "Standard"
      create_mode                           = null
      default_identity_type                 = "FirstPartyIdentity"
      kind                                  = "MongoDB"
      ip_range_filter                       = null
      analytical_storage_enabled            = false
      public_network_access_enabled         = true
      is_virtual_network_filter_enabled     = true
      key_vault_key_id                      = null
      access_key_metadata_writes_enabled    = true
      network_acl_bypass_for_azure_services = false
      network_acl_bypass_ids                = null
      local_authentication_disabled         = false
      consistency_policy = {
        consistency_level       = "Strong"
        max_interval_in_seconds = null
        max_staleness_prefix    = null
      }
      geo_location = {
        location          = ""
        failover_priority = 0
        zone_redundant    = false
      }
      capabilities = null
      virtual_network_rule = {
        id                                   = ""
        ignore_missing_vnet_service_endpoint = false
      }
      analytical_storage = {}
      capacity           = {}
      backup = {
        type                = "Continuous"
        tier                = "Continuous30Days"
        interval_in_minutes = null
        retention_in_hours  = null
        storage_redundancy  = null
      }
      cors_rule = {}
      identity  = {}
      restore = {
        source_cosmosdb_account_id = ""
        database                   = null
      }
      tags = {}
    }
    cosmosdb_mongo_collection = {
      name                   = ""
      analytical_storage_ttl = null
      default_ttl_seconds    = null
      throughput             = null
      index                  = {}
      autoscale_settings     = {}
    }
    cosmosdb_mongo_database = {
      throughput         = null
      autoscale_settings = {}
    }
  }

  # compare and merge custom and default values
  cosmosdb_account_values = {
    for cosmosdb_account in keys(var.cosmosdb_account) :
    cosmosdb_account => merge(local.default.cosmosdb_account, var.cosmosdb_account[cosmosdb_account])
  }
  cosmosdb_mongo_collection_values = {
    for cosmosdb_mongo_collection in keys(var.cosmosdb_mongo_collection) :
    cosmosdb_mongo_collection => merge(local.default.cosmosdb_mongo_collection, var.cosmosdb_mongo_collection[cosmosdb_mongo_collection])
  }
  cosmosdb_mongo_database_values = {
    for cosmosdb_mongo_database in keys(var.cosmosdb_mongo_database) :
    cosmosdb_mongo_database => merge(local.default.cosmosdb_mongo_database, var.cosmosdb_mongo_database[cosmosdb_mongo_database])
  }

  # merge all custom and default values
  cosmosdb_account = {
    for cosmosdb_account in keys(var.cosmosdb_account) :
    cosmosdb_account => merge(
      local.cosmosdb_account_values[cosmosdb_account],
      {
        for config in [
          "consistency_policy",
          "geo_location",
          "capabilities",
          "virtual_network_rule",
          "analytical_storage",
          "capacity",
          "backup",
          "cors_rule",
          "identity",
          "restore",
        ] :
        config => merge(local.default.cosmosdb_account[config], local.cosmosdb_account_values[cosmosdb_account][config])
      }
    )
  }
  cosmosdb_mongo_collection = {
    for cosmosdb_mongo_collection in keys(var.cosmosdb_mongo_collection) :
    cosmosdb_mongo_collection => merge(
      local.cosmosdb_mongo_collection_values[cosmosdb_mongo_collection],
      {
        for config in ["autoscale_settings", "index"] :
        config => merge(local.default.cosmosdb_mongo_collection[config], local.cosmosdb_mongo_collection_values[cosmosdb_mongo_collection][config])
      }
    )
  }

  cosmosdb_mongo_database = {
    for cosmosdb_mongo_database in keys(var.cosmosdb_mongo_database) :
    cosmosdb_mongo_database => merge(
      local.cosmosdb_mongo_database_values[cosmosdb_mongo_database],
      {
        for config in ["autoscale_settings"] :
        config => merge(local.default.cosmosdb_mongo_database[config], local.cosmosdb_mongo_database_values[cosmosdb_mongo_database][config])
      }
    )
  }
}
