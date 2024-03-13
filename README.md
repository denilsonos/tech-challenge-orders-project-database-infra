
# Terraform AWS RDS

### Requirements 
- install terraform CLI and aws CLI
- configure aws access keys vars from Security Credentials:
  > export AWS_ACCESS_KEY_ID=[your-key-id]   
  > export AWS_SECRET_ACCESS_KEY=[your-key-secret]
- configure db_user and db_password as:
  > export TF_VAR_db_user="fiap"
  > export TF_VAR_db_password="n3wpass"

### Run
```shell
  terraform init
  terraform apply
```
