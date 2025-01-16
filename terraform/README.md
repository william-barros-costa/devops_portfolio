Terraform 
=========

# Requirements

T./helm/his tutorial takes into consideration you have already installed the following tools:
- AWS Cli (version: >= 2)
- Kubernetes (version: >=1.32.1)
- Terraform (version: >=1.10.4)

*Note:* Versions above the ones specified should safely work but, there is a possibility of them introducing breaking changes.

# Installation

To setup AWS before you run terrafom you will need to do the following:
1. Create an AWS account;
2. Add an user to IAM;
3. Create an Access key;
4. Create an S3 Bucket;
5. Create a DynamoDB;
6. Run Terraform.


## Create an AWS account

Go to [!AWS Sign up page](https://signin.aws.amazon.com/signup?request_type=register) and follow the formulary to create an account. Be sure to enable two-factor authentication to ensure your account is safer.

## Add an user to IAM

Inside your account go to Identity and Access Management and create an user with enough permissions to manage your Cluster. If you just want to try AWS you can opt for giving AdministratorAccess to your user (but I push heavily against this solution)

## Create an Access key

After creating your user, open its details and navigate to **Access Keys** inside the **Security Credentials** tab. In here you can create an access key that will be used to setup our aws cli client. Remember to choose strong credentials and save them in a password manager. When you finish creating this key you can go to the terminal and insert the following:

```bash
aws configure
```

It will interactively prompt the credentials needed to setup your aws client.

## Create an S3 Bucket

We use S3 bucket to save terraform state object. To do this just navigate to Scalable Storage in the Cloud (also known as S3) and create a new bucket. This bucket should have **Object Lock** enabled. 

*Note:* If you failed to enable object lock just open you S3 bucket's definitions and enable it under *Properties > Object Lock*.

## Create a DynamoDB

To ensure each user of Terraform does not change the Infrastructure simmultaneous we will require a Terraform to lock the state while running. To do so, we will create a DynamoDB that allows locking of state. You can achieve this by going to DynamoDB on AWS website and creating a new table. This table should only have the Table name you want and the *Partition Key:* LockId.

## Run Terraform

With everything setup we can now update our [!Provider](terraform/provider.tf) with our infrastructure variables 

```tf
  backend "s3" {
    bucket = "<your_bucket_name>"
    key = "state/terraform.state"
    region = "us-east-1"
    dynamodb_table = "<your_dynamodb_table_name>"
  }
```
We can now setup our infrastructure with:

```bash
terraform init
terraform apply
>
```


# House Cleaning

To destroy your infrastructure make sure to run `terraform destroy`, and delete your dynamoDB and S3 bucket. 

