terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket   = "postgres-poc"
    key      = "terraform.tfstate"
    endpoint = "https://hb.bizmrg.com"
    region   = "RegionOne"

    skip_requesting_account_id = true
    skip_credentials_validation = true
    skip_get_ec2_platforms = true
    skip_metadata_api_check = true
    skip_region_validation = true

    shared_credentials_file = "../.aws/credentials-terraform"
  }
}

provider "openstack" {
  # Use local openrc credentials
}

# Postgres private network
resource "openstack_networking_network_v2" "postgres_network" {
  name           = "postgres_network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "postgres_subnet" {
  name       = "postgres_subnet"
  network_id = openstack_networking_network_v2.postgres_network.id
  cidr       = "10.128.0.0/24"
  ip_version = 4
}

# Postgres internal network
resource "openstack_networking_network_v2" "postgres_internal_network" {
  name           = "postgres_internal_network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "postgres_internal_subnet" {
  name       = "postgres_subnet"
  network_id = openstack_networking_network_v2.postgres_internal_network.id
  cidr       = "10.64.0.0/24"
  no_gateway = true
  ip_version = 4
}

# OpenStack virtual router for postgres network
resource "openstack_networking_router_v2" "postgres_router" {
  name                = "postgres_router"
  admin_state_up      = true
  external_network_id = var.external_network_id
}

# Add network interface to postgres network
resource "openstack_networking_router_interface_v2" "postgres_router_interface" {
  router_id = openstack_networking_router_v2.postgres_router.id
  subnet_id = openstack_networking_subnet_v2.postgres_subnet.id
}

# Provisioning postgres node1
module "postgres_node1" {
  source                 = "./postgres"

  hostname               = "postgres1"
  network_id             = "${openstack_networking_network_v2.postgres_network.id}"
  subnet_id              = "${openstack_networking_subnet_v2.postgres_subnet.id}"
  internal_network_id    = "${openstack_networking_network_v2.postgres_internal_network.id}"
  internal_subnet_id     = "${openstack_networking_subnet_v2.postgres_internal_subnet.id}"
  postgres_keypair       = "${var.keypair}"
  ssh_dir                = "${var.ssh_dir}"
  ssh_private_key        = "${var.ssh_private_key}"
  postgres_enable        = "${var.enable}"
  postgres_ip_witelist   = "${var.postgres_ip_witelist}"
}

# Provisioning postgres node2
module "postgres_node2" {
  source                 = "./postgres"

  hostname               = "postgres2"
  network_id             = "${openstack_networking_network_v2.postgres_network.id}"
  subnet_id              = "${openstack_networking_subnet_v2.postgres_subnet.id}"
  internal_network_id    = "${openstack_networking_network_v2.postgres_internal_network.id}"
  internal_subnet_id     = "${openstack_networking_subnet_v2.postgres_internal_subnet.id}"
  postgres_keypair       = "${var.keypair}"
  ssh_dir                = "${var.ssh_dir}"
  ssh_private_key        = "${var.ssh_private_key}"
  postgres_enable        = "${var.enable}"
  postgres_ip_witelist   = "${var.postgres_ip_witelist}"
}

# Provisioning postgres node3
module "postgres_node3" {
  source                 = "./postgres"

  hostname               = "postgres3"
  network_id             = "${openstack_networking_network_v2.postgres_network.id}"
  subnet_id              = "${openstack_networking_subnet_v2.postgres_subnet.id}"
  internal_network_id    = "${openstack_networking_network_v2.postgres_internal_network.id}"
  internal_subnet_id     = "${openstack_networking_subnet_v2.postgres_internal_subnet.id}"
  postgres_keypair       = "${var.keypair}"
  ssh_dir                = "${var.ssh_dir}"
  ssh_private_key        = "${var.ssh_private_key}"
  postgres_enable        = "${var.enable}"
  postgres_ip_witelist   = "${var.postgres_ip_witelist}"
}

# Provisioning Salt master host
module "salt_master" {
  source                   = "./salt-master"

  hostname                 = "postgres-salt-master"
  network_id               = "${openstack_networking_network_v2.postgres_network.id}"
  subnet_id                = "${openstack_networking_subnet_v2.postgres_subnet.id}"
  salt_master_keypair      = "${var.keypair}"
  ssh_dir                  = "${var.ssh_dir}"
  ssh_private_key          = "${var.ssh_private_key}"
  ansible_provision_prefix = "${var.ansible_provision_prefix}"
  salt_minion_addresess    = [
    "${length(module.postgres_node1.postgres_fip) > 0 ? element("${module.postgres_node1.postgres_fip}", 0) : null}",
    "${length(module.postgres_node2.postgres_fip) > 0 ? element("${module.postgres_node2.postgres_fip}", 0) : null}",
    "${length(module.postgres_node3.postgres_fip) > 0 ? element("${module.postgres_node3.postgres_fip}", 0) : null}",
  ]
  provision_commands       = [
    "sudo rm -rf /srv",
    "sudo git clone ${var.salt_repo} /srv"
  ]
  accept_minion_keys       = "${var.accept_minion_keys}"
  salt_master_enable       = "${var.enable}"
}
