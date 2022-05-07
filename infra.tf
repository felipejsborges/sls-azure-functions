# Provider setup
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.3.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.2.1"
    }
  }
}
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
provider "azuredevops" {}

# Define vars
variable "resource_group" {
  default = "festival-ms-rg"
}
variable "location" {
  default = "eastus"
}
variable "sb_namespace" {
  default = "festival-ms-sb-ns"
}
variable "sb_queue" {
  default = "festival-ms-sb-queue"
}
variable "eventhubs_namespace" {
  default = "festival-ms-eventhubs-ns"
}
variable "eventhub_name" {
  default = "festival-ms-eventhub"
}

# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

# Create Service Bus namespace and queue
resource "azurerm_servicebus_namespace" "sb" {
  name                = var.sb_namespace
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
}
output "service_bus_connection_string" {
  value     = azurerm_servicebus_namespace.sb.default_primary_connection_string
  sensitive = true
}

resource "azurerm_servicebus_queue" "queue" {
  name         = var.sb_queue
  namespace_id = azurerm_servicebus_namespace.sb.id
}
output "service_bus_queue_name" {
  value = azurerm_servicebus_queue.queue.name
}

# Create Event Hubs namespace and event hub
resource "azurerm_eventhub_namespace" "eh" {
  name                = var.eventhubs_namespace
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
}
output "event_hubs_connection_string" {
  value     = azurerm_eventhub_namespace.eh.default_primary_connection_string
  sensitive = true
}

resource "azurerm_eventhub" "eh" {
  name                = var.eventhub_name
  namespace_name      = azurerm_eventhub_namespace.eh.name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = 1
  message_retention   = 1
}
output "event_hub_name" {
  value = azurerm_eventhub.eh.name
}
