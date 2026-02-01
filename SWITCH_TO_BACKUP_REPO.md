# Switch to Backup Repository - Step by Step

## Step 1: Stop Current Deployment (Optional)

The deployment might complete or fail on its own, but you can:
1. In Azure Portal → Deployment Center → **Logs** tab
2. If there's a "Cancel" or "Stop" button, click it
3. Or just proceed to switch - the new deployment will override

## Step 2: Switch to Backup Repository

1. **Go to Azure Portal** → Your Web App (`routeiq-chat-app`) → **Deployment Center**

2. **Disconnect Current Connection**:
   - Click **"Disconnect"** next to the current GitHub connection
   - Click **"Save"** to confirm

3. **Connect to Backup Repository**:
   - Click **"Settings"** tab (or go back to main Deployment Center)
   - Click **"Source"** dropdown
   - Select **"GitHub"**
   - Click **"Authorize"** (if needed) and sign in to GitHub
   - Fill in:
     - **Organization**: `etihad-org`
     - **Repository**: `routeiq-workflow-webapp-ui`
     - **Branch**: `main`
   - **Authentication type**: Select **"Basic authentication"**
   - Click **"Save"**

4. **Deployment Will Start Automatically**:
   - Go to **"Logs"** tab to monitor
   - Should complete in 3-10 minutes

## Step 3: Verify

- Check deployment status in **Logs** tab
- Once complete, visit: https://routeiq-chat-app.azurewebsites.net

---

**The backup repository is ready and has all your code!**

