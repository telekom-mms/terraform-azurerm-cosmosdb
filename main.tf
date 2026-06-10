/**
 * # cosmosdb
 *
 * This module manages the azurerm cosmosdb resources, see https://registry.terraform.io/providers/azurerm/latest/docs.
 *
 * For more information about the module structure see https://telekom-mms.github.io/terraform-template.
 *
 */

resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  for_each = var.cosmosdb_account

  name                                  = local.cosmosdb_account[each.key].name == "" ? each.key : local.cosmosdb_account[each.key].name
  resource_group_name                   = local.cosmosdb_account[each.key].resource_group_name
  location                              = local.cosmosdb_account[each.key].location
  offer_type                            = local.cosmosdb_account[each.key].offer_type
  create_mode                           = local.cosmosdb_account[each.key].create_mode
  default_identity_type                 = local.cosmosdb_account[each.key].default_identity_type
  kind                                  = local.cosmosdb_account[each.key].kind
  ip_range_filter                       = local.cosmosdb_account[each.key].ip_range_filter
  free_tier_enabled                     = local.cosmosdb_account[each.key].free_tier_enabled
  analytical_storage_enabled            = local.cosmosdb_account[each.key].analytical_storage_enabled
  automatic_failover_enabled            = local.cosmosdb_account[each.key].automatic_failover_enabled
  public_network_access_enabled         = local.cosmosdb_account[each.key].public_network_access_enabled
  is_virtual_network_filter_enabled     = local.cosmosdb_account[each.key].is_virtual_network_filter_enabled
  key_vault_key_id                      = local.cosmosdb_account[each.key].key_vault_key_id
  multiple_write_locations_enabled      = local.cosmosdb_account[each.key].multiple_write_locations_enabled
  access_key_metadata_writes_enabled    = local.cosmosdb_account[each.key].access_key_metadata_writes_enabled
  mongo_server_version                  = local.cosmosdb_account[each.key].mongo_server_version
  minimal_tls_version                   = local.cosmosdb_account[each.key].minimal_tls_version
  partition_merge_enabled               = local.cosmosdb_account[each.key].partition_merge_enabled
  burst_capacity_enabled                = local.cosmosdb_account[each.key].burst_capacity_enabled
  network_acl_bypass_for_azure_services = local.cosmosdb_account[each.key].network_acl_bypass_for_azure_services
  network_acl_bypass_ids                = local.cosmosdb_account[each.key].network_acl_bypass_ids
  local_authentication_disabled         = local.cosmosdb_account[each.key].local_authentication_disabled

  consistency_policy {
    consistency_level       = local.cosmosdb_account[each.key].consistency_policy.consistency_level
    max_interval_in_seconds = local.cosmosdb_account[each.key].consistency_policy.max_interval_in_seconds
    max_staleness_prefix    = local.cosmosdb_account[each.key].consistency_policy.max_staleness_prefix
  }

  dynamic "geo_location" {
    for_each = local.cosmosdb_account[each.key].geo_location
    content {
      location          = coalesce(geo_location.value.location, local.cosmosdb_account[each.key].location)
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = geo_location.value.zone_redundant
    }
  }

  dynamic "capabilities" {
    for_each = try(length([for v in values(local.cosmosdb_account[each.key].capabilities) : v if v != null]) > 0, false) ? local.cosmosdb_account[each.key].capabilities : {}
    content {
      name = local.cosmosdb_account[each.key].capabilities[capabilities.key].name
    }
  }

  dynamic "virtual_network_rule" {
    for_each = try(local.cosmosdb_account[each.key].virtual_network_rule.id != null && local.cosmosdb_account[each.key].virtual_network_rule.id != "", false) ? [1] : []
    content {
      id                                   = local.cosmosdb_account[each.key].virtual_network_rule.id
      ignore_missing_vnet_service_endpoint = local.cosmosdb_account[each.key].virtual_network_rule.ignore_missing_vnet_service_endpoint
    }
  }

  dynamic "analytical_storage" {
    for_each = try(length([for v in values(local.cosmosdb_account[each.key].analytical_storage) : v if v != null]) > 0, false) ? [1] : []
    content {
      schema_type = local.cosmosdb_account[each.key].analytical_storage.schema_type
    }
  }

  dynamic "capacity" {
    for_each = try(length([for v in values(local.cosmosdb_account[each.key].capacity) : v if v != null]) > 0, false) ? [1] : []
    content {
      total_throughput_limit = local.cosmosdb_account[each.key].capacity.total_throughput_limit
    }
  }

  dynamic "backup" {
    for_each = try(local.cosmosdb_account[each.key].backup.type != null && local.cosmosdb_account[each.key].backup.type != "", false) ? [1] : []
    content {
      type                = local.cosmosdb_account[each.key].backup.type
      tier                = local.cosmosdb_account[each.key].backup.tier
      interval_in_minutes = local.cosmosdb_account[each.key].backup.interval_in_minutes
      retention_in_hours  = local.cosmosdb_account[each.key].backup.retention_in_hours
      storage_redundancy  = local.cosmosdb_account[each.key].backup.storage_redundancy
    }
  }

  dynamic "cors_rule" {
    for_each = try(length([for v in values(local.cosmosdb_account[each.key].cors_rule) : v if v != null]) > 0, false) ? [1] : []

    content {
      allowed_headers    = local.cosmosdb_account[each.key].cors_rule.allowed_headers
      allowed_methods    = local.cosmosdb_account[each.key].cors_rule.allowed_methods
      allowed_origins    = local.cosmosdb_account[each.key].cors_rule.allowed_origins
      exposed_headers    = local.cosmosdb_account[each.key].cors_rule.exposed_headers
      max_age_in_seconds = local.cosmosdb_account[each.key].cors_rule.max_age_in_seconds
    }
  }

  dynamic "identity" {
    for_each = try(length([for v in values(local.cosmosdb_account[each.key].identity) : v if v != null]) > 0, false) ? [1] : []

    content {
      type         = local.cosmosdb_account[each.key].identity.type
      identity_ids = local.cosmosdb_account[each.key].identity.identity_ids
    }
  }

  dynamic "restore" {
    for_each = try(local.cosmosdb_account[each.key].restore.source_cosmosdb_account_id != null && local.cosmosdb_account[each.key].restore.source_cosmosdb_account_id != "", false) ? [1] : []
    content {
      source_cosmosdb_account_id = local.cosmosdb_account[each.key].restore.source_cosmosdb_account_id
      restore_timestamp_in_utc   = local.cosmosdb_account[each.key].restore.restore_timestamp_in_utc

      dynamic "database" {
        for_each = try(local.cosmosdb_account[each.key].restore.database != null, false) ? [1] : []

        content {
          name             = local.cosmosdb_account[each.key].restore.database.name
          collection_names = local.cosmosdb_account[each.key].restore.database.collection_names
        }
      }

      dynamic "gremlin_database" {
        for_each = try(length([for v in values(local.cosmosdb_account[each.key].restore.gremlin_database) : v if v != null]) > 0, false) ? local.cosmosdb_account[each.key].restore.gremlin_database : []

        content {
          name        = gremlin_database.value.name
          graph_names = gremlin_database.value.graph_names
        }
      }

      tables_to_restore = local.cosmosdb_account[each.key].restore.tables_to_restore
    }
  }

  tags = local.cosmosdb_account[each.key].tags
}

