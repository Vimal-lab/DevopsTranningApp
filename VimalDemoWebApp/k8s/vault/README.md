## Vault (demo) on EKS

The Jenkins pipeline installs Vault via Helm in **dev mode** (single pod, in-memory).

### Why dev mode?
This assessment repo does not include production-grade prerequisites (TLS certs, storage class, HA setup).
For production, switch to HA + persistent storage + TLS.

### Using Vault Agent Injector (example)
After Vault is installed with `injector.enabled=true`, you can annotate a pod to inject secrets.
See HashiCorp docs for full configuration.


