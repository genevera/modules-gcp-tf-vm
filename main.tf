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
  machine_type   = "n1-standard-8"
  zone           = var.main_availability_zone
  can_ip_forward = true

  scheduling {
    preemptible                 = true
    automatic_restart           = false
    provisioning_model          = "SPOT"
    instance_termination_action = "STOP"
  }

  guest_accelerator {
    type  = "nvidia-tesla-v100"
    count = 1
  }

  boot_disk {
    # kms_key_self_link = module.gcp-tf-base.google_kms_crypto_key_id
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      type  = "pd-ssd"
      size  = 64
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
