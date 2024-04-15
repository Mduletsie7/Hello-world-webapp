# Configure the Azure provider

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  cloud {
    organization = "Mdumisi-dev"
    workspaces {
      name = "sprint-4-demo"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# Provision a resource group
# Use input values from variables.tf file
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Terraform Sprint 4 Demo"
    Team = "DevOps"
  }
}

# Provision a app service plan
resource "azurerm_service_plan" "servicePlan" {
  name                = "webapp-sp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

# Provision a web app
resource "azurerm_linux_web_app" "rg" {
  name                = "hello-demo-webapp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.servicePlan.location
  service_plan_id     = azurerm_service_plan.servicePlan.id

  site_config {}
}