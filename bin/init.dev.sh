#!/bin/bash

  # Set WORKDIR so it doesn't matter from which directory this script is called
  WORKDIR=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P);

  # Generate SSL self signed certificates
  SSLDIR="$WORKDIR"/../etc/nginx/development/ssl;
  openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout "$SSLDIR"/selfsigned.key -out "$SSLDIR"/selfsigned.crt -subj "/CN=hello.local"