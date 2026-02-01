# Fix GitHub Actions Deployment

## The Issue
Azure Portal created a GitHub Actions workflow, but the Azure credentials aren't configured in GitHub Secrets.

## Solution: Configure GitHub Secrets

### Option 1: Let Azure Portal Set Up Secrets (Easiest)

1. **In Azure Portal** → Your Web App → **Deployment Center**
2. Make sure **GitHub** is connected
3. Click **"Manage deployment credentials"** or **"Authorize"** again
4. Azure Portal should automatically create the required secrets in GitHub

### Option 2: Manual Setup (If Option 1 doesn't work)

1. **Get Service Principal Info from Azure Portal**:
   - Go to your Web App → **Deployment Center** → **Settings**
   - Look for "Deployment credentials" or service principal details

2. **Add Secrets to GitHub**:
   - Go to: https://github.com/bpnshukla/routeiq-chat-app/settings/secrets/actions
   - Click **"New repository secret"**
   - Add: `AZURE_CREDENTIALS` with the service principal JSON

### Option 3: Use Azure Portal Direct Deployment (Simplest)

If GitHub Actions keeps failing, you can use Azure Portal's built-in deployment:

1. **In Azure Portal** → Deployment Center → **Settings**
2. Make sure **"Build provider"** is set to **"App Service Build Service"**
3. Azure will build and deploy directly without GitHub Actions

## Current Status

I've updated the workflow to use a simpler authentication method. The deployment should work once the secrets are configured.

## Check Deployment

- Go to GitHub → Your repo → **Actions** tab
- You should see the workflow running
- Or check Azure Portal → **Deployment Center** → **Logs**

---

**Try Option 1 first** - Azure Portal should handle it automatically!

