# EKS Cluster

### Setup

* `terraform init`
* `terraform apply`


##### To connect to Cluster
`aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)`

SSH Onto one of your Nodes (Which are just EC2 instances, that the Cluster is using as Compute resources)

* `ssh -i "NodegGroupSSHKey.pem" root@ec2-44-195-25-170.compute-1.amazonaws.com`
* * `ssh -i "node_group_key.pem" root@ec2-44-195-25-170.compute-1.amazonaws.com`
3.85.176.210
