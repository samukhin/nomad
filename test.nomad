job "docs" {
datacenters = ["dc1"]
type = "service"

group "example" {
count = 1

network {
port "http" {
static = 8000
}
}

task "example" {

artifact {
source      = "https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-minirootfs-3.14.8-x86_64.tar.gz"
destination = "local/rootfs"
options {
archive = false
}
}

driver = "raw_exec"
resources {
memory = 256
}

config {
command = "bash"
args = ["-c", 
        <<EOT
        set -eux;
        rm -rfv $NOMAD_ALLOC_DIR/\*;
        cp local/rootfs/alpine-minirootfs-3.14.8-x86_64.tar.gz $NOMAD_ALLOC_DIR/;
        cd $NOMAD_ALLOC_DIR/; tar xf alpine-minirootfs-3.14.8-x86_64.tar.gz;
        cp /etc/resolv.conf etc/resolv.conf;
        proot -r . -b /proc -b /dev -b /sys apk update;
        proot -r . -b /proc -b /dev -b /sys apk upgrade;
        proot -r . -b /proc -b /dev -b /sys apk add python3;
        python3 -m http.server;
        EOT
       ]
}
}

}
}
