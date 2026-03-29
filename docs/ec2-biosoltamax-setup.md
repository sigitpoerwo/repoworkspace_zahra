# 🚀 EC2 Setup Guide - Biosoltamax Telegram Bot

**Created:** 2026-03-25
**Purpose:** Deploy Biosoltamax Bot to AWS EC2
**Instance Type:** t2.micro (Free Tier eligible)
**OS:** Ubuntu 22.04 LTS
**Estimated Cost:** $0/month (Free Tier) or ~$8/month after

---

## 📋 Prerequisites

- ✅ AWS Account (Free Tier)
- ✅ AWS Console access
- ✅ Biosoltamax Bot code ready
- ✅ Telegram Bot Token
- ✅ Database credentials

---

## 🎯 Step 1: Launch EC2 Instance

### 1.1 Go to EC2 Dashboard

```
1. Login to AWS Console: https://console.aws.amazon.com/
2. Search for "EC2" in the search bar
3. Click "EC2" to open EC2 Dashboard
4. Click "Launch Instance" button (orange button)
```

### 1.2 Configure Instance

**Name and Tags:**
```
Name: biosoltamax-bot-production
Environment: production
Project: biosoltamax
```

**Application and OS Images (AMI):**
```
- Select: Ubuntu Server 22.04 LTS
- Architecture: 64-bit (x86)
- AMI ID: ami-0c7217cdde317cfec (or latest Ubuntu 22.04)
```

**Instance Type:**
```
- Select: t2.micro
- vCPUs: 1
- Memory: 1 GiB
- ✅ Free tier eligible
```

**Key Pair (login):**
```
Option 1: Create new key pair
  - Name: biosoltamax-bot-key
  - Type: RSA
  - Format: .pem (for Mac/Linux) or .ppk (for Windows/PuTTY)
  - Click "Create key pair"
  - ⚠️ SAVE THE FILE! You can't download it again

Option 2: Use existing key pair
  - Select from dropdown
```

**Network Settings:**

Click "Edit" and configure:

```yaml
VPC: Default VPC (or create new)
Subnet: No preference (default)
Auto-assign public IP: Enable

Security Group:
  Name: biosoltamax-bot-sg
  Description: Security group for Biosoltamax Telegram Bot

  Inbound Rules:
    Rule 1 (SSH):
      - Type: SSH
      - Protocol: TCP
      - Port: 22
      - Source: My IP (your current IP)
      - Description: SSH access from my IP

    Rule 2 (HTTPS - optional for webhooks):
      - Type: HTTPS
      - Protocol: TCP
      - Port: 443
      - Source: 0.0.0.0/0
      - Description: HTTPS for Telegram webhooks

    Rule 3 (HTTP - optional):
      - Type: HTTP
      - Protocol: TCP
      - Port: 80
      - Source: 0.0.0.0/0
      - Description: HTTP redirect to HTTPS
```

**Configure Storage:**
```
Volume 1 (Root):
  - Size: 8 GiB (Free Tier allows up to 30 GiB)
  - Volume Type: gp3 (General Purpose SSD)
  - Delete on termination: Yes
  - Encrypted: No (optional: Yes for production)
```

**Advanced Details (Optional but Recommended):**

```bash
# User data (runs on first boot)
#!/bin/bash
apt-get update
apt-get upgrade -y
apt-get install -y python3.11 python3-pip postgresql-client git htop
```

### 1.3 Review and Launch

```
1. Review all settings
2. Click "Launch Instance"
3. Wait 2-3 minutes for instance to start
4. Note down:
   - Instance ID: i-xxxxxxxxxxxxx
   - Public IPv4 address: xx.xx.xx.xx
   - Public IPv4 DNS: ec2-xx-xx-xx-xx.compute-1.amazonaws.com
```

---

## 🔐 Step 2: Connect to EC2 Instance

### 2.1 Using SSH (Mac/Linux/Windows PowerShell)

