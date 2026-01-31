# Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Install Dependencies

```bash
npm run install:all
```

### Step 2: Configure Environment

The `.env` file is already created in `server/.env` with your Azure credentials. Verify it contains:

```env
AZURE_EXISTING_AGENT_ID=RouteIQ-Agent1:4
AZURE_EXISTING_AIPROJECT_ENDPOINT=https://team24-foundry.services.ai.azure.com/api/projects/proj-default
# ... other variables
```

### Step 3: Authenticate with Azure

```bash
az login
```

### Step 4: Run Locally

```bash
npm run dev
```

This starts:
- Frontend at http://localhost:3000
- Backend API at http://localhost:3001

### Step 5: Test the Application

1. Open http://localhost:3000 in your browser
2. Click "📋 Use JSON Template" to insert a sample query
3. Click "Send" to get route recommendations

## 📦 Deploy to Azure

### Option A: Using the Deployment Script

```bash
chmod +x azure-deploy.sh
./azure-deploy.sh
```

Then build and deploy:

```bash
npm run build
# Follow the instructions from the script
```

### Option B: Using Azure Portal

1. Go to [Azure Portal](https://portal.azure.com)
2. Create a new Web App (Linux, Node 20)
3. Add all environment variables from `server/.env`
4. Deploy using your preferred method (Git, GitHub Actions, etc.)

## 🐛 Troubleshooting

**Issue: "Azure AI client not initialized"**
- Check that all environment variables are set correctly
- Verify you're logged in: `az account show`

**Issue: "Failed to get response from Azure AI"**
- Check the agent ID is correct
- Verify the endpoint URL is accessible
- Check Azure Portal for service status

**Issue: Port already in use**
- Change PORT in `server/.env` to a different port
- Or stop the process using the port

## 📚 Next Steps

- Read the full [README.md](README.md) for detailed documentation
- Customize the UI in `client/src/components/`
- Modify the agent integration in `server/src/services/azureAI.ts`


