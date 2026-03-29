#!/bin/bash
# Fail2Ban Installation Script for OpenCloudOS/CentOS/RHEL 9
# Author: OpenClaw
# Date: 2026-03-15

set -e

echo "================================================"
echo "  Fail2Ban Installation for OpenCloudOS"
echo "================================================"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run as root or with sudo"
    exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
    echo "✅ Detected OS: $OS $VER"
else
    echo "❌ Cannot detect OS"
    exit 1
fi

echo ""
echo "Step 1: Installing dependencies..."
dnf -y install git python3 python3-setuptools python3-systemd firewalld

echo ""
echo "Step 2: Enabling firewalld..."
systemctl enable --now firewalld

echo ""
echo "Step 3: Cloning Fail2Ban from GitHub..."
rm -rf /usr/local/src/fail2ban
git clone --depth 1 https://github.com/fail2ban/fail2ban.git /usr/local/src/fail2ban

echo ""
echo "Step 4: Installing Fail2Ban..."
cd /usr/local/src/fail2ban
python3 setup.py install

echo ""
echo "Step 5: Creating runtime directory..."
mkdir -p /var/run/fail2ban

echo ""
echo "Step 6: Configuring Fail2Ban..."
cat > /etc/fail2ban/fail2ban.local <<'EOF'
[Definition]
socket = /var/run/fail2ban/fail2ban.sock
pidfile = /var/run/fail2ban/fail2ban.pid
loglevel = INFO
logtarget = /var/log/fail2ban.log
EOF

echo ""
echo "Step 7: Configuring SSH jail..."
cat > /etc/fail2ban/jail.local <<'EOF'
[DEFAULT]
banaction = firewallcmd-rich-rules
findtime = 10m
bantime = 1h
maxretry = 5
ignoreip = 127.0.0.1/8 ::1

[sshd]
enabled = true
backend = polling
logpath = /var/log/secure
port = ssh
protocol = tcp
EOF

echo ""
echo "Step 8: Creating systemd service..."
cat > /etc/systemd/system/fail2ban.service <<'EOF'
[Unit]
Description=Fail2Ban Service
After=network.target firewalld.service
Wants=firewalld.service

[Service]
Type=forking
PIDFile=/var/run/fail2ban/fail2ban.pid
ExecStart=/usr/local/bin/fail2ban-server -b -x -c /etc/fail2ban start
ExecStop=/usr/local/bin/fail2ban-client -s /var/run/fail2ban/fail2ban.sock stop
ExecReload=/usr/local/bin/fail2ban-client -s /var/run/fail2ban/fail2ban.sock reload
Restart=on-failure
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

echo ""
echo "Step 9: Enabling and starting Fail2Ban..."
systemctl daemon-reload
systemctl enable fail2ban
systemctl start fail2ban

echo ""
echo "Step 10: Verifying installation..."
sleep 2

if systemctl is-active --quiet fail2ban; then
    echo "✅ Fail2Ban service is running"
else
    echo "❌ Fail2Ban service failed to start"
    echo "Check logs: journalctl -xeu fail2ban"
    exit 1
fi

# Test connection
if /usr/local/bin/fail2ban-client -s /var/run/fail2ban/fail2ban.sock ping &>/dev/null; then
    echo "✅ Fail2Ban client connection OK"
else
    echo "❌ Cannot connect to Fail2Ban server"
    exit 1
fi

# Show status
echo ""
echo "================================================"
echo "  ✅ Installation Complete!"
echo "================================================"
echo ""
echo "📊 Status:"
/usr/local/bin/fail2ban-client -s /var/run/fail2ban/fail2ban.sock status

echo ""
echo "📊 SSH Jail Status:"
/usr/local/bin/fail2ban-client -s /var/run/fail2ban/fail2ban.sock status sshd

echo ""
echo "================================================"
echo "  📚 Useful Commands"
echo "================================================"
echo ""
echo "Check status:"
echo "  systemctl status fail2ban"
echo "  fail2ban-client status"
echo "  fail2ban-client status sshd"
echo ""
echo "View logs:"
echo "  tail -f /var/log/fail2ban.log"
echo "  journalctl -fu fail2ban"
echo ""
echo "Ban/Unban IP:"
echo "  fail2ban-client set sshd banip 1.2.3.4"
echo "  fail2ban-client set sshd unbanip 1.2.3.4"
echo ""
echo "View banned IPs:"
echo "  fail2ban-client status sshd"
echo "  firewall-cmd --list-rich-rules | grep fail2ban"
echo ""
echo "================================================"
echo "  🔒 Your SSH is now protected!"
echo "================================================"
echo ""
echo "Configuration:"
echo "  - Max retry: 5 attempts"
echo "  - Find time: 10 minutes"
echo "  - Ban time: 1 hour"
echo "  - Log: /var/log/fail2ban.log"
echo ""
echo "Next steps:"
echo "  1. Monitor logs: tail -f /var/log/fail2ban.log"
echo "  2. Test ban: Try 6 failed SSH logins from another IP"
echo "  3. Customize: Edit /etc/fail2ban/jail.local"
echo "  4. Add more jails: nginx, apache, etc."
echo ""
