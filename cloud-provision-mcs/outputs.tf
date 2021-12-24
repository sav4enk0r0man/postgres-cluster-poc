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

output "postgres_node4_fip" {
  description = "postgres node4 fip"
  value = "${module.postgres_node4.postgres_fip}"
}

output "postgres_node4_network" {
  description = "postgres network"
  value = "${module.postgres_node4.postgres_network}"
}

output "postgres_node5_fip" {
  description = "postgres node5 fip"
  value = "${module.postgres_node5.postgres_fip}"
}

output "postgres_node5_network" {
  description = "postgres network"
  value = "${module.postgres_node5.postgres_network}"
}

output "postgres_node6_fip" {
  description = "postgres node6 fip"
  value = "${module.postgres_node6.postgres_fip}"
}

output "postgres_node6_network" {
  description = "postgres network"
  value = "${module.postgres_node6.postgres_network}"
}

output "postgres_node7_fip" {
  description = "postgres node7 fip"
  value = "${module.postgres_node7.postgres_fip}"
}

output "postgres_node7_network" {
  description = "postgres network"
  value = "${module.postgres_node7.postgres_network}"
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
