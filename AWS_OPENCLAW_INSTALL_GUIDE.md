# Panduan Install OpenClaw di AWS dari Nol

## Persiapan Awal

### 1. Akun AWS
- Pastikan Tuan sudah punya akun AWS
- Login ke AWS Console: https://console.aws.amazon.com

### 2. Buat EC2 Instance

#### Step 1: Launch Instance
1. Buka EC2 Dashboard
2. Klik **"Launch Instance"**
3. Pilih nama instance: `openclaw-server`

#### Step 2: Pilih OS
- **AMI**: Ubuntu Server 22.04 LTS (Free tier eligible)
- **Architecture**: 64-bit (x86)

#### Step 3: Pilih Instance Type
- **Recommended**: t3.medium (2 vCPU, 4GB RAM)
- **Minimum**: t2.micro (1 vCPU, 1GB RAM) - untuk testing
- **Production**: t3.large atau lebih besar

#### Step 4: Key Pair
1. Klik **"Create new key pair"**
2. Nama: `openclaw-key`
3. Type: RSA
4. Format: `.pem` (untuk SSH)
5. Download dan simpan file `openclaw-key.pem`

#### Step 5: Network Settings
1. **VPC**: Default VPC
2. **Auto-assign public IP**: Enable
3. **Firewall (Security Group)**:
   - Create new security group
   - Name: `openclaw-sg`
   - Rules:
     - SSH (22) - Your IP only
     - HTTP (80) - Anywhere
     - HTTPS (443) - Anywhere
     - Custom TCP (3000) - Anywhere (untuk OpenClaw web)

#### Step 6: Storage
- **Size**: 20 GB minimum (30 GB recommended)
- **Type**: gp3 (General Purpose SSD)

#### Step 7: Launch
- Review semua settings
- Klik **"Launch Instance"**
- Tunggu sampai status **"Running"**

---

## Koneksi ke Server

### Windows (PowerShell)

```powershell
# Pindahkan key ke folder .ssh
mkdir $HOME\.ssh -Force
Move-Item openclaw-key.pem $HOME\.ssh\

# Set permission
icacls "$HOME\.ssh\openclaw-key.pem" /inheritance:r
icacls "$HOME\.ssh\openclaw-key.pem" /grant:r "$($env:USERNAME):(R)"

# Connect ke server (ganti dengan IP public Tuan)
ssh -i $HOME\.ssh\openclaw-key.pem ubuntu@YOUR_EC2_PUBLIC_IP
```

### Alternatif: PuTTY (Windows)
1. Download PuTTYgen
2. Load `openclaw-key.pem`
3. Save private key as `.ppk`
4. Gunakan PuTTY untuk connect

---

## Setup Server Ubuntu

### 1. Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Install Node.js 24.x
```bash
# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc

# Install Node.js 24
nvm install 24
nvm use 24
nvm alias default 24

# Verify
node --version  # Should show v24.x.x
npm --version
```

### 3. Install Python 3.14
```bash
# Install dependencies
sudo apt install -y software-properties-common

# Add deadsnakes PPA
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update

# Install Python 3.14
sudo apt install -y python3.14 python3.14-venv python3.14-dev

# Verify
python3.14 --version
```

### 4. Install Git
```bash
sudo apt install -y git
git --version
```

### 5. Install PM2 (Process Manager)
```bash
npm install -g pm2
pm2 startup
# Copy dan jalankan command yang muncul
```

---

## Install OpenClaw

### 1. Install OpenClaw Global
```bash
npm install -g openclaw
```

### 2. Buat Workspace Directory
```bash
mkdir -p ~/openclaw-workspace
cd ~/openclaw-workspace
```

### 3. Initialize OpenClaw
```bash
openclaw init
```

### 4. Configure OpenClaw
```bash
# Edit config
nano ~/.openclaw/openclaw.json
```

**Minimal Configuration:**
```json
{
  "agents": {
    "main": {
      "model": "9router/combatan",
      "thinking": "high"
    }
  },
  "providers": {
    "9router": {
      "apiKey": "YOUR_API_KEY_HERE"
    }
  },
  "gateway": {
    "enabled": true,
    "port": 3000,
    "host": "0.0.0.0"
  }
}
```

