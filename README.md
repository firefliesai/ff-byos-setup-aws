# Setup

To setup byos, you need to do the following

- Create a new AWS Account. You can re-use an existing account but it is advised to create a new account just for byos.
- Create access id and secret key to run terraform. These keys stays with the customer and does not come to the fireflies team. This is exclusively for running the terraform commands
- Clone the repository
- Set all the necessary variables in terraform.tfvars file
- Run terraform init
- Run terraform plan
- Run terraform apply
- Verify the changes
- Enter yes
- Wait for the configuration to apply to your project

Make sure you save the terraform.tfstate someplace safe after the apply command is successful. 

Note: The terraform configuration creates a new aws bucket for this purpose. However, if you want to re-use an existing bucket, you can do so by either importing the bucket into terraform. 


# Variables to set

At the time of writing, customers are required to set the following variables in the terraform.tfvars file

- bucket_name 
- access_key
- secret_key

# File Structure

- `bucket.tf` : The bucket configuration. This is intentionally left vague to let customers decide their settings  
- `main.tf` : The entrypoint for AWS Cloud Configuration. However, the configuration is controlled by variables  
- `permissions.tf` : The file that defines permissions need for the operation  
- `search.tf` : The bucket policy that lets Fireflies search index your meetings inside your bucket (see below)  
- `terraform.tfvars` : All the variables required for the configuration to work. Customers are encouraged to change the necessary environment variables in this file to their project specific ones  


# Permissions Requested

Fireflies requires the following permissions on AWS Cloud Storage to successfully run. 

```
s3:PutObject
s3:DeleteObject
s3:GetObject
s3:GetObjectAcl
s3:ListBucket
s3:PutObjectAcl


s3:ListBucket
s3:GetBucketAcl
s3:GetBucketPolicy
```

These permissions are not wildcard permissions and are bound to the bucket specified by the customer.  This is defined in the condition section of the permissions.tf file


# Search index in your bucket

Fireflies keeps the search index for your workspace in your bucket, under the `tpuf/` prefix. The index is stored by Turbopuffer, our search provider, whose AWS role reads and writes it. `search.tf` adds a bucket policy that grants that role these permissions, limited to `tpuf/`, and denies it any ACL change or public ACL there:

```
s3:ListBucket   (keys under tpuf/ only)
s3:GetObject    (tpuf/*)
s3:PutObject    (tpuf/*)
s3:DeleteObject (tpuf/*)
```

The index is stored in your bucket, but Turbopuffer serves it from AWS `us-east-1`. With a bucket in another region, index data is read into `us-east-1` and you pay cross-region transfer for it.

`aws_s3_bucket_policy` replaces the whole bucket policy. If your bucket already has one, add these two statements to it instead of applying `search.tf` as is. A bucket encrypted with a customer-managed KMS key is not supported by this guide yet: the role would need access to that key on both your side and Turbopuffer's. Talk to the Fireflies team before using one.
