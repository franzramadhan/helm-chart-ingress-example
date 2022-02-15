# Helm Chart Example with Nginx Ingress

This is another example of simple helm chart with Nginx Ingress. This demo is currently only tested in following platform

```
Kernel: Darwin Kernel Version 20.6.0 root:xnu-7195.141.19~2/RELEASE_X86_64 x86_64
OS: MacOs Big Sur version 11.6.3
```

## Usage

All commands must be run within the same directory as the `Makefile`

- `make prepare` - to install the required depencies
- `make init` - initialize the kubernetes cluster with `kind`
- `make compose` - bring up the containers using `docker-compose`
- `make install` - install the helm chart to be deployed in the `kind` cluster
- `make update` - update the deployed resources in the `kind` cluster with the latest chart changes
- `make uninstall` - uninstall the running resources created by the chart in the `kind` cluster
- `make destroy` - clean up all resources e.g clusters, networking, and image
- `make help` - print out the Makefile content to see the complete usages

## Author

- [Frans Caisar Ramadhan](http://github.com/franzramadhan)

