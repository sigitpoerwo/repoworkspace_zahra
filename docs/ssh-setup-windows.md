# 🔐 SSH Setup Guide - Windows to EC2

**Created:** 2026-03-25
**OS:** Windows 10/11
**Purpose:** Connect to EC2 instance using SSH

---

## 📋 Prerequisites

- ✅ EC2 instance running
- ✅ Public IP address
- ✅ Key file (.pem) downloaded
- ✅ Windows 10/11 with PowerShell or WSL

---

## 🎯 Method 1: Using PowerShell (Recommended)

### Step 1: Move Key File to Safe Location

```powershell
# Open PowerShell
# Press Win + X, then select "Windows PowerShell" or "Terminal"

# Create .ssh directory if not exists
mkdir $HOME\.ssh -Force

# Move your key file (adjust path)
# Example: if key is in Downloads folder
Move-Item "$HOME\Downloads\biosoltamax-bot-key.pem" "$HOME\.ssh\biosoltamax-bot-key.pem"

# Or copy instead of move
Copy-Item "$HOME\Downloads\biosoltamax-bot-key.pem" "$HOME\.ssh\biosoltamax-bot-key.pem"
```

### Step 2: Set Correct Permissions

```powershell
# Navigate to .ssh directory
cd $HOME\.ssh

# Remove inheritance and set permissions (Windows equivalent of chmod 400)
icacls biosoltamax-bot-key.pem /inheritance:r
icacls biosoltamax-bot-key.pem /grant:r "$($env:USERNAME):(R)"

# Verify permissions
icacls biosoltamax-bot-key.pem
```

### Step 3: Connect to EC2

```powershell
# Replace YOUR_PUBLIC_IP with your actual EC2 public IP
ssh -i $HOME\.ssh\biosoltamax-bot-key.pem ubuntu@YOUR_PUBLIC_IP

# Example:
ssh -i $HOME\.ssh\biosoltamax-bot-key.pem ubuntu@54.123.45.67
```

**First time connecting:**
```
The authenticity of host '54.123.45.67 (54.123.45.67)' can't be established.
ECDSA key fingerprint is SHA256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

Type: `yes` and press Enter

### Step 4: Create SSH Config (Optional but Recommended)

```powershell
# Create/edit SSH config file
notepad $HOME\.ssh\config
```

Add this content:

```
Host biosoltamax-bot
    HostName YOUR_PUBLIC_IP
    User ubuntu
    IdentityFile ~/.ssh/biosoltamax-bot-key.pem
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

Save and close.

Now you can connect simply with:

```powershell
ssh biosoltamax-bot
```

---

## 🎯 Method 2: Using WSL (Windows Subsystem for Linux)

### Step 1: Install WSL (if not installed)

```powershell
# Run as Administrator
wsl --install

# Restart computer
# After restart, open Ubuntu from Start menu
```

### Step 2: Copy Key File to WSL

```bash
# In WSL terminal
mkdir -p ~/.ssh

# Copy from Windows to WSL
cp /mnt/c/Users/YOUR_USERNAME/Downloads/biosoltamax-bot-key.pem ~/.ssh/

# Set correct permissions
chmod 400 ~/.ssh/biosoltamax-bot-key.pem
```

### Step 3: Connect to EC2

```bash
ssh -i ~/.ssh/biosoltamax-bot-key.pem ubuntu@YOUR_PUBLIC_IP
```

---

## 🎯 Method 3: Using PuTTY

### Step 1: Convert .pem to .ppk

```
1. Download PuTTYgen: https://www.putty.org/
2. Open PuTTYgen
3. Click "Load"
4. Select your .pem file (change filter to "All Files")
5. Click "Save private key"
6. Save as: biosoltamax-bot-key.ppk
```

### Step 2: Configure PuTTY

```
1. Open PuTTY
2. Session:
   - Host Name: ubuntu@YOUR_PUBLIC_IP
   - Port: 22
   - Connection type: SSH

3. Connection > SSH > Auth > Credentials:
   - Private key file: Browse and select biosoltamax-bot-key.ppk

4. Connection > Data:
   - Auto-login username: ubuntu

5. Session:
   - Saved Sessions: biosoltamax-bot
   - Click "Save"

6. Click "Open" to connect
```

---

## 🧪 Testing Connection

### Quick Test

