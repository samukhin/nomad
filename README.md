```
wget https://releases.hashicorp.com/nomad/1.4.2/nomad_1.4.2_linux_amd64.zip
unzip nomad_1.4.2_linux_amd64.zip

На сервере:
./nomad agent -config=server.hcl

На клиенте:
./nomad agent -config=client.hcl
либо (если нет бинарника ip)
./nomad agent -config=/config/client.hcl -network-interface=eth0

Клиент в непревилегированном режиме:
docker run -it --rm --user 1001:1001 debian:9

Перейти нужно по адресу:

http://сервер:4646


server.hcl:

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


client.hcl:

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



Пример задания:

job "docs" {
datacenters = ["dc1"]
type = "service"
#type = "batch"

group "example" {
count = 5

task "example" {
driver = "raw_exec"

config {
command = "cat"
args = ["/etc/os-release"]
}
}

}
}
```
