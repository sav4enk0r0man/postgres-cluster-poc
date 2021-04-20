output "postgres_fip" {
  description = "postgres instance fip"
  value = "${openstack_networking_floatingip_v2.postgres_fip.*.address}"
}

output "postgres_network" {
  description = "postgres instance network"
  value = "${openstack_compute_instance_v2.postgres_instance.*.network}"
}
