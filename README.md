# Mastino

Configuration for local DataCite development. Uses [Minikube](https://github.com/kubernetes/minikube) to run a local [Kubernetes](https://kubernetes.io/) cluster to manage containerized applications, and [Terraform](https://www.terraform.io/) for configuration.

![Mastino, image from https://pixabay.com/en/bordeaux-mastiff-dog-animal-white-869036/](bordeaux-869036_640.jpg)

## Installation

Install Minikube and Terraform.

### Mac

Use Homebrew.

```
brew install docker-machine-driver-xhyve
brew cask install minikube
brew install terraform
eval $(minikube docker-env)
```

### All platforms

Start Kubernetes cluster, check the IP address, and go to the dashboard (at http://IP_ADDRESS:30000):

```
minikube start
minikube ip
minikube dashboard
```

Initialize Terraform with

```
terraform init
```

## Configuration

Use Terraform to configure your Kubernetes cluster, using the terraform configuration files (*.tf) in this repo.

```
terraform plan
terraform apply
```

## Use

Access the services by service name, e.g.

```
minikube service data
```
