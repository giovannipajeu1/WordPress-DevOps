output "vm-wordpress" {
  value = digitalocean_droplet.wordpress-vm[*].ipv4_address
}

output "wp-mysql-database-password" {
  value = digitalocean_database_cluster.wp-mysql-database.password
  sensitive = true
}

output "wp-mysql-database-user" {
  value = digitalocean_database_cluster.wp-mysql-database.user
}
