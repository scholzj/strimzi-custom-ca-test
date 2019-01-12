#!/usr/bin/env bash

# Create secrets
# oc delete secret my-cluster-cluster-ca-cert
# oc create secret generic my-cluster-cluster-ca-cert \
#   --from-file=ca.crt=strimzi-bundle.crt \
#   && oc label secret my-cluster-cluster-ca-cert \
#   app=my-cluster \
#   strimzi.io/kind=Kafka \
#   strimzi.io/cluster=my-cluster

# oc delete secret my-cluster-cluster-ca
# oc create secret generic my-cluster-cluster-ca \
#   --from-file=ca.key=strimzi.key \
#   && oc label secret my-cluster-cluster-ca \
#   app=my-cluster \
#   strimzi.io/kind=Kafka \
#   strimzi.io/cluster=my-cluster

# oc delete secret my-cluster-clients-ca-cert
# oc create secret generic my-cluster-clients-ca-cert \
#   --from-file=ca.crt=clients-bundle.crt \
#   && oc label secret my-cluster-clients-ca-cert \
#   app=my-cluster \
#   strimzi.io/kind=Kafka \
#   strimzi.io/cluster=my-cluster

# oc delete secret my-cluster-clients-ca
# oc create secret generic my-cluster-clients-ca \
#   --from-file=ca.key=clients.key \
#   && oc label secret my-cluster-clients-ca \
#   app=my-cluster \
#   strimzi.io/kind=Kafka \
#   strimzi.io/cluster=my-cluster


oc delete secret my-cluster-cluster-ca-cert
oc create secret generic my-cluster-cluster-ca-cert \
  --from-file=ca.crt=strimzi-bundle.crt \
  && oc label secret my-cluster-cluster-ca-cert \
  strimzi.io/kind=Kafka \
  strimzi.io/cluster=my-cluster

oc delete secret my-cluster-cluster-ca
oc create secret generic my-cluster-cluster-ca \
  --from-file=ca.key=strimzi.key \
  && oc label secret my-cluster-cluster-ca \
  strimzi.io/kind=Kafka \
  strimzi.io/cluster=my-cluster

oc delete secret my-cluster-clients-ca-cert
oc create secret generic my-cluster-clients-ca-cert \
  --from-file=ca.crt=clients-bundle.crt \
  && oc label secret my-cluster-clients-ca-cert \
  strimzi.io/kind=Kafka \
  strimzi.io/cluster=my-cluster

oc delete secret my-cluster-clients-ca
oc create secret generic my-cluster-clients-ca \
  --from-file=ca.key=clients.key \
  && oc label secret my-cluster-clients-ca \
  strimzi.io/kind=Kafka \
  strimzi.io/cluster=my-cluster