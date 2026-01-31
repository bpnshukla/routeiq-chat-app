#!/bin/bash

# Azure Web App Deployment Script
# This script helps deploy the RouteIQ chat application to Azure Web App

echo "🚀 Starting Azure Web App deployment..."

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI is not installed. Please install it from https://aka.ms/InstallAzureCLI"
    exit 1
fi

# Check if logged in
if ! az account show &> /dev/null; then
    echo "🔐 Please login to Azure..."
    az login
fi

# Set variables
RESOURCE_GROUP="AZ-RG-Team24"
APP_NAME="routeiq-chat-app"
LOCATION="uaenorth"

# Check if resource group exists
if ! az group show --name $RESOURCE_GROUP &> /dev/null; then
    echo "📦 Creating resource group..."
    az group create --name $RESOURCE_GROUP --location $LOCATION
fi

# Check if App Service Plan exists, create if not
PLAN_NAME="${APP_NAME}-plan"
if ! az appservice plan show --name $PLAN_NAME --resource-group $RESOURCE_GROUP &> /dev/null; then
    echo "📋 Creating App Service Plan..."
    az appservice plan create \
        --name $PLAN_NAME \
        --resource-group $RESOURCE_GROUP \
        --location $LOCATION \
        --sku B1 \
        --is-linux
fi

# Check if Web App exists, create if not
if ! az webapp show --name $APP_NAME --resource-group $RESOURCE_GROUP &> /dev/null; then
    echo "🌐 Creating Web App..."
    az webapp create \
        --resource-group $RESOURCE_GROUP \
        --plan $PLAN_NAME \
        --name $APP_NAME \
        --runtime "NODE:20-lts"
fi

# Set environment variables
echo "⚙️  Configuring environment variables..."
az webapp config appsettings set \
    --resource-group $RESOURCE_GROUP \
    --name $APP_NAME \
    --settings \
        AZURE_EXISTING_AGENT_ID="RouteIQ-Agent1:4" \
        AZURE_ENV_NAME="agents-playground-3548" \
        AZURE_LOCATION="uaenorth" \
        AZURE_SUBSCRIPTION_ID="cd59df9d-15fd-407f-bd94-4e41b2cc5b05" \
        AZURE_EXISTING_AIPROJECT_ENDPOINT="https://team24-foundry.services.ai.azure.com/api/projects/proj-default" \
        AZURE_EXISTING_AIPROJECT_RESOURCE_ID="/subscriptions/cd59df9d-15fd-407f-bd94-4e41b2cc5b05/resourceGroups/AZ-RG-Team24/providers/Microsoft.CognitiveServices/accounts/team24-foundry/projects/proj-default" \
        AZURE_EXISTING_RESOURCE_ID="/subscriptions/cd59df9d-15fd-407f-bd94-4e41b2cc5b05/resourceGroups/AZ-RG-Team24/providers/Microsoft.CognitiveServices/accounts/team24-foundry" \
        PORT=3001 \
        NODE_ENV=production \
        AZD_ALLOW_NON_EMPTY_FOLDER=true

# Set startup command
echo "🔧 Setting startup command..."
az webapp config set \
    --resource-group $RESOURCE_GROUP \
    --name $APP_NAME \
    --startup-file "npm start"

# Enable managed identity (recommended for production)
echo "🔐 Enabling managed identity..."
az webapp identity assign \
    --resource-group $RESOURCE_GROUP \
    --name $APP_NAME

echo "✅ Configuration complete!"
echo ""
echo "📝 Next steps:"
echo "1. Build the application: npm run build"
echo "2. Deploy using: az webapp deployment source config-local-git --name $APP_NAME --resource-group $RESOURCE_GROUP"
echo "3. Or use Azure Portal to deploy from your repository"
echo ""
echo "🌐 Your app will be available at: https://${APP_NAME}.azurewebsites.net"


