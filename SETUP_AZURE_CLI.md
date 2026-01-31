# Installing Azure CLI on Windows

## Option 1: Using PowerShell (Recommended)

Run this command in PowerShell as Administrator:

```powershell
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi
```

Or download and install manually from: https://aka.ms/installazurecliwindows

## Option 2: Using Winget (Windows Package Manager)

```powershell
winget install -e --id Microsoft.AzureCLI
```

## Option 3: Using Chocolatey

```powershell
choco install azure-cli
```

## After Installation

1. **Close and reopen PowerShell** (or restart your terminal)
2. **Verify installation**:
   ```powershell
   az --version
   ```
3. **Login to Azure**:
   ```powershell
   az login
   ```

## Alternative: Use Service Principal (For CI/CD or Headless)

If you don't want to install Azure CLI, you can use a Service Principal:

1. Create a Service Principal in Azure Portal
2. Set these environment variables:
   ```powershell
   $env:AZURE_CLIENT_ID="your-client-id"
   $env:AZURE_CLIENT_SECRET="your-client-secret"
   $env:AZURE_TENANT_ID="your-tenant-id"
   ```

## For Local Development Without Azure CLI

The app will still run, but you'll get authentication errors when trying to connect to the Azure AI Foundry agent. You can:

1. Test the UI structure (frontend will work)
2. See error messages in the chat interface
3. Install Azure CLI later to enable full functionality


