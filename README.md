# FAVA CASA
A modest homelab for running self-hosted workloads in kubernetes

## Host Info

### Hardware

- Dell Precision 3620
- Intel Core i7 6700
- 45GB 2133 MHz DDR4
- 1 TB nvme

### Hypervisor

- Proxmox 8.1.4

## Cluster 

- Talos Linux 1.9.5
- Kubernetes 1.30.10
- argocd 8.1.4
- istio ambient 1.23.5
- Gateway API Experimental 1.2.1
- metallb 0.14.9
- cert-manager 1.17.1
- openebs 4.2.0
- kubernetes reflector 9.0.322

### Talos
Talos Linux is ephemeral Linux designed for Kubernetes – secure, immutable, and minimal.

Talos is a container optimized Linux distro; a reimagining of Linux for distributed systems such as Kubernetes. Designed to be as minimal as possible while still maintaining practicality. For these reasons, Talos has a number of features unique to it:

- it is immutable
- it is atomic
- it is ephemeral
- it is minimal
- it is secure by default
- it is managed via a single declarative configuration file and gRPC API

Talos can be deployed on container, cloud, virtualized, and bare metal platforms.

https://www.talos.dev/

### ArgoCD

Application definitions, configurations, and environments should be declarative and version controlled. Application deployment and lifecycle management should be automated, auditable, and easy to understand.

https://argo-cd.readthedocs.io/en/stable/

### Istio Ambient

Ambient mode splits Istio’s functionality into two distinct layers. At the base, the ztunnel secure overlay handles routing and zero trust security for traffic. Above that, when needed, users can enable L7 waypoint proxies to get access to the full range of Istio features. Waypoint proxies, while heavier than the ztunnel overlay alone, still run as an ambient component of the infrastructure, requiring no modifications to application pods.

https://istio.io/latest/docs/ambient/overview/

### Gateway API

Gateway API is a family of API kinds that provide dynamic infrastructure provisioning and advanced traffic routing.

Make network services available by using an extensible, role-oriented, protocol-aware configuration mechanism. Gateway API is an add-on containing API kinds that provide dynamic infrastructure provisioning and advanced traffic routing.

https://kubernetes.io/docs/concepts/services-networking/gateway/

### MetalLb

MetalLB is a load-balancer implementation for bare metal Kubernetes clusters, using standard routing protocols.

Kubernetes does not offer an implementation of network load balancers (Services of type LoadBalancer) for bare-metal clusters. The implementations of network load balancers that Kubernetes does ship with are all glue code that calls out to various IaaS platforms (GCP, AWS, Azure…). If you’re not running on a supported IaaS platform (GCP, AWS, Azure…), LoadBalancers will remain in the “pending” state indefinitely when created.

https://metallb.io/

### cert-manager

cert-manager creates TLS certificates for workloads in your Kubernetes or OpenShift cluster and renews the certificates before they expire.

cert-manager can obtain certificates from a variety of certificate authorities, including: Let's Encrypt, HashiCorp Vault, Venafi and private PKI.

With cert-manager's Certificate resource, the private key and certificate are stored in a Kubernetes Secret which is mounted by an application Pod or used by an Ingress controller. With csi-driver, csi-driver-spiffe, or istio-csr , the private key is generated on-demand, before the application starts up; the private key never leaves the node and it is not stored in a Kubernetes Secret.

https://cert-manager.io/

### OpenEBS

OpenEBS helps Developers and Platform SREs easily deploy Kubernetes Stateful Workloads that require fast and highly reliable Container Native Storage. OpenEBS turns any storage available on the Kubernetes worker nodes into local or distributed Kubernetes Persistent Volumes.

https://openebs.io/

### kubernetes reflector

Reflector is a Kubernetes addon designed to monitor changes to resources (secrets and configmaps) and reflect changes to mirror resources in the same or other namespaces.

https://github.com/emberstack/kubernetes-reflector

# Setup Guide

Setup instructions can be viewed in the SETUP.md
