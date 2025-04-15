resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

locals {
  regions = {
    "us-east" = "East US",
    "australia-central" = "Australia Central"
    "australia-east" = "Australia East",
    "australia-southeast" = "Australia Southeast",
    "brazil-south"  = "Brazil South",
    "canada-central" = "Canada Central",
    # "canada-east" = "Canada East",
    "india-central" = "Central India",
    "us-central" = "Central US",
    "asia-east" = "East Asia",
    "asia-southeast" = "Southeast Asia",
    "us-east2" = "East US 2",
    "france-central" = "France Central", 
    "germany-westcentral" = "Germany West Central", 
    "indonesia-central" = "Indonesia Central",
    "israel-central" = "Israel Central",
    "italy-north" = "Italy North",
    "japan-east" = "Japan East",
    "japan-west" = "Japan West",
    "korea-central" = "Korea Central",
    # "korea-south" = "Korea South",
    "mexico-central" = "Mexico Central",
    "newzealand-north" = "New Zealand North",
    "norway-east" = "Norway East",
    "us-northcentral" = "North Central US",
    "europe-north" = "North Europe",
    "poland-central" = "Poland Central",
    # "qatar-central" = "Qatar Central",
    "southafrica-north" = "South Africa North",
    "us-southcentral" = "South Central US",
    "india-south" = "South India",
    "spain-central" = "Spain Central",
    "sweden-central" = "Sweden Central",
    "switzerland-north" = "Switzerland North",
    "uae-north" = "UAE North",
    "uk-south" = "UK South",
    "uk-west" = "UK West",
    "us-westcentral" = "West Central US",
    "europe-west" = "West Europe",
    # "india-west" = "West India",
    "us-west" = "West US",
    "us-west2" = "West US 2",
    "us-west3" = "West US 3"
  }

  vpn_address_spaces = {
    "us-east" = "10.10.0.0/16",
    "australia-central" = "10.0.0.0/16",
    "australia-east" = "10.1.0.0/16",
    "australia-southeast" = "10.2.0.0/16",
    "brazil-south" = "10.3.0.0/16",
    "canada-central" = "10.4.0.0/16",
    # "canada-east" = "10.5.0.0/16",
    "india-central" = "10.6.0.0/16",
    "us-central" = "10.7.0.0/16",
    "asia-east" = "10.8.0.0/16",
    "asia-southeast" = "10.9.0.0/16",
    "us-east2" = "10.11.0.0/16",
    "france-central" = "10.12.0.0/16",
    "germany-westcentral" = "10.13.0.0/16",
    "indonesia-central" = "10.14.0.0/16",
    "israel-central" = "10.15.0.0/16",
    "italy-north" = "10.16.0.0/16",
    "japan-east" = "10.17.0.0/16",
    "japan-west" = "10.18.0.0/16",
    "korea-central" = "10.19.0.0/16",
    # "korea-south" = "10.20.0.0/16",
    "mexico-central" = "10.21.0.0/16",
    "newzealand-north" = "10.22.0.0/16",
    "norway-east" = "10.23.0.0/16",
    "us-northcentral" = "10.24.0.0/16",
    "europe-north" = "10.25.0.0/16",
    "poland-central" = "10.26.0.0/16",
    # "qatar-central" = "10.27.0.0/16",
    "southafrica-north" = "10.28.0.0/16",
    "us-southcentral" = "10.29.0.0/16",
    "india-south" = "10.30.0.0/16",
    "spain-central" = "10.31.0.0/16",
    "sweden-central" = "10.32.0.0/16",
    "switzerland-north" = "10.33.0.0/16",
    "uae-north" = "10.34.0.0/16",
    "uk-south" = "10.35.0.0/16",
    "uk-west" = "10.36.0.0/16",
    "us-westcentral" = "10.37.0.0/16",
    "europe-west" = "10.38.0.0/16",
    # "india-west" = "10.39.0.0/16",
    "us-west" = "10.40.0.0/16",
    "us-west2" = "10.41.0.0/16",
    "us-west3" = "10.42.0.0/16"
  }

  subnets = {
    "us-east" = "10.10.1.0/24",
    "australia-central" = "10.0.1.0/24",
    "australia-east" = "10.1.1.0/24",
    "australia-southeast" = "10.2.1.0/24",
    "brazil-south" = "10.3.1.0/24",
    "canada-central" = "10.4.1.0/24",
    # "canada-east" = "10.5.1.0/24",
    "india-central" = "10.6.1.0/24",
    "us-central" = "10.7.1.0/24",
    "asia-east" = "10.8.1.0/24",
    "asia-southeast" = "10.9.1.0/24",
    "us-east2" = "10.11.1.0/24",
    "france-central" = "10.12.1.0/24",
    "germany-westcentral" = "10.13.1.0/24",
    "indonesia-central" = "10.14.1.0/24",
    "israel-central" = "10.15.1.0/24",
    "italy-north" = "10.16.1.0/24",
    "japan-east" = "10.17.1.0/24",
    "japan-west" = "10.18.1.0/24",
    "korea-central" = "10.19.1.0/24",
    # "korea-south" = "10.20.1.0/24",
    "mexico-central" = "10.21.1.0/24",
    "newzealand-north" = "10.22.1.0/24",
    "norway-east" = "10.23.1.0/24",
    "us-northcentral" = "10.24.1.0/24",
    "europe-north" = "10.25.1.0/24",
    "poland-central" = "10.26.1.0/24",
    # "qatar-central" = "10.27.1.0/24",
    "southafrica-north" = "10.28.1.0/24",
    "us-southcentral" = "10.29.1.0/24",
    "india-south" = "10.30.1.0/24",
    "spain-central" = "10.31.1.0/24",
    "sweden-central" = "10.32.1.0/24",
    "switzerland-north" = "10.33.1.0/24",
    "uae-north" = "10.34.1.0/24",
    "uk-south" = "10.35.1.0/24",
    "uk-west" = "10.36.1.0/24",
    "us-westcentral" = "10.37.1.0/24",
    "europe-west" = "10.38.1.0/24",
    # "india-west" = "10.39.1.0/24",
    "us-west" = "10.40.1.0/24",
    "us-west2" = "10.41.1.0/24",
    "us-west3" = "10.42.1.0/24"
  }

  # Local variable to choose the VM size based on availability
  primary_size  = "Standard_B1s"
  backup_size   = "Standard_B1ls"
  # manually list regions whose primary_size is not available
  diff_regions = ["Canada East", "West India", "Korea South", "Qatar Central"] 
  

  # available_sizes = [
  #   "Standard_B1s", 
  #   "Standard_B1ls",
  #   "Standard_B1ms",
  #   "Standard_B2s", 
  #   "Standard_B2ms" 
  # ]
}


