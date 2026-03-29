#!/bin/bash
# AWS Security Check & Hardening Script
# For: Zahra Maurita OpenClaw Production Server
# Date: 2026-03-29

echo "=========================================="
echo "AWS Security Check & Hardening"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. System Information
echo "=== 1. System Information ==="
echo "OS Version:"
lsb_release -a
echo ""
echo "Kernel:"
uname -r
echo ""
echo "Uptime:"
uptime
echo ""

# 2. Check System Updates
echo "=== 2. System Update Status ==="
echo "Checking for updates..."
sudo apt update > /dev/null 2>&1
UPDATES=$(apt list --upgradable 2>/dev/null | grep -c upgradable)
if [ "$UPDATES" -gt 1 ]; then
    echo -e "${RED}⚠ $((UPDATES-1)) packages need update${NC}"
    echo "Run: sudo apt upgrade -y"
else
    echo -e "${GREEN}✓ System is up to date${NC}"
fi
echo ""

# 3. Check UFW Firewall
echo "=== 3. Firewall Status ==="
if command -v ufw &> /dev/null; then
    UFW_STATUS=$(sudo ufw status | grep -c "Status: active")
    if [ "$UFW_STATUS" -eq 1 ]; then
        echo -e "${GREEN}✓ UFW Firewall is active${NC}"
        sudo ufw status numbered
    else
        echo -e "${RED}✗ UFW Firewall is NOT active${NC}"
        echo "Recommendation: Enable UFW"
    fi
else
    echo -e "${RED}✗ UFW not installed${NC}"
    echo "Install: sudo apt install -y ufw"
fi
echo ""

# 4. Check Fail2Ban
echo "=== 4. Fail2Ban Status ==="
if command -v fail2ban-client &> /dev/null; then
    if systemctl is-active --quiet fail2ban; then
        echo -e "${GREEN}✓ Fail2Ban is running${NC}"
        sudo fail2ban-client status
    else
        echo -e "${RED}✗ Fail2Ban installed but not running${NC}"
        echo "Start: sudo systemctl start fail2ban"
    fi
else
    echo -e "${RED}✗ Fail2Ban not installed${NC}"
    echo "Install: sudo apt install -y fail2ban"
fi
echo ""

# 5. Check SSH Configuration
echo "=== 5. SSH Security ==="
echo "Checking SSH config..."
PERMIT_ROOT=$(grep "^PermitRootLogin" /etc/ssh/sshd_config | awk '{print $2}')
PASSWORD_AUTH=$(grep "^PasswordAuthentication" /etc/ssh/sshd_config | awk '{print $2}')

if [ "$PERMIT_ROOT" == "no" ]; then
    echo -e "${GREEN}✓ Root login disabled${NC}"
else
    echo -e "${RED}✗ Root login enabled (PermitRootLogin: $PERMIT_ROOT)${NC}"
fi

if [ "$PASSWORD_AUTH" == "no" ]; then
    echo -e "${GREEN}✓ Password authentication disabled${NC}"
else
    echo -e "${YELLOW}⚠ Password authentication enabled${NC}"
fi
echo ""

# 6. Check Open Ports
echo "=== 6. Open Ports ==="
echo "Listening ports:"
sudo ss -tulpn | grep LISTEN
echo ""

# 7. Check Failed Login Attempts
echo "=== 7. Failed Login Attempts (Last 20) ==="
sudo lastb | head -20
echo ""

# 8. Check Disk Usage
echo "=== 8. Disk Usage ==="
df -h | grep -E "Filesystem|/$"
echo ""

# 9. Check Memory Usage
echo "=== 9. Memory Usage ==="
free -h
echo ""

# 10. Check Swap
echo "=== 10. Swap Status ==="
SWAP=$(free -h | grep Swap | awk '{print $2}')
if [ "$SWAP" == "0B" ]; then
    echo -e "${YELLOW}⚠ No swap configured${NC}"
    echo "Recommendation: Create 2GB swap file"
else
    echo -e "${GREEN}✓ Swap configured: $SWAP${NC}"
fi
echo ""

# 11. Check Unattended Upgrades
echo "=== 11. Automatic Security Updates ==="
if dpkg -l | grep -q unattended-upgrades; then
    echo -e "${GREEN}✓ Unattended-upgrades installed${NC}"
else
    echo -e "${RED}✗ Unattended-upgrades not installed${NC}"
    echo "Install: sudo apt install -y unattended-upgrades"
fi
echo ""

# 12. Check OpenClaw Status
echo "=== 12. OpenClaw Status ==="
if command -v openclaw &> /dev/null; then
    echo -e "${GREEN}✓ OpenClaw installed${NC}"
    openclaw gateway status | grep -E "Runtime|Listening|Gateway"
else
    echo -e "${RED}✗ OpenClaw not found${NC}"
fi
echo ""

# Summary
echo "=========================================="
echo "Security Recommendations"
echo "=========================================="
echo ""

RECOMMENDATIONS=()

if [ "$UPDATES" -gt 1 ]; then
    RECOMMENDATIONS+=("1. Update system: sudo apt update && sudo apt upgrade -y")
fi

if ! command -v ufw &> /dev/null || [ "$UFW_STATUS" -ne 1 ]; then
    RECOMMENDATIONS+=("2. Enable UFW firewall (see hardening script)")
fi

if ! command -v fail2ban-client &> /dev/null; then
    RECOMMENDATIONS+=("3. Install Fail2Ban (see hardening script)")
fi

if [ "$PERMIT_ROOT" != "no" ] || [ "$PASSWORD_AUTH" != "no" ]; then
    RECOMMENDATIONS+=("4. Harden SSH config (see hardening script)")
fi

if [ "$SWAP" == "0B" ]; then
    RECOMMENDATIONS+=("5. Configure swap (see hardening script)")
fi

if ! dpkg -l | grep -q unattended-upgrades; then
    RECOMMENDATIONS+=("6. Enable automatic security updates")
fi

if [ ${#RECOMMENDATIONS[@]} -eq 0 ]; then
    echo -e "${GREEN}✓ All security checks passed!${NC}"
else
    echo -e "${YELLOW}Found ${#RECOMMENDATIONS[@]} recommendations:${NC}"
    for rec in "${RECOMMENDATIONS[@]}"; do
        echo "  $rec"
    done
fi

echo ""
echo "=========================================="
echo "Run hardening script if needed:"
echo "bash security-hardening.sh"
echo "=========================================="
