data_dir = "/opt/nomad/data"
bind_addr = "0.0.0.0"

name = "nomad1"

# Advertise on nebula1 interface only (nomad1 has more interfaces, one with public IP and one with private IP - nebula1 interface)
advertise {
  # Defaults to the first private IP address.
  http = "172.30.1.2"
  rpc  = "172.30.1.2"
  serf = "172.30.1.2"
}

limits {
  http_max_conns_per_client = 0
}

# Enable server on nomad1
server {
  enabled = true
  bootstrap_expect = 1
}

# Enable client on nomad1
client {
  enabled = true
  servers = ["127.0.0.1"]
}

# Enable raw_exec driver
plugin "raw_exec" {
  config {
    enabled = true
  }
}