# Create virtual network
resource "azurerm_virtual_network" "vpn" {
  for_each = local.regions
  name                = "vpn-${each.key}"
  address_space       = [local.vpn_address_spaces[each.key]]
  location            = each.value
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  for_each = local.regions
  name                 = "subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vpn[each.key].name
  address_prefixes     = [local.subnets[each.key]]
}

# Create public IPs
resource "azurerm_public_ip" "vm_public_ip" {
  for_each = local.regions  
  name                = "public-ip-${each.key}"
  location            = each.value
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  for_each = local.regions

  name                = "nsg-${each.key}"
  location            = each.value
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowFlask"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Add ICMP rule for ping
  security_rule {
    name                       = "AllowICMP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  for_each = local.regions

  name                = "nic-${each.key}"
  location            = each.value
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                    = azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip[each.key].id 
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  for_each = local.regions

  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  for_each = local.regions
  byte_length = 8
}

# Create storage account for boot diagnostics
# resource "azurerm_storage_account" "my_storage_account" {
#   for_each = local.regions
#   name                     = "diag${random_id.random_id[each.key].hex}"
#   location                 = each.value
#   resource_group_name      = azurerm_resource_group.rg.name
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }



# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = local.regions
  name                  = "vm-${each.key}"
  location              = each.value
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  # size                  = "Standard_B1s"
  size                  = contains(local.diff_regions, each.value) ? local.backup_size : local.primary_size

  os_disk {
    name                 = "myOsDisk${random_id.random_id[each.key].hex}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"  # unmanaged disk
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "hostname"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = azapi_resource_action.ssh_public_key_gen.output.publicKey
  }

  # boot_diagnostics {
  #   storage_account_uri = azurerm_storage_account.my_storage_account[each.key].primary_blob_endpoint
  # }

  custom_data = base64encode(<<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y python3-pip
    pip3 install flask
  EOT
  )

}


resource "azurerm_virtual_network_peering" "us-east-to-peering" {
  # count = length(local.regions) - 1  # Exclude 'us-east' from the count
  for_each = { for region_code, region_name in local.regions : region_code => region_name if region_code != "us-east" }

  # name                         = "us-east-to-${element(keys(local.regions), count.index + 1)}"
  name                         = "us-east-to-${each.key}"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vpn["us-east"].name  
  # remote_virtual_network_id    = azurerm_virtual_network.vpn[element(keys(local.regions), count.index + 1)].id
  remote_virtual_network_id    = azurerm_virtual_network.vpn[each.key].id  
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "to-us-east-peering" {
  # count = length(local.regions) - 1  # Exclude 'us-east' from the count
    for_each = { for region_code, region_name in local.regions : region_code => region_name if region_code != "us-east" }

    # name                         = "${element(keys(local.regions), count.index + 1)}-to-us-east"
    name                         = "${each.key}-to-us-east"
    resource_group_name          = azurerm_resource_group.rg.name
    # virtual_network_name         = azurerm_virtual_network.vpn[element(keys(local.regions), count.index + 1)].name
    virtual_network_name         = azurerm_virtual_network.vpn[each.key].name
    remote_virtual_network_id    = azurerm_virtual_network.vpn["us-east"].id
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
}