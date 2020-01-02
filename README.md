# ocp-testlabs
## Variables and uses
* terraform_dir: Define directory to configure terraform project.
  qcow2_image: Base qcow2 image to deploy systems
  base_image: The base image to clone as main disks for systems
  network_name: Libvirt network for VMs
  multi_master: If you want to deploy OCP in HA
  master_cpu: Number of vCPU for master machines
  master_memory: Memory in MB for master machines
  nodes_cpu: Number of vCPU for node machines
  nodes_memory: Memory in MB for node machines
  nodes_count: Number of nodes to create
