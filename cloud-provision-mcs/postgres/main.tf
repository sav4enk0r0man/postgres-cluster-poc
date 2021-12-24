terraform {
  required_version = ">= 0.14"

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

# Create network port for postgres node
resource "openstack_networking_port_v2" "postgres_port" {
  count          = var.postgres_enable
  name           = "${var.hostname}_port"
  network_id     = var.network_id
  admin_state_up = "true"
  fixed_ip {
    subnet_id = var.subnet_id
    ip_address = ""
  }

  lifecycle {
    ignore_changes = [
      dns_assignment,
      network_id
    ]
  }
}

# Create internal network port for postgres node
resource "openstack_networking_port_v2" "postgres_internal_port" {
  count          = var.postgres_enable
  name           = "${var.hostname}_internal_port"
  network_id     = var.internal_network_id
  admin_state_up = "true"
  fixed_ip {
    subnet_id = var.internal_subnet_id
    ip_address = ""
  }

  lifecycle {
    ignore_changes = [
      dns_assignment,
      network_id
    ]
  }
}

# Create floating ip for postgres instance
resource "openstack_networking_floatingip_v2" "postgres_fip" {
  count = var.postgres_enable
  pool  = var.fip_network
}

# Associate a floating IP to a instance port
resource "openstack_networking_floatingip_associate_v2" "postgres_fip" {
  count       = var.postgres_enable
  floating_ip = openstack_networking_floatingip_v2.postgres_fip[count.index].address
  port_id     = openstack_networking_port_v2.postgres_port[count.index].id

  lifecycle {
    ignore_changes = [
      port_id
    ]
  }
}

resource "openstack_compute_floatingip_associate_v2" "postgres_fip" {
  count       = var.postgres_enable
  floating_ip = openstack_networking_floatingip_v2.postgres_fip[count.index].address
  instance_id = openstack_compute_instance_v2.postgres_instance[count.index].id
  fixed_ip    = openstack_compute_instance_v2.postgres_instance[count.index].network.1.fixed_ip_v4
}

# Create volume for postgres instance
resource "openstack_blockstorage_volume_v2" "postgres_volume" {
  count       = var.postgres_enable
  name        = "${var.hostname}-volume"
  volume_type = var.postgres_volume_type
  size        = var.postgres_volume_size
  image_id    = var.postgres_image_id
}

# Create security groups for postgres instance port
resource "openstack_networking_secgroup_v2" "postgres_secgroup" {
  count       = var.postgres_enable
  name        = "security_group_${var.hostname}"
  description = "Security group for ${var.hostname}"
}

# Create security rule: allow access to 22 port for any
resource "openstack_networking_secgroup_rule_v2" "postgres_rule_in_22" {
  count             = var.postgres_enable
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.postgres_ip_witelist
  security_group_id = openstack_networking_secgroup_v2.postgres_secgroup[count.index].id
}

# Create security rule: allow access to 5432 port for any
resource "openstack_networking_secgroup_rule_v2" "postgres_rule_in_5432" {
  count             = var.postgres_enable
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_ip_prefix  = var.postgres_ip_witelist
  security_group_id = openstack_networking_secgroup_v2.postgres_secgroup[count.index].id
}

# Create security rule: allow icmp for any
resource "openstack_networking_secgroup_rule_v2" "postgres_rule_in_icmp" {
  count             = var.postgres_enable
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = var.postgres_ip_witelist
  security_group_id = openstack_networking_secgroup_v2.postgres_secgroup[count.index].id
}

# Associate a security group to postgres instance port
resource "openstack_networking_port_secgroup_associate_v2" "postgres_secgroup_accociate" {
  count              = var.postgres_enable
  port_id            = openstack_networking_port_v2.postgres_port[count.index].id
  security_group_ids = [
    openstack_networking_secgroup_v2.postgres_secgroup[count.index].id,
  ]
  lifecycle {
    ignore_changes = [
      port_id,
      all_security_group_ids
    ]
  }
}

# Create postgres instance
resource "openstack_compute_instance_v2" "postgres_instance" {
  count             = var.postgres_enable
  name              = var.hostname
  flavor_id         = var.postgres_flavor_id
  key_pair          = var.postgres_keypair
  config_drive      = true

  security_groups = [
    "default",
    "security_group_${var.hostname}"
  ]

  block_device {
    uuid                  = openstack_blockstorage_volume_v2.postgres_volume[count.index].id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    uuid = var.internal_network_id
    port = openstack_networking_port_v2.postgres_internal_port[count.index].id
  }

  network {
    uuid = var.network_id
    port = openstack_networking_port_v2.postgres_port[count.index].id
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = openstack_networking_floatingip_v2.postgres_fip[count.index].address
      user        = var.ssh_user
      timeout     = "120s"
      private_key = file("${var.ssh_dir}/${var.ssh_private_key}")
      agent       = false
    }
    inline = [
      // update packages
      "sudo yum update -y",
    ]
  }
}

# Init postgres host
resource "null_resource" "postgres_exec" {
  count         = var.postgres_enable

  triggers = {
    trigger = "${tostring(openstack_compute_instance_v2.postgres_instance[count.index].id)}"
  }

  connection {
    type        = "ssh"
    host        = openstack_networking_floatingip_v2.postgres_fip[count.index].address
    user        = var.ssh_user
    timeout     = "120s"
    private_key = file("${var.ssh_dir}/${var.ssh_private_key}")
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      // install packages
      "sudo yum install epel-release vim telnet traceroute tcpdump htop mc -y",
    ]
  }

  provisioner "remote-exec" {
    // provisioning commands
    inline = var.provision_commands
  }

  depends_on = [
    openstack_compute_instance_v2.postgres_instance
  ]
}
