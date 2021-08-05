terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "c6383a95-068e-467d-b807-c81f1cefa827"
  tenant_id       = "e0793d39-0939-496d-b129-198edd916feb"
}

# Create a resource group
resource "azurerm_resource_group" "resourcegroup" {
  name     = var.resourcename
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "storageaccount" {
  name                     = var.storagename
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = azurerm_resource_group.resourcegroup.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags                     = var.tags
}

resource "azurerm_storage_container" "storagecontainer" {
  count                 = 2
  name                  = "${var.containername}${count.index}"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}

resource "azurerm_dns_zone" "dnszone" {
  count               = length(var.dnsname)
  name                = var.dnsname[count.index]
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

resource "azurerm_network_security_group" "securitygroup" {
  name                = var.nsgname
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  tags                = var.tags

  dynamic "security_rule" {
    iterator = rule
    for_each = var.networkrule
    content {
      name                       = rule.value.name
      priority                   = rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = rule.value.source_port_range
      destination_port_range     = rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_cosmosdb_account" "db" {
  count               = var.environment == "prod" ? 2 : 1
  name                = "${var.cosmosdbname}${count.index}"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  tags                = var.tags

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    location          = azurerm_resource_group.resourcegroup.location
    failover_priority = 0
  }
}

resource "azurerm_storage_account" "bootdiagnostics" {
  name                     = var.bootdiag
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = azurerm_resource_group.resourcegroup.location
  account_tier             = element(split("_", var.account_tier_type), 0)
  account_replication_type = element(split("_", var.account_tier_type), 1)
  tags                     = var.tags
}

resource "azurerm_virtual_network" "virtualnetwork" {
  name                = var.vnname
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  address_space       = [element(var.add_space, 0)]
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  count                = 2
  name                 = "${var.snname}${count.index}"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.virtualnetwork.name
  address_prefixes     = [element(var.add_range, count.index)]

}

resource "azurerm_public_ip" "publicip" {
  count               = 2
  name                = "${var.pipname}${count.index}"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  allocation_method   = "Static"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "${var.nicname}${count.index}"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = var.ipconfig
    subnet_id                     = element(azurerm_subnet.subnet.*.id, count.index)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.publicip.*.id, count.index)
  }
}

resource "random_password" "password" {
  length  = 8
  special = true
}

resource "azurerm_virtual_machine" "virtualmachine" {
  count                 = 2
  name                  = "${var.vmname}${count.index}"
  location              = azurerm_resource_group.resourcegroup.location
  resource_group_name   = azurerm_resource_group.resourcegroup.name
  network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]
  vm_size               = "Standard_DS1_v2"
  tags                  = merge(var.tags, var.tagsvm)

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.computername}${count.index}"
    admin_username = "testadmin"
    admin_password = random_password.password.result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

}
