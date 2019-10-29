# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
}


# We fetch the latest ubuntu release image from their mirrors

resource "libvirt_volume" "os_image" {
  name = "os_image"
  source = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1907.qcow2"
}

resource "libvirt_volume" "ocp-dns-qcow2" {
  name = "ocp-dns-qcow2"
  base_volume_id = "${libvirt_volume.os_image.id}"
}

resource "libvirt_volume" "ocp-lb-qcow2" {
  name = "ocp-lb-qcow2"
  base_volume_id = "${libvirt_volume.os_image.id}"
}

resource "libvirt_volume" "ocp-www-qcow2" {
  name = "ocp-www-qcow2"
  base_volume_id = "${libvirt_volume.os_image.id}"
}

resource "libvirt_volume" "ocp-bootstrap-qcow2" {
  name = "ocp-bootstrap-qcow2"
  size = "1073741824"
}

resource "libvirt_volume" "ocp-master-qcow2" {
  name = "ocp-master-qcow2"
  size = "1073741824"
}

resource "libvirt_volume" "ocp-worker-1-qcow2" {
  name = "ocp-worker-1-qcow2"
  size = "1073741824"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/cloud_init.cfg")}"
}

data "template_file" "network_config" {
  template = "${file("${path.module}/network_config.cfg")}"
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = "${data.template_file.user_data.rendered}"
  network_config = "${data.template_file.network_config.rendered}"
}


# Create the machines
resource "libvirt_domain" "ocp-dns" {
  name   = "ocp-dns"
  memory = "2048"
  vcpu   = 1

  cloudinit = "${libvirt_cloudinit_disk.commoninit.id}"

  network_interface {
    network_name = "openshift-dns"
    hostname       = "dns.essi.labs}"
    addresses      = ["192.168.130.10"]
    mac            = "aa:bb:cc:dd:ee:10"
    wait_for_lease = true
  }
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
  disk {
    volume_id = "${libvirt_volume.ocp-dns-qcow2.id}"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}


resource "libvirt_domain" "ocp-lb" {
  name   = "ocp-lb"
  memory = "2048"
  vcpu   = 1

  cloudinit = "${libvirt_cloudinit_disk.commoninit.id}"

  network_interface {
    network_name = "ocp-cluster"
    hostname       = "loadbalancer"
    addresses      = ["192.168.131.10"]
    mac            = "bb:cc:dd:ee:aa:10"
    wait_for_lease = true
  }
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
  disk {
    volume_id = "${libvirt_volume.ocp-lb-qcow2.id}"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

resource "libvirt_domain" "ocp-www" {
  name   = "ocp-www"
  memory = "2048"
  vcpu   = 1

  cloudinit = "${libvirt_cloudinit_disk.commoninit.id}"

  network_interface {
    network_name = "ocp-cluster"
    hostname       = "www"
    addresses      = ["192.168.131.20"]
    mac            = "bb:cc:dd:ee:aa:20"
    wait_for_lease = true
  }
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
  disk {
    volume_id = "${libvirt_volume.ocp-www-qcow2.id}"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

resource "libvirt_domain" "ocp-bootstrap" {
  name   = "ocp-bootstrap"
  memory = "4096"
  vcpu   = 2

  #cloudinit = "${libvirt_cloudinit_disk.commoninit.id}"

  network_interface {
    network_name = "ocp-cluster"
    hostname       = "bootstrap"
    addresses      = ["192.168.131.11"]
    mac            = "bb:cc:dd:ee:aa:11"
    wait_for_lease = true
  }
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
  disk {
    volume_id = "${libvirt_volume.ocp-bootstrap-qcow2.id}"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

resource "libvirt_domain" "ocp-master" {
  name   = "ocp-master"
  memory = "6144"
  vcpu   = 4

  #cloudinit = "${libvirt_cloudinit_disk.commoninit.id}"

  network_interface {
    network_name = "ocp-cluster"
    hostname       = "master"
    addresses      = ["192.168.131.12"]
    mac            = "bb:cc:dd:ee:aa:12"
    wait_for_lease = true
  }
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
  disk {
    volume_id = "${libvirt_volume.ocp-master-qcow2.id}"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

resource "libvirt_domain" "ocp-worker-1" {
  name   = "ocp-worker-1"
  memory = "6144"
  vcpu   = 4

  #cloudinit = "${libvirt_cloudinit_disk.commoninit.id}"

  network_interface {
    network_name = "ocp-cluster"
    hostname       = "worker-1"
    addresses      = ["192.168.131.13"]
    mac            = "bb:cc:dd:ee:aa:13"
    wait_for_lease = true
  }
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
  disk {
    volume_id = "${libvirt_volume.ocp-worker-1-qcow2.id}"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

