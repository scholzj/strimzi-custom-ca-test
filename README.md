# Running Strimzi with custom CA

This repository contains files for testing Strimzi with custom CA.
[Strimzi](https://strimzi.io) is the best way to get Apache Kafka running on Kubernetes or OpenShift ;-).

## Prerequisites

The scripts in this repository are using Bash, were tested on MacOS and require [CFSSL](https://github.com/cloudflare/cfssl) and the [Kubernetes `kubectl` utility](https://kubernetes.io/docs/reference/kubectl/kubectl/) to be installed on your computer.

### Generating certificates

To generate the certificates, run `./build.sh`.
It will generate the following hierarchy:

* Root CA
  * Intermediate CA
    * Strimzi CA (for the cluster - brokers, nodes etc.)
    * Clients CA (for users created using the Strimzi User Operator)

If you want to configure the subjects of the CAs, edit the corresponding JSON file.
In case of setting the expiration date, change the main config.yaml file for appropriate certificate(s).

## Use with a new cluster

### Creating Secrets with the custom CAs

Once are the certificates generated, you can create the Secrets in your Kubernetes or OpenShift cluster which will contain the certificates.
To do this, run `./load.sh`
The secrets will be prepared for a cluster named `my-cluster`.
If your cluster is using a different name, you have to modify the script.

### Deploying cluster

Once the Secrets are ready, you can just deploy the Kafka cluster.
You can use the example YAML file from this repo: `kubectl apply -f kafka-persistent.yaml`.

## Moving from Strimzi CAs to custom CAs

* Pause reconciliation:
  ```
  kubectl annotate kafka my strimzi.io/pause-reconciliation="true" --overwrite
  ```
* Configure custom CAs:
  ```yaml
    clusterCa:
      generateCertificateAuthority: false
    clientsCa:
      generateCertificateAuthority: false
  ```
* Patch ClusterCA key:
  ```
  kubectl patch secret my-cluster-cluster-ca -p '{"data": {"ca.key": "'$(base64 -i ./strimzi.key)'"}}'
  kubectl annotate secret my-cluster-cluster-ca strimzi.io/ca-key-generation="1" --overwrite
  ```
* Patch ClusterCA certificate
  ```
  kubectl patch secret my-cluster-cluster-ca-cert -p '{"data": {"ca-'$(date +%Y-%m-%d)'.crt": "'$(kubectl get secret my-cluster-cluster-ca-cert -o=jsonpath='{.data.ca\.crt}')'"}}'
  kubectl patch secret my-cluster-cluster-ca-cert -p '{"data": {"ca.crt": "'$(base64 -i ./strimzi-bundle.crt)'"}}'
  kubectl annotate secret my-cluster-cluster-ca-cert strimzi.io/ca-cert-generation="1" --overwrite
  ```
* Patch ClientsCA key:
  ```
  kubectl patch secret my-cluster-clients-ca -p '{"data": {"ca.key": "'$(base64 -i ./clients.key)'"}}'
  kubectl annotate secret my-cluster-clients-ca strimzi.io/ca-key-generation="1" --overwrite
  ```
* Patch ClientsCA certificate
  ```
  kubectl patch secret my-cluster-clients-ca-cert -p '{"data": {"ca-'$(date +%Y-%m-%d)'.crt": "'$(kubectl get secret my-cluster-clients-ca-cert -o=jsonpath='{.data.ca\.crt}')'"}}'
  kubectl patch secret my-cluster-clients-ca-cert -p '{"data": {"ca.crt": "'$(base64 -i ./clients-bundle.crt)'"}}'
  kubectl annotate secret my-cluster-clients-ca-cert strimzi.io/ca-cert-generation="1" --overwrite
  ```
* Unpause reconciliation:
  ```
  kubectl annotate kafka my strimzi.io/pause-reconciliation="false" --overwrite
  ```

## Cleaning up

Running `./clean.sh` will delete all the generated keys.
