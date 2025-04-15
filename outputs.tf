# output the private ips of the vms
output "private_ip_addresses" {
  value = {
    for region, nic in azurerm_network_interface.nic : region => nic.ip_configuration[0].private_ip_address
  }
}

# output the public ips of the vms
# output "public_ip_addresses" {
#   value = {
#     for region, pub_ip in azurerm_public_ip.vm_public_ip : region => pub_ip.ip_address
#   }
# }

output "public_ip_addresses" {
  value = {
    for region, vm in azurerm_linux_virtual_machine.vm : region => vm.public_ip_address
  }
}


# output "public_ip_addresses" {
#   value = {
#     for region, nic in azurerm_network_interface.nic : region => nic.ip_configuration[0].public_ip_address
#   }
# }

