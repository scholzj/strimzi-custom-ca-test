#!/usr/bin/env bash

# Delete old certificates which should be renewed
rm strimzi.pem strimzi-bundle.crt clients.pem clients-bundle.crt

# Sign new public keys for clients and cluster CAs
cfssl sign -config config.json -profile clusterCA -ca intermediate.pem -ca-key intermediate-key.pem strimzi.csr strimzi.json | cfssljson -bare strimzi
cfssl sign -config config.json -profile clientsCA -ca intermediate.pem -ca-key intermediate-key.pem clients.csr clients.json | cfssljson -bare clients

# Create new CRT bundles
cat strimzi.pem > strimzi-bundle.crt
cat intermediate.pem >> strimzi-bundle.crt
cat ca.pem >> strimzi-bundle.crt
cat clients.pem > clients-bundle.crt
cat intermediate.pem >> clients-bundle.crt
cat ca.pem >> clients-bundle.crt