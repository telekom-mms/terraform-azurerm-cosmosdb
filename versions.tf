terraform {
  required_providers {
    azurerm = {
      source  = "registry.terraform.io/hashicorp/azurerm"
      version = ">=4.72.0, <5.0"
    }
  }
  required_version = ">= 1.5"
}
