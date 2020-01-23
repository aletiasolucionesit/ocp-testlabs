# Instructions to deploy OpenShift

## Getting keys

1. Create a hardlink from install-config.yaml `ln install-config.yaml install-config.yaml.hardlink`

 This is required becauses next command delete this file

2. Create the ignition files: `./openshift-install create ignition-configs`
3. Copy ignition files to www machine inside **/var/www/html/ignition**
4. Run the installer `./openshift-install wait-for bootstrap-complete --log-level debug`
