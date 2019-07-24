# Terraform Test
Background
This is to test your understanding of infrastructure as a code. Port numbers can be arbitrary, as long as they all line up. We should be able to generate a valid plan using an AWS provider; however the infrastructure does not need to work to the point of being spun up. Feel free to make up any necessary details as need be.
Task & Requirements
Using the AWS Provider, build the following:
Fleet of application server instances with AWS ELB
Fleet of worker server instances
Aurora database cluster (MySQL Engine, at least 3 instances)
These should be contained in a VPC with the appropriate security groups and subnets.
Bonus:
Sensible directory and file structure
Provide for mapping cloud assets via AWS API (tags)
Cloudfront
Terraform modules
"Precompilation" of terraform code files to allow for more advanced topology patterns.
Other creative solutions/ideas