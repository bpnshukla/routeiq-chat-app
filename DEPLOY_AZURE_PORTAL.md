# Deploy RouteIQ Chat App to Azure Portal

This guide will help you deploy the application to Azure Web App using the Azure Portal.

## Prerequisites

- Azure account with access to subscription: `cd59df9d-15fd-407f-bd94-4e41b2cc5b05`
- Your code ready to deploy

## Method 1: Quick Deploy Script (Recommended)

### Step 1: Run the PowerShell Deployment Script

```powershell
.\deploy-to-azure.ps1
```

This script will:
- ✅ Create/verify resource group
- ✅ Create App Service Plan
- ✅ Create Web App
- ✅ Configure all environment variables
- ✅ Enable Managed Identity
- ✅ Grant permissions
- ✅ Set up Git deployment

### Step 2: Deploy Your Code

After the script completes, you'll get a Git URL. Deploy using:

```powershell
git remote add azure <git-url-from-script>
git push azure main
```

## Method 2: Manual Deployment via Azure Portal

### Step 1: Create Web App

1. Go to [Azure Portal](https://portal.azure.com)
2. Click **"Create a resource"**
3. Search for **"Web App"** and select it
4. Click **"Create"**
5. Fill in the details:
   - **Subscription**: Select your subscription
   - **Resource Group**: `AZ-RG-Team24` (or create new)
   - **Name**: `routeiq-chat-app`
   - **Publish**: Code
   - **Runtime stack**: Node 20 LTS
   - **Operating System**: Linux
   - **Region**: UAE North
   - **App Service Plan**: Create new or use existing
     - Name: `routeiq-chat-app-plan`
     - SKU: Basic B1 (or higher for production)
6. Click **"Review + create"** then **"Create"**

### Step 2: Configure Environment Variables

1. Go to your Web App in Azure Portal
2. Navigate to **Configuration** → **Application settings**
3. Click **"+ New application setting"** and add each:

```
Name: AZURE_EXISTING_AGENT_ID
Value: RouteIQ-Agent1:4

Name: AZURE_ENV_NAME
Value: agents-playground-3548

Name: AZURE_LOCATION
Value: uaenorth

Name: AZURE_SUBSCRIPTION_ID
Value: cd59df9d-15fd-407f-bd94-4e41b2cc5b05

Name: AZURE_EXISTING_AIPROJECT_ENDPOINT
Value: https://team24-foundry.services.ai.azure.com/api/projects/proj-default

Name: AZURE_EXISTING_AIPROJECT_RESOURCE_ID
Value: /subscriptions/cd59df9d-15fd-407f-bd94-4e41b2cc5b05/resourceGroups/AZ-RG-Team24/providers/Microsoft.CognitiveServices/accounts/team24-foundry/projects/proj-default

Name: AZURE_EXISTING_RESOURCE_ID
Value: /subscriptions/cd59df9d-15fd-407f-bd94-4e41b2cc5b05/resourceGroups/AZ-RG-Team24/providers/Microsoft.CognitiveServices/accounts/team24-foundry

Name: PORT
Value: 3001

Name: NODE_ENV
Value: production

Name: AZD_ALLOW_NON_EMPTY_FOLDER
Value: true

Name: SCM_DO_BUILD_DURING_DEPLOYMENT
Value: true
```

4. Click **"Save"**

### Step 3: Configure Startup Command

1. In your Web App, go to **Configuration** → **General settings**
2. Under **"Startup Command"**, enter:
   ```
   npm start
   ```
3. Click **"Save"**

### Step 4: Enable Managed Identity

1. Go to **Identity** in your Web App
2. Under **"System assigned"** tab, toggle **"Status"** to **On**
3. Click **"Save"**
4. Copy the **Object (principal) ID**

### Step 5: Grant Permissions to Managed Identity

1. Go to your Cognitive Services resource: `team24-foundry`
2. Click **"Access control (IAM)"**
3. Click **"+ Add"** → **"Add role assignment"**
4. Select role: **"Cognitive Services User"**
5. Click **"Next"**
6. Under **"Assign access to"**, select **"Managed identity"**
7. Click **"+ Select members"**
8. Select your Web App: `routeiq-chat-app`
9. Click **"Select"** then **"Review + assign"**

### Step 6: Deploy Your Code

#### Option A: Using Deployment Center (GitHub)

1. Go to **Deployment Center** in your Web App
2. Select **"GitHub"** as source
3. Authorize and select your repository
4. Select branch: `main`
5. Click **"Save"**
6. Your app will automatically deploy on every push to main

#### Option B: Using Local Git

1. Go to **Deployment Center** in your Web App
2. Select **"Local Git"** as source
3. Click **"Save"**
4. Copy the Git clone URL
5. In your local terminal:
   ```powershell
   git remote add azure <git-url-from-portal>
   git push azure main
   ```

#### Option C: Using ZIP Deploy

1. Build your application locally:
   ```powershell
   npm run build
   ```
2. Create a ZIP file of the entire project (excluding node_modules)
3. Go to **Advanced Tools (Kudu)** → **Go**
4. Navigate to **Debug console** → **CMD**
5. Go to `site/wwwroot`
6. Upload your ZIP file and extract it
7. Or use Azure CLI:
   ```powershell
   az webapp deployment source config-zip --resource-group AZ-RG-Team24 --name routeiq-chat-app --src app.zip
   ```

### Step 7: Verify Deployment

1. Go to your Web App overview
2. Click on the URL (e.g., `https://routeiq-chat-app.azurewebsites.net`)
3. You should see your chat interface
4. Test by sending a message

## Troubleshooting

### Application Not Starting

1. Check **Log stream** in Azure Portal
2. Go to **Advanced Tools (Kudu)** → **Log Files** → **Application Logging**
3. Verify environment variables are set correctly
4. Check startup command is: `npm start`

### Authentication Errors

1. Verify Managed Identity is enabled
2. Check role assignment is correct
3. Verify the scope includes your Cognitive Services resource

### Build Failures

1. Check **Deployment Center** → **Logs**
2. Ensure `SCM_DO_BUILD_DURING_DEPLOYMENT=true` is set
3. Verify Node.js version matches (20.x)

### 404 Errors

1. Check that the build completed successfully
2. Verify `dist` folder exists in server
3. Check that static files are being served correctly

## Post-Deployment

### Enable Application Insights (Optional)

1. Go to **Application Insights** in your Web App
2. Click **"Turn on Application Insights"**
3. Create new or select existing Application Insights resource
4. Click **"Apply"**

### Set Up Custom Domain (Optional)

1. Go to **Custom domains** in your Web App
2. Click **"+ Add custom domain"**
3. Follow the instructions to verify ownership

### Configure Auto-Scale (Optional)

1. Go to **Scale out (App Service plan)**
2. Configure scaling rules based on CPU/Memory
3. Set minimum and maximum instances

## Cost Optimization

- **Development**: Use Basic B1 tier (~$13/month)
- **Production**: Use Standard S1 tier (~$73/month)
- Enable auto-scale to handle traffic spikes
- Monitor usage in **Cost Management + Billing**

## Security Best Practices

✅ Use Managed Identity (already configured)  
✅ Enable HTTPS only  
✅ Use Azure Key Vault for sensitive secrets (optional)  
✅ Enable Application Insights for monitoring  
✅ Set up alerts for errors  
✅ Regularly update dependencies  

## Next Steps

- Test the deployed application
- Set up monitoring and alerts
- Configure custom domain (if needed)
- Set up staging slot for blue-green deployments

