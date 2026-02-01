# Backup Repository Setup

## Repository Details

- **GitHub Username**: `etihad-org`
- **Repository Name**: `routeiq-workflow-webapp-ui`
- **Repository URL**: https://github.com/etihad-org/routeiq-workflow-webapp-ui

## Current Remotes

1. **origin** (Primary): `bpnshukla/routeiq-chat-app`
2. **backup** (Backup): `etihad-org/routeiq-workflow-webapp-ui`

## How to Use Backup Repository

### If Primary Deployment Fails:

1. **In Azure Portal** → Deployment Center
2. Click **"Disconnect"** next to current GitHub connection
3. Click **"Save"**
4. Reconnect GitHub:
   - Select **"GitHub"**
   - Organization: `etihad-org`
   - Repository: `routeiq-workflow-webapp-ui`
   - Branch: `main`
   - Click **"Save"**

### To Push Updates to Both Repos:

```powershell
# Push to primary
git push origin main

# Push to backup
git push backup main
```

## Repository Status

✅ Code has been pushed to backup repository
✅ Ready to use if primary deployment fails

---

**Both repositories now have your code!**

