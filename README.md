# Create Azure Kubernete cluster - Microsoft example
https://docs.microsoft.com/pt-br/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks


# Set environment

## Create container in storage account to put tfstate files
```
az storage container create -n tfstate --account-name <YourAzureStorageAccountName> --account-key <YourAzureStorageAccountKey>
```

## Configure environment variables
```
https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html


# k8s service principal
export TF_VAR_client_id="client_id"
export TF_VAR_client_secret="client_secret_value"


# Terraform
export ARM_CLIENT_ID="client_id"
export ARM_CLIENT_SECRET="client_secret_value"
export ARM_SUBSCRIPTION_ID="subscription_id"
export ARM_TENANT_ID="tenant_id"


# Test service principal login
$ az login --service-principal -u CLIENT_ID -p CLIENT_SECRET_VALUE --tenant TENANT_ID
$ az vm list-sizes --location westus
```

# Execute terraform
```
terraform init

or

terraform init -backend-config="storage_account_name=<YourAzureStorageAccountName>" -backend-config="container_name=tfstate" -backend-config="access_key=<YourStorageAccountAccessKey>" -backend-config="key=codelab.microsoft.tfstate"

terraform plan -out out.plan

terraform apply out.plan
*** There will be an error, then from Azure control painel delete resource group "azure-k8stest" and execute "terraform apply out.plan" again.
```


# Deploy a Kubernetes example
https://docs.microsoft.com/pt-br/azure/aks/tutorial-kubernetes-prepare-app

## Git clone the project
```
git clone https://github.com/Azure-Samples/azure-voting-app-redis.git
docker-compose up -d
docker-compose down
```

## Login into acr
```
az acr login --name acredtroleis
```


## Show acr name
```
az acr list --output table
az acr list --resource-group azure-k8stest --query "[].{acrLoginServer:loginServer}" --output table
```


## Docker tag and push
```
docker tag tiangolo/uwsgi-nginx-flask:python3.6 acredtroleis.azurecr.io/azure-vote-front:v1
docker push acredtroleis.azurecr.io/azure-vote-front:v1

docker tag redis acredtroleis.azurecr.io/azure-vote-redis:v1
docker push acredtroleis.azurecr.io/azure-vote-redis:v1
```


## List images in registry
```
az acr repository list --name acredtroleis --output table
```


## See tags for specific images
```
az acr repository show-tags --name acredtroleis --repository azure-vote-front --output table
```


## List aks
```
az aks list --output table
```


## Connect to cluster using kubeclt
```
az aks get-credentials --resource-group azure-k8stest --name k8stest
```

## Show nodes
```
kubectl get nodes
```

## In yaml file configure the property image according to acr name and image name
```
az acr list --resource-group azure-k8stest --query "[].{acrLoginServer:loginServer}" --output table
```


## Deploy the application
```
kubectl apply -f azure-vote-all-in-one-redis.yaml
```


## Test the application
```
kubectl get service azure-vote-front --watch
```