# Lesson 15 — Terraform Modules (Yandex Cloud)

## Modules
1) `modules/vpc_subnets_data` (data-only):
   - Reads all subnets in selected VPC
   - Outputs list of subnets and subnet ids grouped by zone

2) `modules/vm_auto_subnet`:
   - Creates a VM in selected VPC and Zone
   - Subnet is chosen automatically based on the provided Zone

## Run
```bash
cd lesson15
terraform init
terraform plan
# optional (paid): terraform apply
# cleanup: terraform destroy
```
