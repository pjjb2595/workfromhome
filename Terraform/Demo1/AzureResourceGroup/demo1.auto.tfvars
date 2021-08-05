resourcename  = "AzureRMresourcegroup"
location      = "Southeast Asia"
storagename   = "azurermstorageaccount"
containername = "azurermstoragecontainer"
nsgname       = "AzureRMnetworksecuritygroup"
cosmosdbname  = "azurermcosmosdb"
tags          = { environment = "demo1", owner = "piajjbelardo", purpose = "TFAzureDemo" }
dnsname       = ["pia1.com", "pia2.com", "pia3.com"]
networkrule = [
  {
    name                       = "rule22"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "rule443"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "443"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]
environment       = "sandbox"
bootdiag          = "azurermbootdiag"
account_tier_type = "Standard_GRS"
vnname            = "AzureRMvirtualnetwork"
add_space         = ["10.0.0.0/16", "10.0.0.0/24"]
snname            = "AzureRMsubnet"
add_range         = ["10.0.1.0/24", "10.0.2.0/24"]
pipname           = "AzureRMpublicIP"
nicname           = "AzureRMnic"
ipconfig          = "AzureRMIPconfig"
vmname            = "AzureRMvirtualmachine"
tagsvm            = { resource = "virtualmachine", costcenter = "demo1" }
computername      = "AzureRMcomputer"
