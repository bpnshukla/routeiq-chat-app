# Set Startup Command for Linux App Service

## Issue
The "Startup Command" field might not appear in the Azure Portal UI for Linux App Service plans.

## Solution: Set via Azure CLI

I've just set it for you using Azure CLI. The command I ran:
```powershell
az webapp config set --resource-group AZ-RG-Team24 --name routeiq-chat-app --startup-file "npm start"
```

## Verify It's Set

The startup command should now be configured. You can verify by:
1. The command I just ran should have set it
2. Or check via Azure CLI:
   ```powershell
   az webapp config show --resource-group AZ-RG-Team24 --name routeiq-chat-app --query appCommandLine
   ```

## Alternative: Use package.json

For Node.js apps on Linux, Azure will automatically use the `start` script from your `package.json`, which we already have:
```json
"start": "cd server && npm start"
```

So it should work automatically!

## Next Steps

1. ✅ Startup command is now set via Azure CLI
2. ✅ Your package.json has the start script
3. ✅ Try deploying again - it should work now!

---

**The startup command is now configured! Try deploying again.**

