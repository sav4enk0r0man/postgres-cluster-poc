###############################################################################
# postgres hosts outputs
###############################################################################
output "postgres_node1_fip" {
  description = "postgres node1 fip"
  value = "${module.postgres_node1.postgres_fip}"
}

output "postgres_node1_network" {
  description = "postgres network"
  value = "${module.postgres_node1.postgres_network}"
}

output "postgres_node2_fip" {
  description = "postgres node2 fip"
  value = "${module.postgres_node2.postgres_fip}"
}

output "postgres_node2_network" {
  description = "postgres network"
  value = "${module.postgres_node2.postgres_network}"
}

output "postgres_node3_fip" {
  description = "postgres node3 fip"
  value = "${module.postgres_node3.postgres_fip}"
}

output "postgres_node3_network" {
  description = "postgres network"
  value = "${module.postgres_node3.postgres_network}"
}

###############################################################################
# Salt master outputs
###############################################################################

output "salt_master_fip" {
  description = "Salt master fip"
  value = "${module.salt_master.salt_master_fip}"
}

output "salt_master_network" {
  description = "Salt master network"
  value = "${module.salt_master.salt_master_network}"
}
