resource "google_compute_address" "static_ip" {
  name         = "static-address"
  address_type = "EXTERNAL"
  region       = var.location
}

resource "random_pet" "vm_name" {
  length = 2
  separator = "-"
}

resource "google_compute_instance" "compute_instance" {
  name           = random_pet.vm_name.id
  machine_type   = var.machine_type
  zone           = var.main_availability_zone
  can_ip_forward = true

  scheduling {
    preemptible                 = true
    automatic_restart           = false
    provisioning_model          = var.provisioning_model
    instance_termination_action = var.instance_termination_action
  }

  guest_accelerator {
    type  = var.guest_accelerator
    count = var.guest_accelerator_count
  }

  boot_disk {
    # kms_key_self_link = module.gcp-tf-base.google_kms_crypto_key_id
    initialize_params {
      image = var.os_image
      type  = var.disk_type
      size  = var.disk_size
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.big_robot_email
    scopes = ["cloud-platform"]
  }

  metadata = {
    user-data = file("user-data.yaml")
  }

  tags = ["web", "ssh"]
}