```powershell
# Test if SSH is working
ssh -i $HOME\.ssh\biosoltamax-bot-key.pem ubuntu@YOUR_PUBLIC_IP "echo 'Connection successful!'"
```

### Full Test

```powershell
# Connect to instance
ssh -i $HOME\.ssh\biosoltamax-bot-key.pem ubuntu@YOUR_PUBLIC_IP

# Once connected, run:
whoami          # Should show: ubuntu
hostname        # Should show: ip-xxx-xxx-xxx-xxx
uname -a        # Should show: Linux ... Ubuntu
exit            # Disconnect
```

---

## ⚠️ Troubleshooting

### Error: "Permission denied (publickey)"

**Solution 1: Check key permissions**
```powershell
icacls $HOME\.ssh\biosoltamax-bot-key.pem
# Should only show your username with Read permission
```

**Solution 2: Verify correct username**
```powershell
# For Ubuntu AMI, use 'ubuntu'
ssh -i $HOME\.ssh\biosoltamax-bot-key.pem ubuntu@YOUR_PUBLIC_IP

# For Amazon Linux, use 'ec2-user'
ssh -i $HOME\.ssh\biosoltamax-bot-key.pem ec2-user@YOUR_PUBLIC_IP
```

**Solution 3: Check Security Group**
```
1. Go to AWS Console > EC2 > Security Groups
2. Select your security group
3. Inbound rules should have:
   - Type: SSH
   - Port: 22
   - Source: Your IP or 0.0.0.0/0
```

### Error: "Connection timed out"

**Solution 1: Check instance is running**
```
AWS Console > EC2 > Instances
Status should be: Running (green)
```

**Solution 2: Check Security Group allows SSH**
```
Inbound rules must allow port 22 from your IP
```

**Solution 3: Verify Public IP**
```
Make sure you're using the correct Public IPv4 address
Not the Private IP!
```

### Error: "WARNING: UNPROTECTED PRIVATE KEY FILE!"

**Solution:**
```powershell
# Reset permissions
icacls $HOME\.ssh\biosoltamax-bot-key.pem /inheritance:r
icacls $HOME\.ssh\biosoltamax-bot-key.pem /grant:r "$($env:USERNAME):(R)"
```

### Error: "Host key verification failed"

**Solution:**
```powershell
# Remove old host key
ssh-keygen -R YOUR_PUBLIC_IP

# Try connecting again
ssh -i $HOME\.ssh\biosoltamax-bot-key.pem ubuntu@YOUR_PUBLIC_IP
```

---

## 🚀 Quick Commands Reference

```powershell
# Connect to EC2
ssh -i $HOME\.ssh\biosoltamax-bot-key.pem ubuntu@YOUR_PUBLIC_IP

# Connect with verbose output (for debugging)
ssh -v -i $HOME\.ssh\biosoltamax-bot-key.pem ubuntu@YOUR_PUBLIC_IP

# Copy file TO EC2
scp -i $HOME\.ssh\biosoltamax-bot-key.pem local-file.txt ubuntu@YOUR_PUBLIC_IP:~/

# Copy file FROM EC2
scp -i $HOME\.ssh\biosoltamax-bot-key.pem ubuntu@YOUR_PUBLIC_IP:~/remote-file.txt ./

# Copy directory TO EC2
scp -r -i $HOME\.ssh\biosoltamax-bot-key.pem ./local-folder ubuntu@YOUR_PUBLIC_IP:~/

# Run command without logging in
ssh -i $HOME\.ssh\biosoltamax-bot-key.pem ubuntu@YOUR_PUBLIC_IP "ls -la"
```

---

## 📝 Next Steps

After successful SSH connection:

1. ✅ Update system: `sudo apt-get update && sudo apt-get upgrade -y`
2. ✅ Install Python: `sudo apt-get install -y python3.11 python3-pip`
3. ✅ Setup firewall: `sudo ufw allow 22 && sudo ufw enable`
4. ✅ Create app user: `sudo adduser biosoltamax`
5. ✅ Deploy bot code

Continue with: [ec2-biosoltamax-setup.md](ec2-biosoltamax-setup.md) Step 3

---

## 🔗 Resources

- [OpenSSH for Windows](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse)
- [PuTTY Documentation](https://www.chiark.greenend.org.uk/~sgtatham/putty/docs.html)
- [AWS EC2 Connect Guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)

---

**Status:** ✅ Ready to Connect
**Created:** 2026-03-25
**Estimated Time:** 5-10 minutes