resource "azurerm_cosmosdb_mongo_collection" "cosmosdb_mongo_collection" {
  for_each = var.cosmosdb_mongo_collection

  name                   = local.cosmosdb_mongo_collection[each.key].name == "" ? each.key : local.cosmosdb_mongo_collection[each.key].name
  resource_group_name    = local.cosmosdb_mongo_collection[each.key].resource_group_name
  account_name           = local.cosmosdb_mongo_collection[each.key].account_name
  database_name          = local.cosmosdb_mongo_collection[each.key].database_name
  shard_key              = local.cosmosdb_mongo_collection[each.key].shard_key
  analytical_storage_ttl = local.cosmosdb_mongo_collection[each.key].analytical_storage_ttl
  default_ttl_seconds    = local.cosmosdb_mongo_collection[each.key].default_ttl_seconds
  throughput             = local.cosmosdb_mongo_collection[each.key].throughput

  dynamic "index" {
    for_each = try(length([for v in values(local.cosmosdb_mongo_collection[each.key].index) : v if v != null]) > 0, false) ? local.cosmosdb_mongo_collection[each.key].index : {}
    content {
      keys   = index.value.keys
      unique = index.value.unique
    }
  }

  dynamic "autoscale_settings" {
    for_each = try(length([for v in values(local.cosmosdb_mongo_collection[each.key].autoscale_settings) : v if v != null]) > 0, false) ? [1] : []
    content {
      max_throughput = local.cosmosdb_mongo_collection[each.key].autoscale_settings.max_throughput
    }
  }
}

resource "azurerm_cosmosdb_mongo_database" "cosmosdb_mongo_database" {
  for_each = var.cosmosdb_mongo_database

  name                = local.cosmosdb_mongo_database[each.key].name == "" ? each.key : local.cosmosdb_mongo_database[each.key].name
  resource_group_name = local.cosmosdb_mongo_database[each.key].resource_group_name
  account_name        = local.cosmosdb_mongo_database[each.key].account_name
  throughput          = local.cosmosdb_mongo_database[each.key].throughput

  dynamic "autoscale_settings" {
    for_each = try(length([for v in values(local.cosmosdb_mongo_database[each.key].autoscale_settings) : v if v != null]) > 0, false) ? [1] : []
    content {
      max_throughput = local.cosmosdb_mongo_database[each.key].autoscale_settings.max_throughput
    }
  }
}