```bash
# Set correct permissions for key file
chmod 400 biosoltamax-bot-key.pem

# Connect to instance
ssh -i biosoltamax-bot-key.pem ubuntu@YOUR_PUBLIC_IP

# Example:
ssh -i biosoltamax-bot-key.pem ubuntu@54.123.45.67
```

### 2.2 Using EC2 Instance Connect (Browser-based)

```
1. Go to EC2 Dashboard
2. Select your instance
3. Click "Connect" button
4. Choose "EC2 Instance Connect"
5. Click "Connect" (opens terminal in browser)
```

### 2.3 Using PuTTY (Windows)

```
1. Open PuTTY
2. Host Name: ubuntu@YOUR_PUBLIC_IP
3. Port: 22
4. Connection > SSH > Auth > Credentials
5. Browse and select your .ppk key file
6. Click "Open"
```

---

## 🛠️ Step 3: Setup Server Environment

### 3.1 Update System

```bash
# Update package list
sudo apt-get update

# Upgrade installed packages
sudo apt-get upgrade -y

# Install essential tools
sudo apt-get install -y \
  python3.11 \
  python3-pip \
  python3.11-venv \
  postgresql-client \
  git \
  htop \
  curl \
  wget \
  nano \
  ufw
```

### 3.2 Configure Firewall

```bash
# Enable UFW firewall
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw enable

# Check status
sudo ufw status
```

### 3.3 Create Application User

```bash
# Create dedicated user for bot
sudo adduser biosoltamax --disabled-password --gecos ""

# Add to sudo group (optional)
sudo usermod -aG sudo biosoltamax

# Switch to bot user
sudo su - biosoltamax
```

---

## 📦 Step 4: Deploy Biosoltamax Bot

### 4.1 Clone Repository

```bash
# Create app directory
mkdir -p ~/apps
cd ~/apps

# Clone bot repository (adjust URL)
git clone https://github.com/YOUR_USERNAME/biosoltamax-bot.git
cd biosoltamax-bot

# Or upload via SCP
# scp -i biosoltamax-bot-key.pem -r ./biosoltamax-bot ubuntu@YOUR_IP:~/apps/
```

### 4.2 Setup Python Virtual Environment

```bash
# Create virtual environment
python3.11 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install dependencies
pip install -r requirements.txt

# Or install manually
pip install python-telegram-bot psycopg2-binary python-dotenv requests
```

### 4.3 Configure Environment Variables

```bash
# Create .env file
nano .env
```

Add the following:

```bash
# Telegram Bot Configuration
TELEGRAM_BOT_TOKEN=your_bot_token_here
TELEGRAM_ADMIN_ID=your_telegram_user_id

# Database Configuration
DATABASE_URL=postgresql://user:password@localhost:5432/biosoltamax
DB_HOST=localhost
DB_PORT=5432
DB_NAME=biosoltamax
DB_USER=biosoltamax_user
DB_PASSWORD=your_secure_password

# Application Configuration
ENVIRONMENT=production
LOG_LEVEL=INFO
DEBUG=False

# API Keys (if needed)
OPENAI_API_KEY=your_openai_key
ANTHROPIC_API_KEY=your_anthropic_key
```

Save and exit (Ctrl+X, Y, Enter)

```bash
# Secure the .env file
chmod 600 .env
```

---

## 🗄️ Step 5: Setup PostgreSQL Database

### Option A: Use RDS (Recommended for Production)

```
1. Go to RDS Dashboard in AWS Console
2. Click "Create database"
3. Choose PostgreSQL
4. Template: Free tier
5. DB instance identifier: biosoltamax-db
6. Master username: biosoltamax_admin
7. Master password: [secure password]
8. DB instance class: db.t3.micro (Free Tier)
9. Storage: 20 GiB
10. Enable automatic backups
11. Create database
12. Note down endpoint: biosoltamax-db.xxxxx.us-east-1.rds.amazonaws.com
```

Update .env:
```bash
DATABASE_URL=postgresql://biosoltamax_admin:password@biosoltamax-db.xxxxx.us-east-1.rds.amazonaws.com:5432/biosoltamax
```

