# Set Startup Command in Azure Portal

## Where to Set "npm start"

The startup command is **NOT** in Deployment Center. It's in a different section:

### Step 1: Go to Configuration

1. In Azure Portal → Your Web App (`routeiq-chat-app`)
2. In the left menu, click **"Configuration"** (under Settings)
3. Click on the **"General settings"** tab

### Step 2: Set Startup Command

1. Scroll down to find **"Startup Command"** field
2. Enter: `npm start`
3. Click **"Save"** at the top
4. Click **"Continue"** when prompted

## Alternative: Check if Already Set

The startup command might already be set from when we created the Web App. To verify:

1. Go to **Configuration** → **General settings**
2. Look for **"Startup Command"**
3. If it's empty or wrong, set it to: `npm start`
4. Click **"Save"**

## Current Settings Should Be:

- **Source**: GitHub (bpnshukla/routeiq-chat-app/main) ✅
- **Build provider**: App Service Build Service ✅
- **Startup Command**: `npm start` (in Configuration → General settings)

---

**The startup command is in Configuration → General settings, NOT in Deployment Center!**

