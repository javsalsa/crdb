variable "vpc" {
  type = string
}

variable "subnet1" {
  type = string
}

variable "subnet2" {
  type = string
}

variable "subnet3" {
  type = string
}

variable "sshkey" {
  type = string
}

variable "region" {
  type = string
}

variable "rootvolumesize" {
  type = number
}

variable "datavolumesize" {
  type = number
}

variable "ami" {
  type = string
}

variable "instancetype" {
  type = string
}

variable "sg-cidr-ssh" {
  type = list
}

variable "sg-cidr-crdbnodes" {
  type = list
}

variable "sg-cidr-dbconsole" {
  type = list
}
