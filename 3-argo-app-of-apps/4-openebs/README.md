# Note

Apply the patches with talosctl to enable ebs things

``` bash
talosctl patch machineconfig -n 10.10.8.12 --patch @patch-cp.yaml
talosctl patch machineconfig -n 10.10.8.12 --patch @patch.yaml
talosctl patch machineconfig -n 10.10.8.13 --patch @patch.yaml
talosctl patch machineconfig -n 10.10.8.14 --patch @patch.yaml
talosctl -n 10.10.8.12 service kubelet restart
talosctl -n 10.10.8.13 service kubelet restart
talosctl -n 10.10.8.14 service kubelet restart
```
https://www.talos.dev/v1.9/kubernetes-guides/configuration/storage/
