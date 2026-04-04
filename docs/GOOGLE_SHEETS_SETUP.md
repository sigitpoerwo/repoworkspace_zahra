# GOOGLE SHEETS MCP - SETUP GUIDE

**Tanggal:** 3 April 2026, 23:33 WIB  
**Status:** Setup Required

---

## 📋 PREREQUISITES

1. Google Account
2. Google Cloud Project
3. Service Account with Google Sheets API access

---

## 🔧 SETUP STEPS

### **Step 1: Create Google Cloud Project**

1. Go to: https://console.cloud.google.com
2. Click "Create Project"
3. Project name: `OpenClaw-MCP`
4. Click "Create"

### **Step 2: Enable Google Sheets API**

1. In Google Cloud Console, go to "APIs & Services" → "Library"
2. Search for "Google Sheets API"
3. Click "Enable"

### **Step 3: Create Service Account**

1. Go to "APIs & Services" → "Credentials"
2. Click "Create Credentials" → "Service Account"
3. Service account name: `openclaw-sheets`
4. Click "Create and Continue"
5. Grant role: "Editor" (or "Viewer" for read-only)
6. Click "Done"

### **Step 4: Create Service Account Key**

1. Click on the service account you just created
2. Go to "Keys" tab
3. Click "Add Key" → "Create new key"
4. Choose "JSON"
5. Click "Create"
6. Save the JSON file to: `C:\Users\Administrator\.openclaw\google-sheets-credentials.json`

### **Step 5: Share Spreadsheet with Service Account**

1. Open your Google Spreadsheet
2. Click "Share"
3. Add the service account email (looks like: `openclaw-sheets@project-id.iam.gserviceaccount.com`)
4. Give "Editor" or "Viewer" permission
5. Click "Send"

### **Step 6: Update OpenClaw Config**

Update `C:\Users\Administrator\.openclaw\openclaw.json`:

```json
{
  "mcp": {
    "servers": {
      "google-sheets": {
        "command": "npx",
        "args": ["-y", "google-sheets-mcp"],
        "env": {
          "GOOGLE_APPLICATION_CREDENTIALS": "C:\\Users\\Administrator\\.openclaw\\google-sheets-credentials.json"
        }
      }
    }
  }
}
```

---

## 🧪 TESTING

### **Test Connection:**

```bash
# Via OpenClaw
openclaw mcp show google-sheets

# Test with a spreadsheet
# Ask OpenClaw: "Read data from Google Sheet [spreadsheet-id]"
```

---

## 📝 USAGE EXAMPLES

### **Read Data:**
```
"Read data from Google Sheet: 1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms"
```

### **Write Data:**
```
"Write to Google Sheet [id], cell A1: Hello World"
```

### **Create Sheet:**
```
"Create a new Google Sheet named 'Sales Report'"
```

---

## 🔐 SECURITY NOTES

- Service account credentials are sensitive
- Store credentials file securely
- Don't commit credentials to Git
- Use read-only permissions when possible
- Rotate credentials periodically

---

## 🆘 TROUBLESHOOTING

### **Error: "Permission denied"**
- Check if service account has access to the spreadsheet
- Verify API is enabled
- Check credentials file path

### **Error: "Invalid credentials"**
- Verify JSON file is valid
- Check file path in config
- Regenerate credentials if needed

### **Error: "API not enabled"**
- Enable Google Sheets API in Cloud Console
- Wait a few minutes for propagation

---

## 📚 RESOURCES

- Google Sheets API: https://developers.google.com/sheets/api
- Service Accounts: https://cloud.google.com/iam/docs/service-accounts
- MCP Package: https://npm.im/google-sheets-mcp

---

**Status:** ⚠️ Awaiting Setup  
**Next:** Follow steps above to configure Google Sheets MCP

---

**Created:** 2026-04-03 23:33 WIB  
**Location:** E:\ZAHRA-WORKSPACE\mcp-servers\GOOGLE_SHEETS_SETUP.md
