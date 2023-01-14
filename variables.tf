variable "machine_type" {
  type = string
}

variable "guest_accelerator" {
  type = string
}

variable "guest_accelerator_count" {
  type = number
}

variable "provisioning_model" {
  type = string
}

variable "instance_termination_action" {
  type = string
}

variable "os_image" {
  type = string
}

variable "disk_type" {
  type = string
}

variable "disk_size" {
  type = number
}

variable "main_availability_zone" {
  type = string
}

variable "location" {
  type = string
}

variable "project_id" {
  type = string
}

variable "big_robot_email" {
  type = string
}
