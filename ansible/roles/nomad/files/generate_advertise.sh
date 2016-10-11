#!/bin/bash

source /etc/environment
IP=$(hostname -I | tr -d '[:space:]')

cat > $1 << EOF
advertise {
    http = "$IP:4646"
    rpc = "$IP:4647"
    serf = "$IP:4648"
}

server {
    enabled = "true"
    bootstrap_expect = "$NOMAD_BOOTSTRAP_EXPECT"
}
EOF