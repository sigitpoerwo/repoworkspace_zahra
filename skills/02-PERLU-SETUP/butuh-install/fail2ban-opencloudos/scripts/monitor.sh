#!/bin/bash
# Fail2Ban Monitoring Script
# Author: OpenClaw
# Date: 2026-03-15

echo "================================================"
echo "  Fail2Ban Status Monitor"
echo "================================================"
echo ""

# Check if Fail2Ban is installed
if ! command -v fail2ban-client &> /dev/null; then
    echo "❌ Fail2Ban is not installed"
    exit 1
fi

# Service status
echo "📊 Service Status:"
if systemctl is-active --quiet fail2ban; then
    echo "  ✅ Running"
else
    echo "  ❌ Not running"
    echo ""
    echo "Start with: systemctl start fail2ban"
    exit 1
fi

# Uptime
UPTIME=$(systemctl show fail2ban --property=ActiveEnterTimestamp --value)
echo "  Started: $UPTIME"
echo ""

# Overall status
echo "📊 Fail2Ban Status:"
fail2ban-client status
echo ""

# SSH Jail detailed status
echo "📊 SSH Jail Status:"
fail2ban-client status sshd
echo ""

# Banned IPs count
BANNED_COUNT=$(fail2ban-client status sshd | grep "Currently banned" | awk '{print $4}')
echo "🚫 Currently Banned IPs: $BANNED_COUNT"
echo ""

# Show banned IPs if any
if [ "$BANNED_COUNT" -gt 0 ]; then
    echo "📋 Banned IP List:"
    fail2ban-client status sshd | grep "Banned IP list" | cut -d: -f2
    echo ""
fi

# Firewall rules
echo "🔥 Firewall Rules (fail2ban):"
RULES=$(firewall-cmd --list-rich-rules 2>/dev/null | grep fail2ban | wc -l)
echo "  Active rules: $RULES"
if [ "$RULES" -gt 0 ]; then
    firewall-cmd --list-rich-rules | grep fail2ban | head -5
    if [ "$RULES" -gt 5 ]; then
        echo "  ... and $((RULES - 5)) more"
    fi
fi
echo ""

# Recent bans from log
echo "📜 Recent Bans (last 10):"
if [ -f /var/log/fail2ban.log ]; then
    grep "Ban " /var/log/fail2ban.log | tail -10 | while read line; do
        echo "  $line"
    done
else
    echo "  No log file found"
fi
echo ""

# Log file size
if [ -f /var/log/fail2ban.log ]; then
    LOG_SIZE=$(du -h /var/log/fail2ban.log | cut -f1)
    echo "📁 Log File Size: $LOG_SIZE"
    echo "  Location: /var/log/fail2ban.log"
fi
echo ""

# Configuration
echo "⚙️  Configuration:"
if [ -f /etc/fail2ban/jail.local ]; then
    echo "  Max retry: $(grep "^maxretry" /etc/fail2ban/jail.local | head -1 | awk '{print $3}')"
    echo "  Find time: $(grep "^findtime" /etc/fail2ban/jail.local | head -1 | awk '{print $3}')"
    echo "  Ban time: $(grep "^bantime" /etc/fail2ban/jail.local | head -1 | awk '{print $3}')"
fi
echo ""

echo "================================================"
echo "  Quick Commands"
echo "================================================"
echo ""
echo "View live logs:"
echo "  tail -f /var/log/fail2ban.log"
echo ""
echo "Unban IP:"
echo "  fail2ban-client set sshd unbanip <IP>"
echo ""
echo "Restart service:"
echo "  systemctl restart fail2ban"
echo ""
