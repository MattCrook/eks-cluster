# EKS Cluster

### Setup

* `terraform init`
* `terraform apply`


##### To connect to Cluster
`aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)`

SSH Onto one of your Nodes (Which are just EC2 instances, that the Cluster is using as Compute resources)

Example:
* `ssh -i "node_group_key.pem" root@ec2-44-195-25-170.compute-1.amazonaws.com`

Build Docker image and Run App in Docker container locally

* `docker build -t eks-demo-app .`


### Notes

Installed for Demo App:

```
npm init -y
npm i -D nodemon
npm i pug
npm i -D browser-sync
browser-sync init
npm i express
```
