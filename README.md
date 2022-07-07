# Running Strimzi with custom CA

This repository contains files for testing Strimzi with custom CA.
[Strimzi](https://strimzi.io) is the best way to get Apache Kafka running on Kubernetes or OpenShift ;-).

## Prerequisites

The scripts in this repository are using Bash, were tested on MacOS and require [CFSSL](https://github.com/cloudflare/cfssl) and the [Kubernetes `kubectl` utility](https://kubernetes.io/docs/reference/kubectl/kubectl/) to be installed on your computer.

## Generating certitficates

To generate the certificates, run `./build.sh`.
It will generate following hierarchy:

* Root CA
  * Intermidiate CA
    * Strimzi CA (for cluster - brokers, nodes etc.)
    * Clients CA (for users created using the Strimzi User Operator)

If you want to configure the subjects of the CAs, edit the corresponging JSON file.
In case of setting expiry date, change main config.yaml file for appropriate certificate(s).

## Creating Secrets with the custom CAs

Once are the certificates generated, you can create the Secrets in your Kubernetes or OpenShift cluster which will contain the certificates.
To do this, run `./load.sh`
The secrets will be prepared for a cluster named `my-cluster`.
If your cluster is using different name, you have to modify the script.

## Deploying cluster

Once the Secrets are ready, you can just deploy the Kafka cluster.
You can use the example YAML file from this repo: `kubectl apply -f kafka-ephemeral.yaml`.

# Cleaning up

Running `./clean.sh` will delete all the generated keys.
