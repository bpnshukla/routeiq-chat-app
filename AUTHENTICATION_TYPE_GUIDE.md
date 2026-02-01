# Azure Portal - Authentication Type Selection

When connecting GitHub in Azure Portal Deployment Center, you'll see an **"Authentication type"** option.

## Recommended: Use "GitHub" (OAuth)

### Steps:
1. **Authentication type**: Select **"GitHub"** (or "GitHub (OAuth)")
2. Click **"Authorize"** or **"Sign in"**
3. Sign in to your GitHub account
4. Authorize Azure to access your repositories
5. Select:
   - **Organization**: `bpnshukla`
   - **Repository**: `routeiq-chat-app`
   - **Branch**: `main`
6. Click **"Save"**

### Why GitHub OAuth?
- ✅ Azure automatically creates required secrets
- ✅ No manual credential setup needed
- ✅ Secure and recommended by Microsoft
- ✅ Automatic token refresh

## Alternative: Personal Access Token (PAT)

If "GitHub" OAuth doesn't work, you can use a Personal Access Token:

1. **Create GitHub PAT**:
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token" → "Generate new token (classic)"
   - Name: `Azure Deployment`
   - Scopes: Check `repo` (full control of private repositories)
   - Click "Generate token"
   - **Copy the token** (you won't see it again!)

2. **In Azure Portal**:
   - Authentication type: Select **"Personal Access Token"** or **"Token"**
   - Username: Your GitHub username (`bpnshukla`)
   - Token: Paste the PAT you created
   - Click **"Save"**

## What to Choose?

**For most users**: Choose **"GitHub"** (OAuth) - it's the easiest and most secure.

**If OAuth fails**: Use **"Personal Access Token"** as a backup.

---

**After selecting authentication type and saving, Azure will automatically:**
- Set up GitHub Actions secrets
- Configure deployment
- Start the first deployment

