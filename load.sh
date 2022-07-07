#!/usr/bin/env bash

# Create secrets, label and annotate secrets

kubectl delete secret my-cluster-cluster-ca-cert
kubectl create secret generic my-cluster-cluster-ca-cert \
  --from-file=ca.crt=strimzi-bundle.crt
kubectl label secret my-cluster-cluster-ca-cert \
  strimzi.io/kind=Kafka \
  strimzi.io/cluster=my-cluster
kubectl annotate secret my-cluster-cluster-ca-cert \
  strimzi.io/ca-cert-generation=0

kubectl delete secret my-cluster-cluster-ca
kubectl create secret generic my-cluster-cluster-ca \
  --from-file=ca.key=strimzi.key
kubectl label secret my-cluster-cluster-ca \
  strimzi.io/kind=Kafka \
  strimzi.io/cluster=my-cluster
kubectl annotate secret my-cluster-cluster-ca \
  strimzi.io/ca-key-generation=0

kubectl delete secret my-cluster-clients-ca-cert
kubectl create secret generic my-cluster-clients-ca-cert \
  --from-file=ca.crt=clients-bundle.crt
kubectl label secret my-cluster-clients-ca-cert \
  strimzi.io/kind=Kafka \
  strimzi.io/cluster=my-cluster
kubectl annotate secret my-cluster-clients-ca-cert \
  strimzi.io/ca-cert-generation=0

kubectl delete secret my-cluster-clients-ca
kubectl create secret generic my-cluster-clients-ca \
  --from-file=ca.key=clients.key
kubectl label secret my-cluster-clients-ca \
  strimzi.io/kind=Kafka \
  strimzi.io/cluster=my-cluster
kubectl annotate secret my-cluster-clients-ca \
  strimzi.io/ca-key-generation=0