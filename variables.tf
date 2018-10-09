variable "access_key" {}
variable "secret_key" {}

variable "region"{
    default = "eu-central-1"
    description = "Region of my VPC"
}

variable "amis"{
    type = "map"
    default = {
        "eu-central-1" = "ami-06761466b07a8dbc0"
        "eu-west-1" = "ami-070acd5129abb8961"
        "eu-west-2" = "ami-0e5de816bb166040f"
        "eu-west-3" = "ami-00a2b63d748ffa09f"
    }
    description = "Mapping the AMI with the region of my VPC"
}

variable "private_key_path"{
    default = "~/.ssh/id_rsa"
}
#[Debian Server Variables]
variable "debian_key_name"{
    default = "ezequiel_key"
}
variable "instance_username"{
    default = "admin"
}

#[DataBase Variables]
variable "RDS_username"{
    default = "enter databse username"
}

variable "RDS_password"{
    default = "enter db password"
}
