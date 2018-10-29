// variables section
variable "targetName" {
    default = "tdemo1"
 }
variable "location" {
    default = "westeurope"
 }
// yes, accept connections from everywhere 
variable "safeNetPrefixes" {
    default = "*"
}
// terribly insecure
variable "machinePassword" {
    default = "XXXYYYZZZ"
}

// specify provider and subscription to login
provider "azurerm" {
    subscription_id = "xxx-yyy-zzz-aaa-bbb-ccc"
    // service principal login secrets can be specified here
    // or in ENV vars
}

// create resource group
resource "azurerm_resource_group" "demorg" {
        name = "td-${var.targetName}-rg"
        location = "${var.location}"
        
        tags {
            environment = "td-${var.targetName}"
        }
}

// create NSG with security rules
resource "azurerm_network_security_group" "demonsg" {
    name                = "td-${var.targetName}-NetworkSecurityGroup"
    location            = "${var.location}"
    // using internal variable referencing:
    resource_group_name = "${azurerm_resource_group.demorg.name}"

    security_rule {
        name                       = "RDP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "${var.safeNetPrefixes}"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "WinRM"
        priority                   = 1004
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "5985"
        source_address_prefix      = "${var.safeNetPrefixes}"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "WinRMHttps"
        priority                   = 1005
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "5986"
        source_address_prefix      = "${var.safeNetPrefixes}"
        destination_address_prefix = "*"
    }    

    tags {
        environment = "td-${var.targetName}"
    }
}

// create vNet
resource "azurerm_virtual_network" "demonetwork" {
    name                = "td-${var.targetName}-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.demorg.name}"

    tags {
        environment = "td-${var.targetName}"
    }
}

// create subnet
resource "azurerm_subnet" "demosubnet" {
    name                 = "td-${var.targetName}-subnet"
    resource_group_name  = "${azurerm_resource_group.demorg.name}"
    virtual_network_name = "${azurerm_virtual_network.demonetwork.name}"
    address_prefix       = "10.0.2.0/24"
}

// create public IP
resource "azurerm_public_ip" "demopublicip" {
    name                         = "td-${var.targetName}-publicIP"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.demorg.name}"
    public_ip_address_allocation = "static"

    tags {
        environment = "td-${var.targetName}"
    }
}

// create NIC
resource "azurerm_network_interface" "demonic" {
    name                = "td-${var.targetName}-nic"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    network_security_group_id = "${azurerm_network_security_group.demonsg.id}"

    ip_configuration {
        name                          = "td-${var.targetName}-nicConfiguration"
        subnet_id                     = "${azurerm_subnet.demosubnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.demopublicip.id}"
    }

    tags {
        environment = "td-${var.targetName}"
    }
}


// create VM
resource "azurerm_virtual_machine" "demovm" {
    name                  = "td-${var.targetName}-vm"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.demorg.name}"
    network_interface_ids = ["${azurerm_network_interface.demonic.id}"]
    vm_size               = "Standard_DS2_v2"

    // can be image from or a customized one
    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2016-Datacenter"
        version   = "latest"
    }

    storage_os_disk {
        name              = "techdayinstOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    os_profile {
        computer_name  = "td${var.targetName}"
        admin_username = "techdaysuser"
        admin_password = "${var.machinePassword}"
    }

    os_profile_windows_config {
        enable_automatic_upgrades = true
        provision_vm_agent = true
    }

    tags {
        environment = "td-${var.targetName}"
    }
}



// Install DSC VM extension
// We will need it for the next steps
// Derived from https://medium.com/modern-stack/bootstrap-a-vm-to-azure-automation-dsc-using-terraform-f2ba41d25cd2
variable "dsc_key" {
  default = "ENTER YOU KEY FROM AUTOMATION ACCOUNT HERE"
}

variable "dsc_endpoint" {
  default = "https://we-agentservice-prod-1.azure-automation.net/accounts/94044861-75e5-4c67-a7dd-9d298s9ad6dc"
}

// DSC configuration that needs to exist in Azure DSC prior to deployment
variable dsc_config {
  default = "TechDaysDemo1.localhost"
}

resource "azurerm_virtual_machine_extension" "techdayinstdscextension" {
  name                 = "td${var.targetName}"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.demorg.name}"
  virtual_machine_name = "${azurerm_virtual_machine.demovm.name}"
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.73"
  depends_on           = ["azurerm_virtual_machine.demovm"]

  settings = <<SETTINGS
        {
            "wmfVersion": "latest",
            "ModulesUrl": "https://eus2oaasibizamarketprod1.blob.core.windows.net/automationdscpreview/RegistrationMetaConfigV2.zip",
            "ConfigurationFunction": "RegistrationMetaConfigV2.ps1\\RegistrationMetaConfigV2",
            "Properties": {
                "RegistrationKey": {
                  "UserName": "PLACEHOLDER_DONOTUSE",
                  "Password": "PrivateSettingsRef:registrationKeyPrivate"
                },
                "RegistrationUrl": "${var.dsc_endpoint}",
                "NodeConfigurationName": "${var.dsc_config}",
                "ConfigurationMode": "ApplyAndAutoCorrect",
                "ConfigurationModeFrequencyMins": 15,
                "RefreshFrequencyMins": 30,
                "RebootNodeIfNeeded": true,
                "ActionAfterReboot": "continueConfiguration",
                "AllowModuleOverwrite": true
            }
        }
    SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "Items": {
        "registrationKeyPrivate" : "${var.dsc_key}"
      }
    }
PROTECTED_SETTINGS
}

// prints out assigned IP
output "IpAddress" {
  value = "${azurerm_public_ip.demopublicip.ip_address}"
}
