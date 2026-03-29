# Deployment Guide - AWS OpenClaw

## Quick Deploy to AWS

### Prerequisites
- AWS EC2 instance (Ubuntu 22.04+)
- SSH access to instance
- GitHub account

### Step 1: Prepare Local Workspace

```bash
# Clone this repo
git clone https://github.com/sigitpoerwo/repoworkspace_zahra.git
cd joniaws-workspace

# Verify files
ls -la
```

### Step 2: Connect to AWS

```bash
# SSH to your EC2 instance
ssh -i ~/.ssh/your-key.pem ubuntu@YOUR_EC2_IP
```

### Step 3: Install OpenClaw on AWS

Follow complete guide in `AWS_OPENCLAW_INSTALL_GUIDE.md` or quick install:

```bash
# Install Node.js 24
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install 24
nvm use 24

# Install OpenClaw
npm install -g openclaw

# Setup
openclaw setup
```

### Step 4: Deploy Workspace to AWS (SAFE MERGE)

**IMPORTANT:** This will merge Zahra workspace with your existing workspace WITHOUT overwriting.

```bash
# Backup existing workspace first
cd ~
tar -czf openclaw-workspace-backup-$(date +%Y%m%d-%H%M%S).tar.gz .openclaw/workspace/

# Clone to temporary directory
cd /tmp
git clone https://github.com/sigitpoerwo/repoworkspace_zahra.git zahra-temp

# Merge safely (preserves existing files)
cd ~/.openclaw/workspace

# Copy only NEW files (won't overwrite existing)
rsync -av --ignore-existing /tmp/zahra-temp/ ./

# Merge skills (add new, keep existing)
rsync -av /tmp/zahra-temp/skills/ ./skills/

# Cleanup
rm -rf /tmp/zahra-temp

# Verify merge
ls -la
```

**What Gets Preserved:**
- ✅ Your existing IDENTITY.md, SOUL.md, AGENTS.md
- ✅ Your AutoResearchClaw folder
- ✅ Your threads templates
- ✅ Your memory, projects, configs

**What Gets Added:**
- ✅ 663 Zahra skills (merged with existing)
- ✅ Additional docs (GROWTH.md, IDE configs, etc.)
- ✅ New tools and capabilities

### Step 5: Configure API Keys

```bash
# Edit OpenClaw config
nano ~/.openclaw/openclaw.json
```

Add your API keys:
```json
{
  "agents": {
    "main": {
      "model": "anthropic/claude-opus-4-6",
      "thinking": "high"
    }
  },
  "providers": {
    "anthropic": {
      "apiKey": "YOUR_API_KEY"
    }
  },
  "messaging": {
    "telegram": {
      "enabled": true,
      "token": "YOUR_BOT_TOKEN",
      "allowedUsers": [YOUR_USER_ID]
    }
  },
  "gateway": {
    "mode": "local",
    "port": 18789
  }
}
```

### Step 6: Start Gateway

```bash
# Start gateway
openclaw gateway start

# Check status
openclaw gateway status

# View logs
openclaw logs
```

### Step 7: Configure Firewall

```bash
# Allow OpenClaw port
sudo ufw allow 18789/tcp comment 'OpenClaw Gateway'
sudo ufw reload

# Verify
sudo ufw status
```

### Step 8: Test Deployment

```bash
# Test locally
curl http://localhost:18789/health

# Test from outside (use your EC2 public IP)
curl http://YOUR_EC2_PUBLIC_IP:18789/health
```

### Step 9: Test Telegram Bot

1. Open Telegram
2. Search for your bot
3. Send `/start`
4. Bot should respond with Zahra Maurita identity

## Production Optimization

### 1. Security Hardening

```bash
# UFW Firewall
sudo ufw enable
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 18789/tcp

# Fail2Ban
sudo apt install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### 2. Auto-Start with Systemd

Gateway already runs as systemd service:

```bash
# Check service status
systemctl --user status openclaw-gateway

# Enable auto-start
systemctl --user enable openclaw-gateway

# Restart service
systemctl --user restart openclaw-gateway
```

### 3. Monitoring

```bash
# View logs
openclaw logs --follow

# Check gateway health
openclaw health

# Monitor resources
htop
```

### 4. Backup Configuration

```bash
# Backup OpenClaw config
cp ~/.openclaw/openclaw.json ~/openclaw-config-backup.json

# Backup workspace
cd ~/.openclaw/workspace
git add .
git commit -m "Backup workspace $(date +%Y-%m-%d)"
git push origin main
```

## Updating Workspace

### Pull Latest Changes

```bash
cd ~/.openclaw/workspace
git pull origin main
openclaw gateway restart
```

### Push Local Changes

```bash
cd ~/.openclaw/workspace
git add .
git commit -m "Update workspace"
git push origin main
```

## Troubleshooting

### Gateway Won't Start

```bash
# Check logs
openclaw logs

# Run doctor
openclaw doctor --fix

# Check port
sudo netstat -tulpn | grep 18789
```

### Telegram Bot Not Responding

```bash
# Check gateway status
openclaw gateway status

# Verify config
cat ~/.openclaw/openclaw.json | grep telegram

# Check logs
openclaw logs | grep telegram
```

### Skills Not Loading

```bash
# Verify skills directory
ls -la ~/.openclaw/workspace/skills/

# Restart gateway
openclaw gateway restart
```

## Rollback

### Restore Previous Version

```bash
cd ~/.openclaw/workspace
git log --oneline
git checkout COMMIT_HASH
openclaw gateway restart
```

### Restore Config

```bash
cp ~/openclaw-config-backup.json ~/.openclaw/openclaw.json
openclaw gateway restart
```

## Monitoring & Maintenance

### Daily Checks

```bash
# Health check
openclaw health

# Gateway status
openclaw gateway status

# Disk space
df -h

# Memory usage
free -h
```

### Weekly Maintenance

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Update OpenClaw
openclaw update

# Clean logs
find /tmp/openclaw -name "*.log" -mtime +7 -delete
```

### Monthly Backup

```bash
# Backup everything
tar -czf ~/openclaw-backup-$(date +%Y%m%d).tar.gz ~/.openclaw/

# Upload to S3 (optional)
aws s3 cp ~/openclaw-backup-$(date +%Y%m%d).tar.gz s3://your-bucket/
```

## Cost Optimization

### AWS EC2 Recommendations

- **Development:** t3.medium (2 vCPU, 4GB RAM) - ~$30/month
- **Production:** t3.large (2 vCPU, 8GB RAM) - ~$60/month
- **High Traffic:** m7i-flex.large (2 vCPU, 8GB RAM) - ~$80/month

### API Cost Management

- Use cheaper models for simple tasks
- Enable caching in OpenClaw
- Monitor API usage via provider dashboards

## Support

- **OpenClaw Docs:** https://docs.openclaw.ai
- **AWS Guide:** `AWS_OPENCLAW_INSTALL_GUIDE.md`
- **Setup Guide:** `SETUP.md`
- **Structure:** `STRUCTURE.md`

---

**Deployment Time:** ~30 minutes
**Status:** Production Ready ✅
**Last Updated:** 2026-03-29