### Option B: Install PostgreSQL on EC2

```bash
# Install PostgreSQL
sudo apt-get install -y postgresql postgresql-contrib

# Start PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Create database and user
sudo -u postgres psql << EOF
CREATE DATABASE biosoltamax;
CREATE USER biosoltamax_user WITH PASSWORD 'your_secure_password';
GRANT ALL PRIVILEGES ON DATABASE biosoltamax TO biosoltamax_user;
\q
EOF

# Test connection
psql -h localhost -U biosoltamax_user -d biosoltamax
```

### 5.3 Run Database Migrations

```bash
# Activate virtual environment
source ~/apps/biosoltamax-bot/venv/bin/activate

# Run migrations (adjust based on your bot structure)
python manage.py migrate

# Or run SQL schema
psql -h localhost -U biosoltamax_user -d biosoltamax -f schema.sql
```

---

## 🚀 Step 6: Run Bot as Systemd Service

### 6.1 Create Systemd Service File

```bash
sudo nano /etc/systemd/system/biosoltamax-bot.service
```

Add the following:

```ini
[Unit]
Description=Biosoltamax Telegram Bot
After=network.target postgresql.service

[Service]
Type=simple
User=biosoltamax
WorkingDirectory=/home/biosoltamax/apps/biosoltamax-bot
Environment="PATH=/home/biosoltamax/apps/biosoltamax-bot/venv/bin"
ExecStart=/home/biosoltamax/apps/biosoltamax-bot/venv/bin/python bot.py
Restart=always
RestartSec=10
StandardOutput=append:/var/log/biosoltamax-bot/output.log
StandardError=append:/var/log/biosoltamax-bot/error.log

[Install]
WantedBy=multi-user.target
```

### 6.2 Create Log Directory

```bash
sudo mkdir -p /var/log/biosoltamax-bot
sudo chown biosoltamax:biosoltamax /var/log/biosoltamax-bot
```

### 6.3 Enable and Start Service

```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable service (start on boot)
sudo systemctl enable biosoltamax-bot

# Start service
sudo systemctl start biosoltamax-bot

# Check status
sudo systemctl status biosoltamax-bot

# View logs
sudo journalctl -u biosoltamax-bot -f
```

### 6.4 Service Management Commands

```bash
# Start bot
sudo systemctl start biosoltamax-bot

# Stop bot
sudo systemctl stop biosoltamax-bot

# Restart bot
sudo systemctl restart biosoltamax-bot

# Check status
sudo systemctl status biosoltamax-bot

# View logs (real-time)
sudo journalctl -u biosoltamax-bot -f

# View last 100 lines
sudo journalctl -u biosoltamax-bot -n 100

# View logs from today
sudo journalctl -u biosoltamax-bot --since today
```

---

## 📊 Step 7: Monitoring & Logging

### 7.1 Setup Log Rotation

```bash
sudo nano /etc/logrotate.d/biosoltamax-bot
```

Add:

```
/var/log/biosoltamax-bot/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 biosoltamax biosoltamax
    sharedscripts
    postrotate
        systemctl reload biosoltamax-bot > /dev/null 2>&1 || true
    endscript
}
```

### 7.2 Setup CloudWatch Logs (Optional)

```bash
# Install CloudWatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i amazon-cloudwatch-agent.deb

# Configure CloudWatch
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

### 7.3 Create Health Check Script

```bash
nano ~/apps/biosoltamax-bot/health_check.sh
```

Add:

```bash
#!/bin/bash

# Check if bot process is running
if systemctl is-active --quiet biosoltamax-bot; then
    echo "✅ Bot is running"
    exit 0
else
    echo "❌ Bot is not running"
    # Send alert (optional)
    # curl -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
    #   -d "chat_id=$ADMIN_ID" \
    #   -d "text=⚠️ Biosoltamax Bot is DOWN on EC2!"
    exit 1