### 5. Setup Telegram Bot (Optional)
```bash
# Edit config untuk Telegram
nano ~/.openclaw/openclaw.json
```

Tambahkan:
```json
{
  "messaging": {
    "telegram": {
      "enabled": true,
      "token": "YOUR_TELEGRAM_BOT_TOKEN",
      "allowedUsers": [176968631]
    }
  }
}
```

---

## Jalankan OpenClaw

### 1. Start Gateway
```bash
openclaw gateway start
```

### 2. Verify Status
```bash
openclaw gateway status
```

### 3. Setup PM2 (Auto-restart)
```bash
# Stop gateway dulu
openclaw gateway stop

# Start dengan PM2
pm2 start openclaw -- gateway start
pm2 save
```

### 4. Monitor Logs
```bash
pm2 logs openclaw
```

---

## Security Hardening

### 1. Setup UFW Firewall
```bash
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 3000/tcp
sudo ufw enable
sudo ufw status
```

### 2. Install Fail2Ban
```bash
sudo apt install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### 3. Disable Root Login
```bash
sudo nano /etc/ssh/sshd_config
```

Set:
```
PermitRootLogin no
PasswordAuthentication no
```

Restart SSH:
```bash
sudo systemctl restart sshd
```

---

## Setup Domain (Optional)

### 1. Point Domain ke EC2
- Buat A record di DNS provider
- Point ke EC2 Public IP

### 2. Install Nginx
```bash
sudo apt install -y nginx
```

### 3. Configure Nginx
```bash
sudo nano /etc/nginx/sites-available/openclaw
```

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Enable site:
```bash
sudo ln -s /etc/nginx/sites-available/openclaw /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 4. Install SSL (Let's Encrypt)
```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

---

## Testing

### 1. Test Web Interface
```
http://YOUR_EC2_PUBLIC_IP:3000
```

### 2. Test Telegram Bot
- Kirim `/start` ke bot Tuan
- Bot harus respond

### 3. Test API
```bash
curl http://YOUR_EC2_PUBLIC_IP:3000/health
```

---

## Maintenance

### 1. Update OpenClaw
```bash
npm update -g openclaw
pm2 restart openclaw
```

### 2. Backup Configuration
```bash
# Backup config
cp ~/.openclaw/openclaw.json ~/openclaw-config-backup.json

# Backup workspace
tar -czf ~/openclaw-workspace-backup.tar.gz ~/openclaw-workspace
```

### 3. Monitor Resources
```bash
# CPU & Memory
htop

# Disk usage
df -h

# PM2 monitoring
pm2 monit
```

---

## Troubleshooting

### OpenClaw tidak start
```bash
# Check logs
openclaw gateway logs

# Check port
sudo netstat -tulpn | grep 3000

# Restart
openclaw gateway restart
```

### Telegram bot tidak respond
```bash
# Check config
cat ~/.openclaw/openclaw.json | grep telegram

# Check logs
pm2 logs openclaw
```

### Out of memory
```bash
# Add swap
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

---

## Cost Estimation

### t3.medium (Recommended)
- **Instance**: ~$30/month
- **Storage (30GB)**: ~$3/month
- **Data Transfer**: ~$5/month
- **Total**: ~$38/month

### t2.micro (Free Tier)
- **Instance**: $0 (first 12 months)
- **Storage (20GB)**: ~$2/month
- **Data Transfer**: ~$2/month
- **Total**: ~$4/month (first year)

---

## Next Steps

1. ✅ Launch EC2 instance
2. ✅ Connect via SSH
3. ✅ Install dependencies (Node.js, Python, Git)
4. ✅ Install OpenClaw
5. ✅ Configure OpenClaw
6. ✅ Start gateway
7. ✅ Setup PM2 auto-restart
8. ✅ Security hardening
9. ⚠️ Setup domain (optional)
10. ⚠️ Install SSL (optional)

---

**Siap memulai Tuan Sigit?** Kita bisa mulai dari step 1 (Launch EC2 Instance). 🚀
