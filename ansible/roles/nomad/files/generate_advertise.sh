#!/bin/bash

IP=$(hostname -I | tr -d '[:space:]')

cat > $1 << EOF
advertise {
    http = "$IP:4646"
    rpc = "$IP:4647"
    serf = "$IP:4648"
}
EOF