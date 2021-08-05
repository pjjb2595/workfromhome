output "rgname" {
  value = azurerm_resource_group.resourcegroup.name
}

output "storage" {
  value = azurerm_storage_account.storageaccount.name
}

output "container" {
  value = azurerm_storage_container.storagecontainer[*].name
}

output "dzname" {
  value = [for i in var.dnsname : upper(i)]
}

output "random_password" {
  value     = random_password.password.result
  sensitive = true
}

output "public_ip" {
  value = azurerm_public_ip.publicip.*.ip_address
}

output "virtual_machine" {
  value = azurerm_virtual_machine.virtualmachine.*.name
}
