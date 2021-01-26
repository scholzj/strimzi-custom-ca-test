#!/usr/bin/env bash

# Generate CA with Root, Intermediate and Strimzi / Clients CAs
cfssl genkey -initca ca.json | cfssljson -bare ca
cfssl genkey intermediate.json | cfssljson -bare intermediate
cfssl sign -config config.json -profile CA -ca ca.pem -ca-key ca-key.pem intermediate.csr intermediate.json | cfssljson -bare intermediate
cfssl genkey strimzi.json | cfssljson -bare strimzi
cfssl sign -config config.json -profile clusterCA -ca intermediate.pem -ca-key intermediate-key.pem strimzi.csr strimzi.json | cfssljson -bare strimzi
cfssl genkey clients.json | cfssljson -bare clients
cfssl sign -config config.json -profile clientsCA -ca intermediate.pem -ca-key intermediate-key.pem clients.csr clients.json | cfssljson -bare clients

# Create CRT bundles
cat strimzi.pem > strimzi-bundle.crt
cat intermediate.pem >> strimzi-bundle.crt
cat ca.pem >> strimzi-bundle.crt
cat clients.pem > clients-bundle.crt
cat intermediate.pem >> clients-bundle.crt
cat ca.pem >> clients-bundle.crt

# Convert keys to PKCS8
openssl pkcs8 -topk8 -nocrypt -in ca-key.pem -out ca.key
openssl pkcs8 -topk8 -nocrypt -in intermediate-key.pem -out intermediate.key
openssl pkcs8 -topk8 -nocrypt -in clients-key.pem -out clients.key
openssl pkcs8 -topk8 -nocrypt -in strimzi-key.pem -out strimzi.key
