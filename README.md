# RouteIQ Chat Application

A modern web application with a chat interface for interacting with the RouteIQ Azure AI Foundry agent. This application helps with Airline Network Planning & Route Profitability analysis.

## Features

- 💬 Interactive chat interface
- 🎨 Modern, responsive UI built with React and Tailwind CSS
- 🔄 Real-time conversation with Azure AI Foundry agent
- 📱 Mobile-friendly design
- 🚀 Ready for Azure Web App deployment

## Tech Stack

- **Frontend**: React 18 + TypeScript + Vite + Tailwind CSS
- **Backend**: Node.js + Express + TypeScript
- **Azure Integration**: Azure AI Inference SDK
- **Deployment**: Azure Web App

## Prerequisites

- Node.js 18+ and npm
- Azure account with AI Foundry agent configured
- Azure CLI (for deployment)

## Local Setup

### 1. Install Dependencies

```bash
npm run install:all
```

This will install dependencies for the root, server, and client.

### 2. Configure Environment Variables

Copy the example environment file and add your Azure credentials:

```bash
cp server/.env.example server/.env
```

Edit `server/.env` with your Azure AI Foundry configuration:

```env
AZURE_EXISTING_AGENT_ID=RouteIQ-Agent1:4
AZURE_ENV_NAME=agents-playground-3548
AZURE_LOCATION=uaenorth
AZURE_SUBSCRIPTION_ID=your-subscription-id
AZURE_EXISTING_AIPROJECT_ENDPOINT=https://team24-foundry.services.ai.azure.com/api/projects/proj-default
AZURE_EXISTING_AIPROJECT_RESOURCE_ID=/subscriptions/.../projects/proj-default
AZURE_EXISTING_RESOURCE_ID=/subscriptions/.../accounts/team24-foundry
PORT=3001
```

### 3. Azure Authentication

Make sure you're authenticated with Azure:

```bash
az login
```

Or set up service principal authentication for production.

### 4. Run the Application

**Development mode** (runs both server and client with hot reload):

```bash
npm run dev
```

The application will be available at:
- Frontend: http://localhost:3000
- Backend API: http://localhost:3001

**Production build**:

```bash
npm run build
npm start
```

## Usage

1. Open the application in your browser
2. Start chatting with the RouteIQ agent
3. You can send:
   - Plain text questions
   - JSON formatted input following the agent's input format:

```json
{
  "origin": "AUH",
  "candidateDestinations": ["LHR", "JFK", "DXB"],
  "month": 6,
  "frequencyPerWeek": 7,
  "candidateFleets": ["A380", "B777", "B787"]
}
```

The agent will respond with route recommendations, profitability assessments, and risk analysis.

## Azure Web App Deployment

### Option 1: Using Azure CLI

1. **Create a Web App** (if not already created):

```bash
az webapp create \
  --resource-group AZ-RG-Team24 \
  --plan <your-app-service-plan> \
  --name routeiq-chat-app \
  --runtime "NODE:20-lts"
```

2. **Configure environment variables**:

```bash
az webapp config appsettings set \
  --resource-group AZ-RG-Team24 \
  --name routeiq-chat-app \
  --settings \
    AZURE_EXISTING_AGENT_ID="RouteIQ-Agent1:4" \
    AZURE_ENV_NAME="agents-playground-3548" \
    AZURE_LOCATION="uaenorth" \
    AZURE_SUBSCRIPTION_ID="cd59df9d-15fd-407f-bd94-4e41b2cc5b05" \
    AZURE_EXISTING_AIPROJECT_ENDPOINT="https://team24-foundry.services.ai.azure.com/api/projects/proj-default" \
    AZURE_EXISTING_AIPROJECT_RESOURCE_ID="/subscriptions/cd59df9d-15fd-407f-bd94-4e41b2cc5b05/resourceGroups/AZ-RG-Team24/providers/Microsoft.CognitiveServices/accounts/team24-foundry/projects/proj-default" \
    AZURE_EXISTING_RESOURCE_ID="/subscriptions/cd59df9d-15fd-407f-bd94-4e41b2cc5b05/resourceGroups/AZ-RG-Team24/providers/Microsoft.CognitiveServices/accounts/team24-foundry" \
    PORT=3001 \
    NODE_ENV=production
```

3. **Configure startup command**:

```bash
az webapp config set \
  --resource-group AZ-RG-Team24 \
  --name routeiq-chat-app \
  --startup-file "npm start"
```

4. **Deploy using Git**:

```bash
az webapp deployment source config-local-git \
  --resource-group AZ-RG-Team24 \
  --name routeiq-chat-app
```

Then push to the Git remote:

```bash
git remote add azure <git-url-from-above>
git push azure main
```

### Option 2: Using Azure Portal

1. Go to [Azure Portal](https://portal.azure.com)
2. Create a new Web App or select existing one
3. Go to **Configuration** → **Application settings**
4. Add all environment variables from your `.env` file
5. Go to **Deployment Center**
6. Choose your deployment method (GitHub, Azure DevOps, Local Git, etc.)
7. Follow the deployment wizard

### Option 3: Using GitHub Actions

1. Add the Azure Web App publish profile as a GitHub secret:
   - Go to Azure Portal → Your Web App → **Get publish profile**
   - Copy the content
   - Go to GitHub → Your repo → **Settings** → **Secrets** → **New secret**
   - Name: `AZURE_WEBAPP_PUBLISH_PROFILE`
   - Value: Paste the publish profile content

2. Push to the `main` branch to trigger automatic deployment

### Post-Deployment Configuration

After deployment, you may need to:

1. **Enable Managed Identity** (recommended for production):

```bash
az webapp identity assign \
  --resource-group AZ-RG-Team24 \
  --name routeiq-chat-app
```

2. **Grant permissions** to the managed identity to access your AI Foundry resource

3. **Update CORS settings** if needed (the app should work out of the box)

## Project Structure

```
.
├── client/                 # React frontend application
│   ├── src/
│   │   ├── components/    # React components
│   │   ├── App.tsx        # Main app component
│   │   └── main.tsx       # Entry point
│   ├── package.json
│   └── vite.config.ts
├── server/                 # Express backend API
│   ├── src/
│   │   ├── routes/        # API routes
│   │   ├── services/      # Business logic (Azure AI)
│   │   └── index.ts       # Server entry point
│   ├── package.json
│   └── tsconfig.json
├── package.json           # Root package.json with scripts
└── README.md
```

## Troubleshooting

### Azure Authentication Issues

If you encounter authentication errors:

1. Verify you're logged in: `az account show`
2. Check your subscription: `az account list`
3. For production, use Managed Identity or Service Principal

### CORS Issues

The server is configured to allow CORS from the frontend. If you encounter issues:

- Check that the frontend URL is correct in `server/src/index.ts`
- Verify environment variables are set correctly

### Agent Not Responding

1. Verify the agent ID is correct: `AZURE_EXISTING_AGENT_ID`
2. Check the endpoint URL: `AZURE_EXISTING_AIPROJECT_ENDPOINT`
3. Ensure you have proper permissions to access the AI Foundry resource
4. Check Azure Portal for any service issues

## License

MIT

## Support

For issues related to:
- **Azure AI Foundry**: Check [Azure AI Studio](https://ai.azure.com/)
- **Application**: Open an issue in this repository


