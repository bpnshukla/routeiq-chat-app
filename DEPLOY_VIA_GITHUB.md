# Deploy via GitHub - Step by Step

## Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `routeiq-chat-app` (or any name you prefer)
3. Choose **Public** or **Private**
4. **DO NOT** initialize with README, .gitignore, or license (we already have code)
5. Click **"Create repository"**

## Step 2: Push Code to GitHub

After creating the repo, GitHub will show you commands. Run these:

```powershell
# Add GitHub remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/routeiq-chat-app.git

# Push to GitHub
git push -u origin main
```

## Step 3: Connect GitHub to Azure Portal

1. Go back to Azure Portal → Your Web App → **Deployment Center**
2. Click **"Disconnect"** next to Local Git
3. Select **"GitHub"** as source
4. Click **"Authorize"** and sign in to GitHub
5. Select:
   - **Organization**: Your GitHub username
   - **Repository**: `routeiq-chat-app` (or the name you chose)
   - **Branch**: `main`
6. Click **"Save"**
7. Deployment will start automatically! 🚀

## Step 4: Verify Deployment

- Go to **Deployment Center** → **Logs** tab to see deployment progress
- Once complete, visit: **https://routeiq-chat-app.azurewebsites.net**

---

**That's it!** Your app will automatically deploy whenever you push to GitHub!