fi
```

```bash
chmod +x ~/apps/biosoltamax-bot/health_check.sh

# Add to crontab (check every 5 minutes)
crontab -e
```

Add:

```
*/5 * * * * /home/biosoltamax/apps/biosoltamax-bot/health_check.sh
```

---

## 🔄 Step 8: Deployment & Updates

### 8.1 Create Deployment Script

```bash
nano ~/apps/biosoltamax-bot/deploy.sh
```

Add:

```bash
#!/bin/bash

echo "🚀 Deploying Biosoltamax Bot..."

# Navigate to app directory
cd ~/apps/biosoltamax-bot

# Pull latest code
echo "📥 Pulling latest code..."
git pull origin main

# Activate virtual environment
source venv/bin/activate

# Install/update dependencies
echo "📦 Installing dependencies..."
pip install -r requirements.txt

# Run database migrations (if any)
echo "🗄️ Running migrations..."
# python manage.py migrate

# Restart service
echo "🔄 Restarting bot..."
sudo systemctl restart biosoltamax-bot

# Check status
sleep 3
sudo systemctl status biosoltamax-bot

echo "✅ Deployment complete!"
```

```bash
chmod +x ~/apps/biosoltamax-bot/deploy.sh
```

### 8.2 Deploy Updates

```bash
# Run deployment script
~/apps/biosoltamax-bot/deploy.sh
```

---

## 🔒 Step 9: Security Hardening

### 9.1 Disable Root Login

```bash
sudo nano /etc/ssh/sshd_config
```

Change:

```
PermitRootLogin no
PasswordAuthentication no
```

Restart SSH:

```bash
sudo systemctl restart sshd
```

### 9.2 Setup Fail2Ban

```bash
# Install fail2ban
sudo apt-get install -y fail2ban

