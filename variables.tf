variable "cosmosdb_account" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}

variable "cosmosdb_mongo_collection" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}

variable "cosmosdb_mongo_database" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}

locals {
  default = {
    // resource definition
    cosmosdb_account = {
      name                                  = ""
      offer_type                            = "Standard"
      create_mode                           = null
      default_identity_type                 = null
      kind                                  = "MongoDB" // defined default
      ip_range_filter                       = null
      free_tier_enabled                     = null
      analytical_storage_enabled            = null
      automatic_failover_enabled            = true // defined default
      public_network_access_enabled         = null
      is_virtual_network_filter_enabled     = true // defined default
      key_vault_key_id                      = null
      multiple_write_locations_enabled      = false
      access_key_metadata_writes_enabled    = null
      network_acl_bypass_for_azure_services = false
      network_acl_bypass_ids                = null
      local_authentication_disabled         = null
      mongo_server_version                  = null
      minimal_tls_version                   = null
      partition_merge_enabled               = null
      burst_capacity_enabled                = null
      consistency_policy = {
        consistency_level       = "Strong"
        max_interval_in_seconds = null
        max_staleness_prefix    = null
      }
      geo_location = {
        location          = ""
        failover_priority = 0
        zone_redundant    = null
      }
      capabilities = null
      virtual_network_rule = {
        id                                   = ""
        ignore_missing_vnet_service_endpoint = false
      }
      analytical_storage = {}
      capacity           = {}
      backup = {
        type                = ""
        tier                = null
        interval_in_minutes = null
        retention_in_hours  = null
        storage_redundancy  = null
      }
      cors_rule = {}
      identity = {
        type         = null
        identity_ids = null
      }
      restore = {
        source_cosmosdb_account_id = ""
        restore_timestamp_in_utc   = null
        database                   = null
        gremlin_database           = null
        tables_to_restore          = null
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

  // compare and merge custom and default values
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

  // deep merge of all custom and default values
  cosmosdb_account = {
    for cosmosdb_account in keys(var.cosmosdb_account) :
    cosmosdb_account => merge(
      local.cosmosdb_account_values[cosmosdb_account],
      {
        for config in [
          "consistency_policy",
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
      },
      {
        geo_location = try(local.cosmosdb_account_values[cosmosdb_account].geo_location.location, null) != null ? {
          default = merge(
            local.default.cosmosdb_account.geo_location,
            local.cosmosdb_account_values[cosmosdb_account].geo_location
          )
          } : {
          for key, value in local.cosmosdb_account_values[cosmosdb_account].geo_location :
          key => merge(
            local.default.cosmosdb_account.geo_location,
            value
          )
        }
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
