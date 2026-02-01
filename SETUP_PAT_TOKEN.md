# Setup Personal Access Token (PAT) for GitHub Deployment

## Why PAT Token Might Be Needed

If you selected "Basic authentication" in Azure Portal instead of OAuth, you need a Personal Access Token (PAT) for GitHub Actions to authenticate with Azure.

## Step 1: Create GitHub PAT Token

1. **Go to GitHub**: https://github.com/settings/tokens
2. **Click**: "Generate new token" → "Generate new token (classic)"
3. **Token name**: `Azure Deployment Token`
4. **Expiration**: Choose duration (90 days recommended)
5. **Scopes**: Check these:
   - ✅ `repo` (Full control of private repositories)
     - This includes: repo:status, repo_deployment, public_repo, repo:invite, security_events
6. **Click**: "Generate token"
7. **IMPORTANT**: Copy the token immediately (you won't see it again!)
   - It looks like: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

## Step 2: Add PAT to GitHub Secrets

1. **Go to your repository**: https://github.com/bpnshukla/routeiq-chat-app
2. **Click**: "Settings" tab
3. **Click**: "Secrets and variables" → "Actions"
4. **Click**: "New repository secret"
5. **Name**: `AZURE_CREDENTIALS`
6. **Value**: You need to create a service principal JSON. Let me help with this.

## Step 3: Create Azure Service Principal (For PAT)

Actually, for "Basic authentication" in Azure Portal, you might need to:

### Option A: Use OAuth Instead (Easier)

1. In Azure Portal → Deployment Center
2. Disconnect current connection
3. Reconnect with **"GitHub" (OAuth)** instead of "Basic authentication"
4. This automatically sets up everything!

### Option B: Set Up Service Principal

If you must use Basic auth, you need to create an Azure Service Principal:

```powershell
# Run this in Azure CLI
az ad sp create-for-rbac --name "routeiq-deployment" --role contributor --scopes /subscriptions/cd59df9d-15fd-407f-bd94-4e41b2cc5b05/resourceGroups/AZ-RG-Team24 --sdk-auth
```

This will output JSON that you add to GitHub Secrets as `AZURE_CREDENTIALS`.

## Recommendation

**Use OAuth instead of PAT** - it's much easier and Azure handles everything automatically!

---

**The easiest fix: Switch to OAuth authentication in Azure Portal!**

