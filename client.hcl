data_dir = "/tmp/data"
bind_addr = "0.0.0.0"
name = "nomad2"

# Advertise on nebula2 interface only (nomad2 has more interfaces, one with public IP and one with private IP - nebula1 interface)
advertise {
  # Defaults to the first private IP address.
  http = "172.17.0.2"
  rpc  = "172.17.0.2"
  serf = "172.17.0.2"
}

# Enable client and setup server's IP to the nomad1 IP
client {
  enabled = true
  servers = ["172.30.1.2"]
}

# Enable raw_exec Nomad driver
plugin "raw_exec" {
  config {
    enabled = true
  }
}
