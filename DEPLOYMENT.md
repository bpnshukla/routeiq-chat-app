# Azure Web App Deployment Guide

## Prerequisites

1. Azure CLI installed and configured
2. Node.js 18+ installed
3. Azure subscription with AI Foundry access
4. Application built and tested locally

## Deployment Methods

### Method 1: Azure CLI (Recommended)

#### Step 1: Run the deployment script

```bash
chmod +x azure-deploy.sh
./azure-deploy.sh
```

This script will:
- Create resource group (if needed)
- Create App Service Plan (if needed)
- Create Web App (if needed)
- Configure all environment variables
- Enable managed identity

#### Step 2: Build the application

```bash
npm run build
```

#### Step 3: Deploy using Git

```bash
# Get the Git deployment URL
az webapp deployment source config-local-git \
  --name routeiq-chat-app \
  --resource-group AZ-RG-Team24

# Add the Azure remote and push
git remote add azure <git-url-from-above>
git push azure main
```

### Method 2: Azure Portal

1. **Create Web App**:
   - Go to [Azure Portal](https://portal.azure.com)
   - Click "Create a resource" → "Web App"
   - Fill in:
     - Name: `routeiq-chat-app`
     - Runtime stack: Node 20 LTS
     - Operating System: Linux
     - Region: UAE North
     - App Service Plan: Create new or use existing

2. **Configure Environment Variables**:
   - Go to your Web App → Configuration → Application settings
   - Add all variables from `server/.env`:
     ```
     AZURE_EXISTING_AGENT_ID=RouteIQ-Agent1:4
     AZURE_ENV_NAME=agents-playground-3548
     AZURE_LOCATION=uaenorth
     AZURE_SUBSCRIPTION_ID=cd59df9d-15fd-407f-bd94-4e41b2cc5b05
     AZURE_EXISTING_AIPROJECT_ENDPOINT=https://team24-foundry.services.ai.azure.com/api/projects/proj-default
     AZURE_EXISTING_AIPROJECT_RESOURCE_ID=/subscriptions/.../projects/proj-default
     AZURE_EXISTING_RESOURCE_ID=/subscriptions/.../accounts/team24-foundry
     PORT=3001
     NODE_ENV=production
     ```

3. **Configure Startup Command**:
   - Go to Configuration → General settings
   - Startup Command: `npm start`

4. **Deploy Code**:
   - Go to Deployment Center
   - Choose your source (GitHub, Azure DevOps, Local Git, etc.)
   - Follow the deployment wizard

### Method 3: GitHub Actions (CI/CD)

1. **Set up GitHub Secret**:
   - Go to your GitHub repository → Settings → Secrets and variables → Actions
   - Add new secret: `AZURE_WEBAPP_PUBLISH_PROFILE`
   - Get the value from Azure Portal → Your Web App → Get publish profile

2. **Push to main branch**:
   ```bash
   git push origin main
   ```
   This will automatically trigger the GitHub Actions workflow defined in `.github/workflows/azure-webapps-deploy.yml`

### Method 4: Docker Container

1. **Build Docker image**:
   ```bash
   docker build -t routeiq-chat-app .
   ```

2. **Push to Azure Container Registry**:
   ```bash
   az acr create --name <registry-name> --resource-group AZ-RG-Team24 --sku Basic
   az acr login --name <registry-name>
   docker tag routeiq-chat-app <registry-name>.azurecr.io/routeiq-chat-app:latest
   docker push <registry-name>.azurecr.io/routeiq-chat-app:latest
   ```

3. **Configure Web App for Container**:
   - In Azure Portal, go to your Web App
   - Go to Deployment Center
   - Select "Container Registry" as source
   - Configure the container image

## Post-Deployment Configuration

### Enable Managed Identity

```bash
az webapp identity assign \
  --name routeiq-chat-app \
  --resource-group AZ-RG-Team24
```

### Grant Permissions

The managed identity needs permissions to access your AI Foundry resource:

```bash
# Get the principal ID
PRINCIPAL_ID=$(az webapp identity show \
  --name routeiq-chat-app \
  --resource-group AZ-RG-Team24 \
  --query principalId -o tsv)

# Grant Cognitive Services User role
az role assignment create \
  --assignee $PRINCIPAL_ID \
  --role "Cognitive Services User" \
  --scope "/subscriptions/cd59df9d-15fd-407f-bd94-4e41b2cc5b05/resourceGroups/AZ-RG-Team24/providers/Microsoft.CognitiveServices/accounts/team24-foundry"
```

### Configure CORS (if needed)

If you're accessing the API from a different domain:

```bash
az webapp cors add \
  --name routeiq-chat-app \
  --resource-group AZ-RG-Team24 \
  --allowed-origins "https://your-frontend-domain.com"
```

## Monitoring and Logs

### View Application Logs

```bash
az webapp log tail \
  --name routeiq-chat-app \
  --resource-group AZ-RG-Team24
```

Or in Azure Portal:
- Go to your Web App → Log stream

### Enable Application Insights (Optional)

1. Create Application Insights resource
2. Go to Web App → Application Insights
3. Connect to your Application Insights resource

## Troubleshooting

### Application not starting

1. Check logs: `az webapp log tail --name routeiq-chat-app --resource-group AZ-RG-Team24`
2. Verify environment variables are set correctly
3. Check startup command is correct: `npm start`

### Authentication errors

1. Verify managed identity is enabled
2. Check role assignments
3. Verify DefaultAzureCredential can authenticate (check logs)

### Agent not responding

1. Verify agent ID is correct
2. Check endpoint URL is accessible
3. Verify API version in request headers
4. Check Azure AI Foundry service status

### Build failures

1. Ensure Node.js version matches (20.x)
2. Check that all dependencies are in package.json
3. Verify build scripts are correct

## Scaling

### Scale Up (More powerful instance)

```bash
az appservice plan update \
  --name routeiq-chat-app-plan \
  --resource-group AZ-RG-Team24 \
  --sku P1V2
```

### Scale Out (More instances)

```bash
az webapp scale \
  --name routeiq-chat-app \
  --resource-group AZ-RG-Team24 \
  --instance-count 3
```

## Cost Optimization

- Use Basic (B1) tier for development/testing
- Use Standard (S1) tier for production
- Enable auto-scale to handle traffic spikes
- Monitor usage in Azure Cost Management

## Security Best Practices

1. ✅ Use Managed Identity instead of connection strings
2. ✅ Enable HTTPS only
3. ✅ Use Azure Key Vault for sensitive secrets
4. ✅ Enable Application Insights for monitoring
5. ✅ Set up alerts for errors and performance issues
6. ✅ Regularly update dependencies
7. ✅ Use environment-specific configurations

## Next Steps

- Set up custom domain
- Configure SSL certificate
- Set up staging slot for blue-green deployments
- Configure backup and disaster recovery
- Set up monitoring and alerts


