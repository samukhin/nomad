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

task "example" {

artifact {
source      = "http://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-minirootfs-3.14.8-x86_64.tar.gz"
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
cd rootfs
tar xf alpine-minirootfs-3.14.8-x86_64.tar.gz
cp /etc/resolv.conf etc/
proot -r . -b /sys -b /proc -b /dev apk update
proot -r . -b /sys -b /proc -b /dev apk upgrade
proot -r . -b /sys -b /proc -b /dev apk add python3
proot -r . -b /sys -b /proc -b /dev python3 -m http.server
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
