SHELL:=/bin/bash
REPO := eks-cluster

docker_build_local:
	docker build -t eks-demo-app .

docker_run_local:
	docker run -it -d --name eks-cluster-demo-app -p 8080:8080 eks-demo-app:latest


.PHONY: docker_build_local docker_run_local
