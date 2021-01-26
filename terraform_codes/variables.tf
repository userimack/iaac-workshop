# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "db_master_password" {
  description = "The master password for the database"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "petclinic"
}

variable "db_user" {
  description = "The database username to use for the database"
  type        = string
  default     = "petclinic"
}

variable "db_instance_class" {
  type    = string
  default = "db.t2.micro"
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "maintenance_window" {
  default = "Mon:06:30-Mon:07:30"
}

variable "backup_window" {
  default = "07:30-08:30"
}

variable "environment" {
  default = "prod"
}

variable "common_tags" {
  type = map(string)
  default = {
    Environment = "prod"
    Owner       = "Mahendra"
  }
}

variable "aws_region" {
  default = "us-east-1"
}

variable "public_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "private_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "ami" {
  default = "ami-0885b1f6bd170450c"
}

variable "public_key" {
  default = "~/.ssh/MyKeyPair.pub"
}

variable "private_key" {
  default = "~/.ssh/MyKeyPair.pem"
}

variable "ansible_user" {
  default = "ubuntu"
}

variable "instance_count" {
  default = "3"
}

variable "frontend_instance_type" {
  default = "t3.medium"
}

variable "backend_instance_type" {
  default = "t2.micro"
}
