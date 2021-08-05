variable "resourcename" {
  description = "This is a resource group."
}

variable "location" {
  description = "This is a location."
}

variable "storagename" {
  description = "This is a storage account."
}

variable "containername" {
  description = "This is a storage container."
}

variable "nsgname" {
  description = "This is a network security group."
}

variable "cosmosdbname" {
  description = "This is a cosmos db."
}

variable "networkrule" {
  description = "This is a network security group rule."
}

variable "tags" {
  type = map(any)
}

variable "dnsname" {
  type = list(any)
}

variable "environment" {
  description = "This is an environment."
}

variable "bootdiag" {
  description = "This is a storage account."
}

variable "account_tier_type" {
  description = "This is a bootdiag account."
}

variable "vnname" {
  description = "This is a virtual network."
}

variable "add_space" {
  description = "This is a set of address spaces."
}

variable "snname" {
  description = "This is a subnet."
}

variable "add_range" {
  description = "This is a set of address ranges."
}

variable "pipname" {
  description = "This is a public IP."
}

variable "nicname" {
  description = "This is a network interface."
}

variable "ipconfig" {
  description = "This is an IP configuration."
}

variable "vmname" {
  description = "This is a virtual machine."
}

variable "tagsvm" {
  type = map(any)
}

variable "computername" {
  description = "This is a computer."
}