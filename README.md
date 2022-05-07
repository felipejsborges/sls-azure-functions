## Pre-requisites

- [Node.js](https://nodejs.org/en/download/)
- [Azure account](https://azure.microsoft.com/en-us/free/) and [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Serverless CLI: `npm install -g serverless`

## Authenticate to Azure

```bash
# Login
az login

# Get subscription ID
az account list
# A list of objects will print on console.
# Pick the "id" field of the account you want to use, and set subscription ID
az account set --subscription <id>
```

## Provision needed resources

```bash
terraform init && terraform apply
# type yes and press enter when prompted
```

## Fill [vars.json](vars.json).

[Access Service Bus Namespaces](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.ServiceBus%2Fnamespaces) > Click on desired namespace > Shared access policies > RootManageSharedAccessKey > Get the connection string and set on [vars.json](vars.json). Then repeat this step for [Event Hubs](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.EventHub%2Fnamespaces).

## Install dependencies

```bash
npm install
```

## Deploy Function App, Azure Functions, and other needed resources

```bash
serverless deploy --region eastus --resourceGroup festival-ms-rg --verbose
```

Test the deployed function app accessing the URL prompted on console.

For checking results of the entire Function App, access [Azure Portal](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.Web%2Fsites/kind/functionapp).

## Delete all resources, to prevent leaving orphaned resources

```bash
terraform destroy
# type yes and press enter when prompted
```
