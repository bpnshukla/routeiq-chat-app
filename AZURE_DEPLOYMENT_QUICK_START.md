# 🚀 Quick Start: Deploy to Azure Portal

## Option 1: Automated PowerShell Script (Easiest)

### Step 1: Run the Deployment Script

```powershell
.\deploy-to-azure.ps1
```

This will automatically:
- ✅ Create all Azure resources
- ✅ Configure environment variables
- ✅ Enable Managed Identity
- ✅ Grant permissions
- ✅ Set up deployment

### Step 2: Build and Deploy

```powershell
# Build the application
npm run build

# Get deployment URL (from script output) and deploy
git remote add azure <git-url-from-script>
git push azure main
```

## Option 2: Manual Azure Portal Deployment

### Step 1: Create Web App in Azure Portal

1. Go to https://portal.azure.com
2. Click **"Create a resource"**
3. Search **"Web App"** → Click **"Create"**
4. Fill in:
   - **Name**: `routeiq-chat-app`
   - **Runtime**: Node 20 LTS
   - **OS**: Linux
   - **Region**: UAE North
   - **Plan**: Create new (Basic B1)
5. Click **"Review + create"** → **"Create"**

### Step 2: Configure Environment Variables

1. Go to your Web App → **Configuration** → **Application settings**
2. Add these settings (click **"+ New application setting"** for each):

| Name | Value |
|------|-------|
| `AZURE_EXISTING_AGENT_ID` | `RouteIQ-Agent1:4` |
| `AZURE_EXISTING_AIPROJECT_ENDPOINT` | `https://team24-foundry.services.ai.azure.com/api/projects/proj-default` |
| `AZURE_EXISTING_RESOURCE_ID` | `/subscriptions/cd59df9d-15fd-407f-bd94-4e41b2cc5b05/resourceGroups/AZ-RG-Team24/providers/Microsoft.CognitiveServices/accounts/team24-foundry` |
| `PORT` | `3001` |
| `NODE_ENV` | `production` |
| `SCM_DO_BUILD_DURING_DEPLOYMENT` | `true` |

3. Click **"Save"**

### Step 3: Set Startup Command

1. **Configuration** → **General settings**
2. **Startup Command**: `npm start`
3. Click **"Save"**

### Step 4: Enable Managed Identity

1. Go to **Identity** → **System assigned**
2. Toggle **Status** to **On**
3. Click **"Save"**
4. Copy the **Object (principal) ID**

### Step 5: Grant Permissions

1. Go to your Cognitive Services: `team24-foundry`
2. **Access control (IAM)** → **"+ Add"** → **"Add role assignment"**
3. Role: **"Cognitive Services User"**
4. Assign to: **Managed identity** → Select `routeiq-chat-app`
5. Click **"Review + assign"**

### Step 6: Deploy Code

#### Via GitHub (Recommended)

1. **Deployment Center** → Select **GitHub**
2. Authorize and select your repository
3. Branch: `main`
4. Click **"Save"** (auto-deploys on push)

#### Via Local Git

1. **Deployment Center** → Select **Local Git**
2. Click **"Save"**
3. Copy the Git URL
4. Run:
   ```powershell
   git remote add azure <git-url>
   git push azure main
   ```

#### Via ZIP Deploy

1. Build locally: `npm run build`
2. Create ZIP (exclude node_modules)
3. Use Azure CLI:
   ```powershell
   az webapp deployment source config-zip --resource-group AZ-RG-Team24 --name routeiq-chat-app --src app.zip
   ```

### Step 7: Test

Visit: `https://routeiq-chat-app.azurewebsites.net`

## Troubleshooting

**App not starting?**
- Check **Log stream** in Azure Portal
- Verify environment variables are set
- Check startup command is `npm start`

**Authentication errors?**
- Verify Managed Identity is enabled
- Check role assignment is correct

**Build failures?**
- Check **Deployment Center** → **Logs**
- Ensure `SCM_DO_BUILD_DURING_DEPLOYMENT=true`

## Your App URL

After deployment, your app will be available at:
**https://routeiq-chat-app.azurewebsites.net**

---

📚 For detailed instructions, see [DEPLOY_AZURE_PORTAL.md](DEPLOY_AZURE_PORTAL.md)

