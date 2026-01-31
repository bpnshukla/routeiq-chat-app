# PowerShell script to deploy RouteIQ Chat App to Azure
# This script creates all necessary Azure resources and deploys the application

param(
    [string]$ResourceGroupName = "AZ-RG-Team24",
    [string]$AppName = "routeiq-chat-app",
    [string]$Location = "uaenorth",
    [string]$PlanName = "routeiq-chat-app-plan",
    [string]$Sku = "B1"
)

Write-Host "🚀 Starting Azure deployment for RouteIQ Chat App..." -ForegroundColor Green

# Check if Azure CLI is installed
try {
    $azVersion = az --version 2>&1
    Write-Host "✓ Azure CLI found" -ForegroundColor Green
} catch {
    Write-Host "❌ Azure CLI not found. Please install it first:" -ForegroundColor Red
    Write-Host "   https://aka.ms/installazurecliwindows" -ForegroundColor Yellow
    exit 1
}

# Check if logged in
try {
    $account = az account show 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "🔐 Please login to Azure..." -ForegroundColor Yellow
        az login
    } else {
        Write-Host "✓ Already logged in to Azure" -ForegroundColor Green
    }
} catch {
    Write-Host "🔐 Please login to Azure..." -ForegroundColor Yellow
    az login
}

# Set subscription if needed
Write-Host "`n📋 Setting subscription..." -ForegroundColor Cyan
az account set --subscription "cd59df9d-15fd-407f-bd94-4e41b2cc5b05"

# Check if resource group exists
Write-Host "`n📦 Checking resource group..." -ForegroundColor Cyan
$rgExists = az group exists --name $ResourceGroupName 2>&1
if ($rgExists -eq "false") {
    Write-Host "Creating resource group: $ResourceGroupName" -ForegroundColor Yellow
    az group create --name $ResourceGroupName --location $Location
} else {
    Write-Host "✓ Resource group exists: $ResourceGroupName" -ForegroundColor Green
}

# Check if App Service Plan exists
Write-Host "`n📋 Checking App Service Plan..." -ForegroundColor Cyan
$planExists = az appservice plan show --name $PlanName --resource-group $ResourceGroupName 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Creating App Service Plan: $PlanName" -ForegroundColor Yellow
    az appservice plan create `
        --name $PlanName `
        --resource-group $ResourceGroupName `
        --location $Location `
        --sku $Sku `
        --is-linux
    Write-Host "✓ App Service Plan created" -ForegroundColor Green
} else {
    Write-Host "✓ App Service Plan exists: $PlanName" -ForegroundColor Green
}

# Check if Web App exists
Write-Host "`n🌐 Checking Web App..." -ForegroundColor Cyan
$appExists = az webapp show --name $AppName --resource-group $ResourceGroupName 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Creating Web App: $AppName" -ForegroundColor Yellow
    az webapp create `
        --resource-group $ResourceGroupName `
        --plan $PlanName `
        --name $AppName `
        --runtime "NODE:20-lts"
    Write-Host "✓ Web App created" -ForegroundColor Green
} else {
    Write-Host "✓ Web App exists: $AppName" -ForegroundColor Green
}

# Configure environment variables
Write-Host "`n⚙️  Configuring environment variables..." -ForegroundColor Cyan
az webapp config appsettings set `
    --resource-group $ResourceGroupName `
    --name $AppName `
    --settings `
        AZURE_EXISTING_AGENT_ID="RouteIQ-Agent1:4" `
        AZURE_ENV_NAME="agents-playground-3548" `
        AZURE_LOCATION="uaenorth" `
        AZURE_SUBSCRIPTION_ID="cd59df9d-15fd-407f-bd94-4e41b2cc5b05" `
        AZURE_EXISTING_AIPROJECT_ENDPOINT="https://team24-foundry.services.ai.azure.com/api/projects/proj-default" `
        AZURE_EXISTING_AIPROJECT_RESOURCE_ID="/subscriptions/cd59df9d-15fd-407f-bd94-4e41b2cc5b05/resourceGroups/AZ-RG-Team24/providers/Microsoft.CognitiveServices/accounts/team24-foundry/projects/proj-default" `
        AZURE_EXISTING_RESOURCE_ID="/subscriptions/cd59df9d-15fd-407f-bd94-4e41b2cc5b05/resourceGroups/AZ-RG-Team24/providers/Microsoft.CognitiveServices/accounts/team24-foundry" `
        PORT=3001 `
        NODE_ENV=production `
        AZD_ALLOW_NON_EMPTY_FOLDER=true `
        SCM_DO_BUILD_DURING_DEPLOYMENT=true

Write-Host "✓ Environment variables configured" -ForegroundColor Green

# Set startup command
Write-Host "`n🔧 Setting startup command..." -ForegroundColor Cyan
az webapp config set `
    --resource-group $ResourceGroupName `
    --name $AppName `
    --startup-file "npm start"

Write-Host "✓ Startup command configured" -ForegroundColor Green

# Enable Managed Identity
Write-Host "`n🔐 Enabling Managed Identity..." -ForegroundColor Cyan
$identity = az webapp identity assign `
    --resource-group $ResourceGroupName `
    --name $AppName `
    --query principalId -o tsv

if ($identity) {
    Write-Host "✓ Managed Identity enabled (Principal ID: $identity)" -ForegroundColor Green
    
    # Grant Cognitive Services User role
    Write-Host "`n🔑 Granting permissions to Managed Identity..." -ForegroundColor Cyan
    $scope = "/subscriptions/cd59df9d-15fd-407f-bd94-4e41b2cc5b05/resourceGroups/AZ-RG-Team24/providers/Microsoft.CognitiveServices/accounts/team24-foundry"
    
    az role assignment create `
        --assignee $identity `
        --role "Cognitive Services User" `
        --scope $scope `
        --output none
    
    Write-Host "✓ Permissions granted" -ForegroundColor Green
}

# Build the application
Write-Host "`n🔨 Building application..." -ForegroundColor Cyan
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Build successful" -ForegroundColor Green

# Get deployment URL
Write-Host "`n📤 Getting deployment URL..." -ForegroundColor Cyan
$deploymentUrl = az webapp deployment source config-local-git `
    --resource-group $ResourceGroupName `
    --name $AppName `
    --query url -o tsv

Write-Host "`n✅ Configuration complete!" -ForegroundColor Green
Write-Host "`n📝 Next steps:" -ForegroundColor Yellow
Write-Host "1. Add the Azure remote:" -ForegroundColor White
Write-Host "   git remote add azure $deploymentUrl" -ForegroundColor Cyan
Write-Host "`n2. Deploy your code:" -ForegroundColor White
Write-Host "   git push azure main" -ForegroundColor Cyan
Write-Host "`n3. Your app will be available at:" -ForegroundColor White
Write-Host "   https://$AppName.azurewebsites.net" -ForegroundColor Cyan
Write-Host "`n💡 Tip: You can also deploy via Azure Portal → Deployment Center" -ForegroundColor Yellow

