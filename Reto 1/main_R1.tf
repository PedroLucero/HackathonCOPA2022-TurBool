# Configure the Microsoft Azure Provider.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.25"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "COPA_reto1" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_service_plan" "COPA_service_plan" {
  name                = var.sp_name
  resource_group_name = azurerm_resource_group.COPA_reto1.name
  location            = var.location
  os_type             = var.sp_os
  sku_name            = "S2"
}

resource "azurerm_windows_web_app" "COPA_linux_web_app" {
  name                = var.lwapp_name
  resource_group_name = azurerm_resource_group.COPA_reto1.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.COPA_service_plan.id

  site_config {}
}

resource "azurerm_application_insights" "COPA_app_insights" {
  name                = var.appi_name
  location            = var.location
  resource_group_name = azurerm_resource_group.COPA_reto1.name
  application_type    = "web"
}

output "instrumentation_key" {
  value     = azurerm_application_insights.COPA_app_insights.instrumentation_key
  sensitive = true
}

output "app_id" {
  value = azurerm_application_insights.COPA_app_insights.app_id
}

resource "azurerm_log_analytics_workspace" "COPA_logA_workspace" {
  name                = var.LAW_name
  location            = var.location
  resource_group_name = azurerm_resource_group.COPA_reto1.name
  sku                 = "PerGB2018"
  #Check this retention thing
  retention_in_days = 30
}
