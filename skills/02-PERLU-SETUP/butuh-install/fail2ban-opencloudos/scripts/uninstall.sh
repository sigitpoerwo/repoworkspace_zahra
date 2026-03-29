#!/bin/bash
# Fail2Ban Uninstallation Script
# Author: OpenClaw
# Date: 2026-03-15

set -e

echo "================================================"
echo "  Fail2Ban Uninstallation"
echo "================================================"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run as root or with sudo"
    exit 1
fi

echo "⚠️  This will remove Fail2Ban completely"
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "Step 1: Stopping Fail2Ban service..."
systemctl stop fail2ban || true

echo ""
echo "Step 2: Disabling service..."
systemctl disable fail2ban || true

echo ""
echo "Step 3: Removing systemd service..."
rm -f /etc/systemd/system/fail2ban.service
systemctl daemon-reload

echo ""
echo "Step 4: Removing Fail2Ban files..."
rm -rf /usr/local/bin/fail2ban-*
rm -rf /usr/local/lib/python*/site-packages/fail2ban*
rm -rf /etc/fail2ban
rm -rf /var/run/fail2ban
rm -rf /var/log/fail2ban.log

echo ""
echo "Step 5: Removing source files..."
rm -rf /usr/local/src/fail2ban

echo ""
echo "Step 6: Cleaning firewall rules..."
# Remove all fail2ban rich rules
firewall-cmd --permanent --list-rich-rules | grep fail2ban | while read rule; do
    firewall-cmd --permanent --remove-rich-rule="$rule" || true
done
firewall-cmd --reload || true

echo ""
echo "================================================"
echo "  ✅ Fail2Ban Uninstalled"
echo "================================================"
echo ""
echo "Note: Dependencies (git, python3, firewalld) were NOT removed"
echo "Remove manually if needed: dnf remove git python3-setuptools"
echo ""
