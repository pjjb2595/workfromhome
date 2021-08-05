terraform {
  backend "azurerm" {
    resource_group_name  = "AzureRMresourcegroup"
    storage_account_name = "azurermstorageaccount"
    container_name       = "azurermstoragecontainer1"
    key                  = "demo1.terraform.tfstate"
    subscription_id      = "c6383a95-068e-467d-b807-c81f1cefa827"
    tenant_id            = "e0793d39-0939-496d-b129-198edd916feb"
  }
}
