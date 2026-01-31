# Deploy Your Code Now - Step by Step

## Step 1: Enable SCM Basic Authentication

1. **Click the "Enable here" link** next to the warning "SCM basic authentication is disabled for your app"
   - This will take you to the General settings page
   - Enable "SCM basic authentication" 
   - Click "Save"
   - Go back to Deployment Center

## Step 2: Choose Your Deployment Method

You have 3 options:

### Option A: Push via Git (Recommended)

1. **Set up deployment credentials** (if not already done):
   - Click on "Local Git/FTPS Credentials" tab
   - Set a username and password
   - Click "Save"
   - Copy the credentials

2. **Push your code from your computer**:
   ```powershell
   # Add Azure remote
   git remote add azure https://routeiq-chat-app.scm.azurewebsites.net:443/routeiq-chat-app.git
   
   # Push your code (use the username/password from step 1)
   git push azure main
   ```

### Option B: Deploy via GitHub (Easiest)

1. **Click "Disconnect"** next to "Local Git"
2. **Select "GitHub"** as the source
3. **Authorize** and select your repository
4. **Select branch**: `main`
5. **Click "Save"**
6. Your code will deploy automatically!

### Option C: ZIP Deploy (Quick)

1. **Click "Disconnect"** next to "Local Git"  
2. **Select "ZIP Deploy"** or use Azure CLI:
   ```powershell
   # Create deployment package
   Compress-Archive -Path * -DestinationPath deploy.zip -Force
   
   # Deploy
   az webapp deploy --resource-group AZ-RG-Team24 --name routeiq-chat-app --src-path deploy.zip --type zip
   ```

## Step 3: Verify Deployment

After deployment:
1. Go to your Web App overview
2. Click on the URL: **https://routeiq-chat-app.azurewebsites.net**
3. You should see your chat interface!

## Troubleshooting

- **If Git push fails**: Make sure you enabled SCM authentication and set credentials
- **If build fails**: Check the "Logs" tab in Deployment Center
- **If app doesn't load**: Check "Log stream" in your Web App

