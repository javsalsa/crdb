
# CockroachDB 3 Node Cluster in AWS

## What you'll build
###### Use this Terraform Project to set up the following on AWS:

* iam policy
* iam role
* iam instance profile
* security group
* ebs volumes (3)
* ec2 instance (3)
* ebs volume attachment (3)
* network load balancer
* load balancer listener (2)
* target group (2)
* target group attachment (6)

## How to deploy in private AWS account
1. Create a file named terraform.tfvars with contents as below. ***Update the variable values as required***
```
vpc = "vpc-xxxxx"
subnet1 = "subnet-xxxxxx"
subnet2 = "subnet-xxxxxxx"
subnet3 = "subnet-xxxxx"
sshkey = "xxxxxx"
region = "xxxxxx"
rootvolumesize = "xxx"
datavolumesize = "xxxx"
ami = "ami-xxxxxx"
instancetype = "xxxxxx"
sg-cidr-ssh = ["your ip /32"]
sg-cidr-crdbnodes = ["xxxxxx","xxxxxx"]
sg-cidr-dbconsole = ["xxxxxx","xxxxxx"]
```
2. Initialize
```

terraform init
```
3. Plan
```

terraform plan
```
4. Review the plan and apply if no changes needed
```

terraform apply
```
