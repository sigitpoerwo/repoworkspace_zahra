# 🚀 AWS EC2 Deployment Guide - Biosoltamax Bot

**Based on:** Gomilku Bot deployment (proven & tested)
**Date:** 2026-03-27
**Purpose:** Step-by-step guide untuk deploy Biosoltamax Bot ke AWS EC2

---

## 📋 CHECKLIST PERSIAPAN

### Yang Sudah Siap ✅
- ✅ Bot code updated (AI model llama-3.1-70b)
- ✅ GitHub repo ready (https://github.com/sigitpoerwo/biosoltamax_bot.git)
- ✅ Credentials backup aman
- ✅ Documentation complete

### Yang Perlu Disiapkan 🔧
- [ ] AWS EC2 instance (t2.micro atau t3.micro)
- [ ] SSH key pair (.pem file)
- [ ] Security group (allow SSH port 22)

---

## 🎯 LANGKAH-LANGKAH DEPLOYMENT

### **STEP 1: Setup AWS EC2 Instance**

#### 1.1 Launch EC2 Instance
1. Login ke AWS Console
2. Go to EC2 Dashboard
3. Click **"Launch Instance"**

#### 1.2 Configure Instance
```
Name: biosoltamax-bot
OS: Ubuntu 20.04 LTS atau 22.04 LTS
Instance type: t2.micro (free tier) atau t2.small
Storage: 8GB (default OK)
```

#### 1.3 Create/Select Key Pair
```
Key pair name: biosoltamax-bot-key
Type: RSA
Format: .pem
```
**Download dan simpan file .pem!**

#### 1.4 Security Group
```
Name: biosoltamax-bot-sg
Inbound rules:
- SSH (22) from My IP
```

#### 1.5 Launch Instance
- Click **"Launch Instance"**
- Wait sampai status **"Running"**
- Copy **Public IPv4 address**

---

### **STEP 2: Connect ke EC2**

#### 2.1 Set Permission Key File (Windows)
```powershell
# Di PowerShell
icacls biosoltamax-bot-key.pem /inheritance:r
icacls biosoltamax-bot-key.pem /grant:r "%username%:R"
```

#### 2.2 Connect via SSH
```bash
ssh -i biosoltamax-bot-key.pem ubuntu@YOUR_EC2_IP
```

**Contoh:**
```bash
ssh -i biosoltamax-bot-key.pem ubuntu@54.123.45.67
```

Ketik **"yes"** saat diminta confirm.

---

### **STEP 3: Setup Server**

#### 3.1 Update System
```bash
sudo apt-get update
sudo apt-get upgrade -y
```

#### 3.2 Install Dependencies
```bash
# Install Python, pip, git
sudo apt-get install -y python3 python3-pip python3-venv git curl

# Verify installation
python3 --version
git --version
```

#### 3.3 Create Apps Directory
```bash
mkdir -p ~/apps
cd ~/apps
```

---

### **STEP 4: Clone Repository**

#### 4.1 Clone dari GitHub
```bash
cd ~/apps
git clone https://github.com/sigitpoerwo/biosoltamax_bot.git
cd biosoltamax_bot
```

#### 4.2 Verify Files
```bash
ls -la
```

Should see:
- bot.py
- ai_consultant.py
- database.py
- requirements.txt
- .env.example
- README.md

---

### **STEP 5: Setup Python Environment**

#### 5.1 Create Virtual Environment
```bash
python3 -m venv bot-env
```

#### 5.2 Activate Virtual Environment
```bash
source bot-env/bin/activate
```

Prompt akan berubah jadi: `(bot-env) ubuntu@...`

#### 5.3 Install Dependencies
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

---

### **STEP 6: Configure Environment Variables**

#### 6.1 Create .env File
```bash
cp .env.example .env
nano .env
```

#### 6.2 Fill Credentials
```env
TELEGRAM_BOT_TOKEN=8739046232:AAFESxPD__IFFybReA_aXgJ1Cf6snkU8XYU
ADMIN_CHANNEL_ID=
NVIDIA_API_KEY=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
NVIDIA_API_URL=https://integrate.api.nvidia.com/v1
NVIDIA_MODEL=meta/llama-3.1-70b-instruct
DATABASE_URL=sqlite:///biosoltamax.db
```

**Save:** `Ctrl+O`, `Enter`, `Ctrl+X`

---

### **STEP 7: Test Bot**

#### 7.1 Initialize Database
```bash
python3 -c "from database import init_database; init_database()"
```

#### 7.2 Run Bot (Test)
```bash
python3 bot.py
```

**Expected output:**
```
🚀 Starting Biosoltamax Bot
💬 AI Consultation: ✅ Enabled
Application started
```

#### 7.3 Test di Telegram
- Buka Telegram
- Search bot: @biosoltamax_bot
- Send: `/start`
- Bot harus respond!

#### 7.4 Stop Test
Press `Ctrl+C`

---

### **STEP 8: Run Bot in Background**

#### 8.1 Start Bot
```bash
nohup python3 bot.py > bot.log 2>&1 &
```

#### 8.2 Verify Running
```bash
ps aux | grep bot.py
```

Should see process running.

#### 8.3 Check Logs
```bash
tail -f bot.log
```

Press `Ctrl+C` to exit log view.

---

### **STEP 9: Create Management Scripts**

#### 9.1 Start Script
```bash
nano start-bot.sh
```

Paste:
```bash
#!/bin/bash
cd ~/apps/biosoltamax_bot

echo "🛑 Stopping existing bot..."
pkill -f "python.*bot.py"
sleep 2

echo "🔧 Activating virtual environment..."
source bot-env/bin/activate

echo "🚀 Starting bot..."
nohup python3 bot.py > bot.log 2>&1 &

sleep 3

if ps aux | grep -v grep | grep "python.*bot.py" > /dev/null; then
    echo "✅ Bot started successfully!"
    echo "📊 Process ID: $(pgrep -f 'python.*bot.py')"
else
    echo "❌ Failed to start bot"
fi
```

Save: `Ctrl+O`, `Enter`, `Ctrl+X`

#### 9.2 Stop Script
```bash
nano stop-bot.sh
```

Paste:
```bash
#!/bin/bash
echo "🛑 Stopping bot..."
pkill -f "python.*bot.py"
sleep 2

if ps aux | grep -v grep | grep "python.*bot.py" > /dev/null; then
    echo "⚠️ Bot still running, force killing..."
    pkill -9 -f "python.*bot.py"
else
    echo "✅ Bot stopped successfully!"
fi
```

#### 9.3 Restart Script
```bash
nano restart-bot.sh
```

Paste:
```bash
#!/bin/bash
cd ~/apps/biosoltamax_bot
./stop-bot.sh
sleep 2
./start-bot.sh
```

#### 9.4 Status Script
```bash
nano status-bot.sh
```

Paste:
```bash
#!/bin/bash
echo "📊 Bot Status"
echo "===================="

if ps aux | grep -v grep | grep "python.*bot.py" > /dev/null; then
    PID=$(pgrep -f 'python.*bot.py')
    echo "✅ Bot is RUNNING"
    echo "📍 Process ID: $PID"
    echo "💾 Memory: $(ps -p $PID -o rss= | awk '{print $1/1024 " MB"}')"
    echo "⏱️ Uptime: $(ps -p $PID -o etime= | xargs)"
    echo ""
    echo "📝 Last 10 log lines:"
    tail -10 ~/apps/biosoltamax_bot/bot.log
else
    echo "❌ Bot is NOT running"
fi
```

#### 9.5 Make Executable
```bash
chmod +x *.sh
```

---

### **STEP 10: Setup Git Credentials (Optional)**

#### 10.1 Create Setup Script
```bash
nano setup-git-credential.sh
```

Paste:
```bash
#!/bin/bash
read -p "GitHub Username: " GH_USERNAME
read -sp "GitHub Token: " GH_TOKEN
echo ""

cd ~/apps/biosoltamax_bot
git config credential.helper store
echo "https://${GH_USERNAME}:${GH_TOKEN}@github.com" > ~/.git-credentials
chmod 600 ~/.git-credentials

git pull origin main
echo "✅ Git credential setup complete!"
```

#### 10.2 Run Setup
```bash
chmod +x setup-git-credential.sh
./setup-git-credential.sh
```

Enter:
- Username: `sigitpoerwo`
- Token: (GitHub Personal Access Token)

---

### **STEP 11: Setup Auto-Update (Optional)**

#### 11.1 Create Auto-Update Script
```bash
nano auto-update.sh
```

Paste:
```bash
#!/bin/bash
cd ~/apps/biosoltamax_bot

git fetch origin main
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" != "$REMOTE" ]; then
    echo "$(date): Update detected, pulling changes..."
    git pull origin main

    source bot-env/bin/activate
    pip install -r requirements.txt --quiet

    pkill -f "python.*bot.py"
    sleep 2
    nohup python3 bot.py > bot.log 2>&1 &

    echo "$(date): Bot updated and restarted"
else
    echo "$(date): No update needed"
fi
```

#### 11.2 Make Executable
```bash
chmod +x auto-update.sh
```

#### 11.3 Add to Cron (Check every 5 minutes)
```bash
crontab -e
```

Add line:
```
*/5 * * * * /home/ubuntu/apps/biosoltamax_bot/auto-update.sh >> /home/ubuntu/apps/biosoltamax_bot/auto-update.log 2>&1
```

Save: `Ctrl+O`, `Enter`, `Ctrl+X`

---

## 🎮 MANAGEMENT COMMANDS

### Daily Operations
```bash
# Start bot
./start-bot.sh

# Stop bot
./stop-bot.sh

# Restart bot
./restart-bot.sh

# Check status
./status-bot.sh

# View logs
tail -f bot.log

# View last 50 lines
tail -50 bot.log
```

### Troubleshooting
```bash
# Check if bot is running
ps aux | grep bot.py

# Kill bot manually
pkill -f "python.*bot.py"

# Check errors in log
grep ERROR bot.log

# Restart bot
./restart-bot.sh
```

### Updates
```bash
# Manual update
cd ~/apps/biosoltamax_bot
git pull origin main
./restart-bot.sh

# Check auto-update log
tail -f auto-update.log
```

---

## 🐛 TROUBLESHOOTING

### Bot Not Starting
```bash
# Check logs
tail -50 bot.log

# Check .env file
cat .env

# Verify dependencies
source bot-env/bin/activate
pip list

# Reinstall dependencies
pip install -r requirements.txt
```

### Bot Crashes
```bash
# Check error logs
grep ERROR bot.log

# Restart bot
./restart-bot.sh

# Monitor in real-time
tail -f bot.log
```

### Database Issues
```bash
# Reset database
rm biosoltamax.db
python3 -c "from database import init_database; init_database()"
./restart-bot.sh
```

### Network Issues
```bash
# Test NVIDIA API
curl -X POST https://integrate.api.nvidia.com/v1/chat/completions \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"meta/llama-3.1-70b-instruct","messages":[{"role":"user","content":"test"}],"max_tokens":10}'

# Test Telegram API
curl https://api.telegram.org/bot8739046232:AAFESxPD__IFFybReA_aXgJ1Cf6snkU8XYU/getMe
```

---

## ✅ DEPLOYMENT CHECKLIST

- [ ] EC2 instance launched
- [ ] SSH connection working
- [ ] System updated
- [ ] Dependencies installed
- [ ] Repository cloned
- [ ] Virtual environment created
- [ ] Dependencies installed
- [ ] .env configured
- [ ] Database initialized
- [ ] Bot tested manually
- [ ] Bot running in background
- [ ] Management scripts created
- [ ] Git credentials setup (optional)
- [ ] Auto-update setup (optional)
- [ ] Bot responds in Telegram

---

## 📞 SUPPORT

**If you need help:**
1. Check logs: `tail -50 bot.log`
2. Check status: `./status-bot.sh`
3. Restart bot: `./restart-bot.sh`
4. Contact: info@biosoltamax.id

---

## 🔐 SECURITY NOTES

1. **Never commit .env** - Already in .gitignore ✅
2. **Keep SSH key secure** - Don't share .pem file
3. **Update system regularly** - `sudo apt-get update && sudo apt-get upgrade`
4. **Monitor logs** - Check for suspicious activity
5. **Backup database** - `cp biosoltamax.db biosoltamax.db.backup`

---

**Last Updated:** 2026-03-27T11:04:00Z
**Status:** ✅ Ready for Deployment
**Estimated Time:** 30-45 minutes
