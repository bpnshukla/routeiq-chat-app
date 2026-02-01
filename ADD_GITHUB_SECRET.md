# Add Azure Credentials to GitHub Secrets

## Service Principal Created ✅

I've created an Azure Service Principal for deployment.

## Step 1: Copy the JSON

The service principal JSON was created. You need to add it to GitHub Secrets.

## Step 2: Add to GitHub Secrets

1. **Go to**: https://github.com/bpnshukla/routeiq-chat-app/settings/secrets/actions

2. **Click**: "New repository secret"

3. **Name**: `AZURE_CREDENTIALS` (exactly this name - case sensitive!)

4. **Value**: Paste the entire JSON output (the one I just created). It should look like:
   ```json
   {
     "clientId": "...",
     "clientSecret": "...",
     "subscriptionId": "...",
     "tenantId": "...",
     ...
   }
   ```

5. **Click**: "Add secret"

## Step 3: Retry Deployment

After adding the secret:
1. Go to GitHub Actions: https://github.com/bpnshukla/routeiq-chat-app/actions
2. Click "Re-run jobs" on the failed workflow
3. Or push a new commit to trigger deployment

## Alternative: Use OAuth (Easier)

If you prefer, you can:
1. In Azure Portal → Deployment Center
2. Disconnect and reconnect with **"GitHub" (OAuth)**
3. This automatically sets up secrets!

---

**The service principal is ready - just add it to GitHub Secrets!**

