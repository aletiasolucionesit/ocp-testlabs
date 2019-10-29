# Instructions to deploy OpenShift

## Getting keys
1. Go to [OpenShift install page](https://cloud.redhat.com/openshift/install) and choose *Bare Metal*
2. Create ssh keys if they are not created before `ssh-keygen`
3. Download pull secret
4. Create the install config file inside openshift-install

```bash
cat <<EOF> install-config.yaml
apiVersion: v1
baseDomain: labs
compute:
- hyperthreading: Enabled
  name: worker
  platform: {}
  replicas: 0
controlPlane:
  hyperthreading: Enabled
  name: master
  platform: {}
  replicas: 1
metadata:
  creationTimestamp: null
  name: essi
networking:
  clusterNetwork:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  networkType: OpenShiftSDN
  serviceNetwork:
  - 172.30.0.0/16
platform:
  none: {}
pullSecret: '<INSERT_YOUR_PULL_SECRET_HERE>'
sshKey: '<INSERT_YOUR_PUBLIC_SSH_KEY_HERE>'
```

5. Create a hardlink from install-config.yaml `ln install-config.yaml install-config.yaml.hardlink`

 This is required becauses next command delete this file

6. Create the ignition files: `./openshift-install create ignition-configs`
7. Copy ignition files to www machine inside **/var/www/html/ignition**
8. Run the installer `./openshift-install --dir=<installation_directory> wait-for bootstrap-complete --log-level info`
