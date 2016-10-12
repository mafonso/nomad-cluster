#!/bin/bash

cat > "$1" << EOF
{
  "bootstrap_expect": $CONSUL_BOOTSTRAP_EXPECT
}
EOF
