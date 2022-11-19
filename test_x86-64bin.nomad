job "docs" {
datacenters = ["dc1"]
type = "service"

group "example" {
count = 2

network {
port "http" {
static = 8000
}
}

ephemeral_disk {
migrate = true
size    = 500
sticky  = true
}
  
task "example" {

artifact {
source      = "http://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-minirootfs-3.14.8-x86_64.tar.gz"
destination = "local/"
options {
archive = false
}
}

artifact {
source      = "http://github.com/samukhin/nomad/raw/main/proot"
destination = "local/"
options {
archive = false
}
}
  
template {
data = <<EOT
#!/bin/sh
set -eux
cd ${NOMAD_TASK_DIR}/
rm -rfv rootfs
mkdir rootfs
cp alpine-minirootfs-3.14.8-x86_64.tar.gz rootfs/
cp proot rootfs/proot
cd rootfs
tar xf alpine-minirootfs-3.14.8-x86_64.tar.gz
cp /etc/resolv.conf etc/
chmod +x ./proot
./proot -r . -b /sys -b /proc -b /dev -i 0:0 apk update
./proot -r . -b /sys -b /proc -b /dev -i 0:0 apk upgrade
./proot -r . -b /sys -b /proc -b /dev -i 0:0 apk add python3
./proot -r . -b /sys -b /proc -b /dev -i 0:0 python3 -m http.server
EOT

destination = "local/script.sh"
}

driver = "raw_exec"
resources {
memory = 256
}

config {
command = "bash"
args = ["-c", 
        <<EOT
        chmod +x local/script.sh
        ./local/script.sh
        EOT
       ]
}
}

}
}
