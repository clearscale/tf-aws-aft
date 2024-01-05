
# terraform-state 


## High Level Steps

1. Perform terraform init
```
Perform init
terraform init
```


2. Terraform apply
```
terraform apply
```

3. Migrate local state to s3
```
terraform init -force-copy
```


See https://github.com/cloudposse/terraform-aws-tfstate-backend#usage