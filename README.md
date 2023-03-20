# CFE-32 Kubernetes log forwarder

Container image that uses rsyslog to send kubernetes logs using RELP.

## Example configuration

Example kubernetes files are in `example/`

### Create configMap

Configuration for cfe-32 is in `config/config.json`.

Configuration keys to edit:

- `kubernetes.url`
    - The URL of the Kubernetes API server. Example: https://localhost:8443.
- `kubernetes.labels.hostname.prefix`
    - What the hostname will be prefixed with.
    - Example: `kube-demo-` will turn `host-abc` into `kube-demo-host-abc`.
- `kubernetes.labels.hostname.label`
    - Label key that sets the hostname.
- `kubernetes.labels.hostname.fallback`
    - Fallback value for hostname if no label is found.
- `kubernetes.labels.appname.prefix`
    - What the appname will be prefixed with.
    - Example: `kube-demo-` will turn `example-app` into `kube-demo-example-app`.
- `kubernetes.labels.appname.label`
    - Label key that sets the appname.
- `kubernetes.labels.appname.fallback`
    - Fallback value for appname if no label is found.
- `kubernetes.logfiles`
    - Which files are ingested
    - Default `*_default_*` will read all pods and containers from namespace `default`
    - Use `*` if you want all pods from all namespaces, or `pod_default_*` for only `pod` from namespace `default` etc.
- `omrelp.target`
    - Target address where to send the data using RELP.
- `omrelp.port`
    - Target port where to send the data using RELP.

After editing you can create the configMap with following command:

`kubectl create configmap cfe-32-configmap --from-file=config/config.json`

### Volumes

Create the following PersitentVolumeClaim:

  - `cfe-32-statefiles-claim`
    - Statefiles are stored here.
    - Should be persistent and able to survive container restarts.

There is an example `example-pvc.json` that creates PersitentVolumeClaims and uses HostPath `/mnt/cfe-32/statefiles` for data storage.

That can be used with the following command:

`kubectl apply -f example-pvc.json`.

### Permissions

The demo pod definition `demo.json` creates `mmkubernetes` service account by default and it will only be able to access pods in `default` namespace.

Edit pod items if different or wider permissions are required.


## Usage

Once `cfe-32-configmap` configMap and `cfe-32-statefiles-claim` PersistentVolumeClaim are made, you can simply run the following command to launch the pod:

`kubectl apply -f demo.json`
