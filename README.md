# GCP-TF-VM

Create a spot-instance on GCP with optional GPU.


## Usage

```hcl
module "gcp-tf-vm" {

  source = "./gcp-tf-base"

  project_id                  = var.project_id
  location                    = var.location
  main_availability_zone      = var.main_availability_zone
  big_robot_email             = var.big_robot_email
  machine_type 		      = "n1-standard-8"
  guest_accelerator 	      = "nvidia-tesla-v100"
  guest_accelerator_count     = 1
  provisioning_model 	      = "SPOT"
  instance_termination_action = "STOP"
  os_image                    = "ubuntu-os-cloud/ubuntu-2204-lts"
  disk_type                   = "pd-ssd"
  disk_size                   = 64
}
```
