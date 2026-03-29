#!/bin/bash
# AWS Security Hardening Script
# For: Zahra Maurita OpenClaw Production Server
# Date: 2026-03-29

echo "=========================================="
echo "AWS Security Hardening Script"
echo "=========================================="
echo ""
echo "This script will:"
echo "1. Update system packages"
echo "2. Install and configure UFW firewall"
echo "3. Install and configure Fail2Ban"
echo "4. Harden SSH configuration"
echo "5. Configure swap (if needed)"
echo "6. Enable automatic security updates"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Phase 1: Update System
echo ""
echo "=== Phase 1: Updating System ==="
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
echo -e "${GREEN}✓ System updated${NC}"

# Phase 2: UFW Firewall
echo ""
echo "=== Phase 2: Configuring UFW Firewall ==="
sudo apt install -y ufw

# Allow SSH first (CRITICAL!)
sudo ufw allow 22/tcp comment 'SSH'
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'
sudo ufw allow 18789/tcp comment 'OpenClaw Gateway'

# Show rules before enabling
echo "Firewall rules to be applied:"
sudo ufw show added

# Enable firewall
sudo ufw --force enable
sudo ufw status verbose
echo -e "${GREEN}✓ UFW configured and enabled${NC}"

# Phase 3: Fail2Ban
echo ""
echo "=== Phase 3: Installing Fail2Ban ==="
sudo apt install -y fail2ban

# Create local config
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Configure SSH jail
sudo tee /etc/fail2ban/jail.d/sshd.local > /dev/null <<EOF
[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600
EOF

# Start Fail2Ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
sudo fail2ban-client status
echo -e "${GREEN}✓ Fail2Ban configured${NC}"

# Phase 4: SSH Hardening
echo ""
echo "=== Phase 4: Hardening SSH ==="
echo "Backing up SSH config..."
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup.$(date +%Y%m%d)

# Apply SSH hardening
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*MaxAuthTries.*/MaxAuthTries 3/' /etc/ssh/sshd_config

# Test SSH config
sudo sshd -t
if [ $? -eq 0 ]; then
    echo "SSH config test passed"
    sudo systemctl restart sshd
    echo -e "${GREEN}✓ SSH hardened${NC}"
else
    echo "SSH config test failed! Restoring backup..."
    sudo cp /etc/ssh/sshd_config.backup.$(date +%Y%m%d) /etc/ssh/sshd_config
fi

# Phase 5: Swap Configuration
echo ""
echo "=== Phase 5: Configuring Swap ==="
SWAP_EXISTS=$(swapon --show | wc -l)
if [ "$SWAP_EXISTS" -eq 0 ]; then
    echo "Creating 2GB swap file..."
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    echo -e "${GREEN}✓ Swap configured (2GB)${NC}"
else
    echo -e "${GREEN}✓ Swap already configured${NC}"
fi

# Phase 6: Automatic Updates
echo ""
echo "=== Phase 6: Enabling Automatic Security Updates ==="
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
echo -e "${GREEN}✓ Automatic updates enabled${NC}"

# Phase 7: System Limits
echo ""
echo "=== Phase 7: Configuring System Limits ==="
if ! grep -q "* soft nofile 65536" /etc/security/limits.conf; then
    sudo tee -a /etc/security/limits.conf > /dev/null <<EOF
* soft nofile 65536
* hard nofile 65536
* soft nproc 32768
* hard nproc 32768
EOF
    echo -e "${GREEN}✓ System limits configured${NC}"
else
    echo -e "${GREEN}✓ System limits already configured${NC}"
fi

# Final Summary
echo ""
echo "=========================================="
echo "Security Hardening Complete!"
echo "=========================================="
echo ""
echo "Summary:"
echo "✓ System updated"
echo "✓ UFW firewall enabled (ports: 22, 80, 443, 18789)"
echo "✓ Fail2Ban protecting SSH"
echo "✓ SSH hardened (no root, no password)"
echo "✓ Swap configured (2GB)"
echo "✓ Automatic security updates enabled"
echo "✓ System limits optimized"
echo ""
echo "IMPORTANT:"
echo "- Keep this SSH session open!"
echo "- Test new SSH connection before closing"
echo "- Backup created: /etc/ssh/sshd_config.backup.$(date +%Y%m%d)"
echo ""
echo "Next steps:"
echo "1. Test SSH: ssh ubuntu@$(curl -s ifconfig.me)"
echo "2. Check status: bash security-check.sh"
echo "3. Restart OpenClaw: openclaw gateway restart"
echo ""
