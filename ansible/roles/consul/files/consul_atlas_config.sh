#!/bin/bash

cat > "$1" << EOF
{
  "encrypt": $CONSUL_ENCRYPT,
  "atlas_infrastructure": "$ATLAS_INFRASTRUCTURE",
  "atlas_join": $ATLAS_JOIN}
EOF
