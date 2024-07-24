variable "tools" {
  default = {

    github-runner = {
      instance_type = "t3.small"
      policy_name = [
        "AdministratorAccess"
      ]
    }

    vault = {
      instance_type = "t3.small"
      policy_name   = []
      ports = [8200]
    }

  }
}

variable "hosted_zone_id" {
  default = "Z0153757236UOMMSDCGKR"
}