resource "digitalocean_vpc" "vpc-wordpress" {
  name   = "vpc-wordpress"
  region = "nyc3"
}

resource "digitalocean_droplet" "wordpress-vm" {
  name     = "wordpress-vm-${count.index}"
  size     = "s-1vcpu-1gb"
  image    = "ubuntu-22-04-x64"
  region   = "nyc3"
  vpc_uuid = digitalocean_vpc.vpc-wordpress.id
  count    = var.vm-wordpress-count
  ssh_keys = [data.digitalocean_ssh_key.ssh_keys.id]
}

resource "digitalocean_droplet" "NFS_vm" {
  name     = "NFS-vm"
  size     = "s-1vcpu-1gb"
  image    = "ubuntu-22-04-x64"
  region   = "nyc3"
  vpc_uuid = digitalocean_vpc.vpc-wordpress.id
  ssh_keys = [data.digitalocean_ssh_key.ssh_keys.id]
}

resource "digitalocean_database_mysql_config" "wp-mysql-database" {
  cluster_id        = digitalocean_database_cluster.wp-mysql-database.id
  connect_timeout   = 10
  default_time_zone = "UTC"
}

resource "digitalocean_database_cluster" "wp-mysql-database" {
  name       = "wp-mysql-database-mysql-cluster"
  engine     = "mysql"
  version    = "8"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc3"
  node_count = 1
}

resource "digitalocean_database_user" "wordpress" {
  cluster_id = digitalocean_database_cluster.wp-mysql-database.id
  name       = "wordpress"
}

resource "digitalocean_loadbalancer" "public" {
  name   = "loadbalancer-1"
  region = "nyc3"

  forwarding_rule {
    entry_port =  80
    entry_protocol = "http"

    target_port = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_ids = [digitalocean_droplet.wordpress-vm[0].id]
}

data "digitalocean_ssh_key" "ssh_keys" {
  name = var.ssh_keys
}