# Configure
sudo nano /etc/fail2ban/jail.local
```

Add:

```ini
[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
```

Start fail2ban:

```bash
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### 9.3 Enable Automatic Security Updates

```bash
sudo apt-get install -y unattended-upgrades

sudo dpkg-reconfigure --priority=low unattended-upgrades
```

---

## 💰 Step 10: Cost Optimization

### 10.1 Free Tier Limits

```
✅ EC2 t2.micro: 750 hours/month (1 instance 24/7)
✅ EBS Storage: 30 GB
✅ Data Transfer: 15 GB out/month
✅ RDS db.t3.micro: 750 hours/month
```

### 10.2 Setup Billing Alerts

```
1. Go to AWS Billing Dashboard
2. Click "Billing preferences"
3. Enable "Receive Billing Alerts"
4. Go to CloudWatch
5. Create alarm:
   - Metric: EstimatedCharges
   - Threshold: $5, $10, $20
   - Action: Send email notification
```

### 10.3 Cost Monitoring

```bash
# Check instance running time
uptime

# Monitor resource usage
htop

# Check disk usage
df -h

# Check memory usage
free -h
```

---

## 🧪 Step 11: Testing

### 11.1 Test Bot Locally

```bash
# SSH to EC2
ssh -i biosoltamax-bot-key.pem ubuntu@YOUR_IP

# Switch to bot user
sudo su - biosoltamax

# Navigate to app
cd ~/apps/biosoltamax-bot

# Activate venv
source venv/bin/activate

# Run bot manually
python bot.py
```

### 11.2 Test Bot on Telegram

```
1. Open Telegram
2. Search for your bot: @biosoltamax_bot
3. Send /start command
4. Test all commands
5. Check logs on server
```

### 11.3 Test Auto-Restart

```bash
# Kill bot process
sudo systemctl stop biosoltamax-bot

# Wait 10 seconds (RestartSec=10)
sleep 10

# Check if restarted
sudo systemctl status biosoltamax-bot
```

---

## 📝 Step 12: Backup Strategy

### 12.1 Database Backup Script

```bash
nano ~/apps/biosoltamax-bot/backup_db.sh
```

Add:

```bash
#!/bin/bash

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/home/biosoltamax/backups"
DB_NAME="biosoltamax"

mkdir -p $BACKUP_DIR

# Backup database
pg_dump -h localhost -U biosoltamax_user $DB_NAME > $BACKUP_DIR/backup_$DATE.sql

# Compress
gzip $BACKUP_DIR/backup_$DATE.sql

# Upload to S3 (optional)
# aws s3 cp $BACKUP_DIR/backup_$DATE.sql.gz s3://biosoltamax-backups/

# Keep only last 7 days
find $BACKUP_DIR -name "backup_*.sql.gz" -mtime +7 -delete

echo "✅ Backup completed: backup_$DATE.sql.gz"
```

```bash
chmod +x ~/apps/biosoltamax-bot/backup_db.sh

# Add to crontab (daily at 2 AM)
crontab -e
```

Add:

```
0 2 * * * /home/biosoltamax/apps/biosoltamax-bot/backup_db.sh
```

---

## 🎯 Quick Reference

### Essential Commands

```bash
# SSH to server
ssh -i biosoltamax-bot-key.pem ubuntu@YOUR_IP

# Check bot status
sudo systemctl status biosoltamax-bot

# View logs
sudo journalctl -u biosoltamax-bot -f

# Restart bot
sudo systemctl restart biosoltamax-bot

# Deploy updates
~/apps/biosoltamax-bot/deploy.sh

# Backup database
~/apps/biosoltamax-bot/backup_db.sh

# Check resource usage
htop
df -h
free -h
```

### Important Files

```
/home/biosoltamax/apps/biosoltamax-bot/          # Bot code
/home/biosoltamax/apps/biosoltamax-bot/.env      # Environment variables
/etc/systemd/system/biosoltamax-bot.service      # Systemd service
/var/log/biosoltamax-bot/                        # Logs
/home/biosoltamax/backups/                       # Database backups
```

---

## ⚠️ Troubleshooting

### Bot Not Starting

```bash
# Check service status
sudo systemctl status biosoltamax-bot

# Check logs
sudo journalctl -u biosoltamax-bot -n 50

# Check if port is in use
sudo netstat -tulpn | grep python

# Test bot manually
cd ~/apps/biosoltamax-bot
source venv/bin/activate
python bot.py
```

### Database Connection Issues

```bash
# Test database connection
psql -h localhost -U biosoltamax_user -d biosoltamax

# Check PostgreSQL status
sudo systemctl status postgresql

# Check database logs
sudo tail -f /var/log/postgresql/postgresql-14-main.log
```

### High Memory Usage

```bash
# Check memory
free -h

# Check processes
htop

# Restart bot
sudo systemctl restart biosoltamax-bot
```

### SSH Connection Issues

```bash
# Check security group allows your IP
# AWS Console > EC2 > Security Groups > biosoltamax-bot-sg

# Check key permissions
chmod 400 biosoltamax-bot-key.pem

# Verbose SSH
ssh -v -i biosoltamax-bot-key.pem ubuntu@YOUR_IP
```

---

## 📚 Next Steps

After successful deployment:

1. ✅ Setup monitoring (CloudWatch, Sentry)
2. ✅ Configure automated backups
3. ✅ Setup CI/CD pipeline (GitHub Actions)
4. ✅ Add rate limiting
5. ✅ Implement logging
6. ✅ Setup SSL certificate (Let's Encrypt)
7. ✅ Configure domain name
8. ✅ Add health check endpoint

---

## 🔗 Resources

- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [AWS Free Tier](https://aws.amazon.com/free/)
- [Ubuntu Server Guide](https://ubuntu.com/server/docs)
- [Systemd Documentation](https://www.freedesktop.org/software/systemd/man/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

**Status:** ✅ Ready to Deploy
**Created:** 2026-03-25
**Last Updated:** 2026-03-25
**Estimated Setup Time:** 30-45 minutes
**Monthly Cost:** $0 (Free Tier) or ~$8/month after

**Good luck! 🚀**
