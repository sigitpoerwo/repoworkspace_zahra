---
name: fail2ban-opencloudos
description: "Install and configure Fail2Ban on OpenCloudOS/CentOS/RHEL 9 for SSH brute-force protection. Use when: securing Linux servers, preventing brute-force attacks, auto-banning malicious IPs, or hardening SSH access."
risk: safe
source: openclaw-workspace
metadata:
  openclaw:
    emoji: "🔒"
    requires:
      bins: ["bash"]
      os: ["linux"]
---

# Fail2Ban for OpenCloudOS

Install and configure Fail2Ban on OpenCloudOS/CentOS/RHEL 9 to protect against SSH brute-force attacks.

## What is Fail2Ban?

Fail2Ban is an intelligent firewall that:
- Monitors log files in real-time (SSH, Apache, Nginx, etc.)
- Auto-bans IPs after N failed login attempts
- Auto-unbans after configurable time period
- Integrates with firewalld/iptables
- Sends email notifications (optional)

## Features

- ✅ SSH brute-force protection
- ✅ Auto-ban after 5 failed attempts
- ✅ Configurable ban duration (default: 1 hour)
- ✅ Firewalld integration
- ✅ Multiple jail support (SSH, Nginx, Apache, WordPress)
- ✅ Email notifications
- ✅ Whitelist trusted IPs
- ✅ Auto-unban after timeout

## Installation

### Quick Install

```bash
# Download and run installation script
curl -O https://raw.githubusercontent.com/your-repo/fail2ban-opencloudos/main/scripts/install.sh
chmod +x install.sh
sudo ./install.sh
```

### Manual Install

```bash
# Copy script to your server
scp scripts/install.sh user@server:/tmp/

# SSH to server and run
ssh user@server
sudo bash /tmp/install.sh
```

## Usage

### Check Status

```bash
# Service status
systemctl status fail2ban

# Fail2Ban status
fail2ban-client status

# SSH jail status
fail2ban-client status sshd

# Or use monitoring script
bash scripts/monitor.sh
```

### View Banned IPs

```bash
# List banned IPs
fail2ban-client status sshd

# View firewall rules
firewall-cmd --list-rich-rules | grep fail2ban
```

### Ban/Unban IP Manually

```bash
# Ban IP
fail2ban-client set sshd banip 1.2.3.4

# Unban IP
fail2ban-client set sshd unbanip 1.2.3.4
```

### View Logs

```bash
# Live log monitoring
tail -f /var/log/fail2ban.log

# Recent bans
grep "Ban " /var/log/fail2ban.log | tail -20

# Systemd logs
journalctl -fu fail2ban
```

## Configuration

### Default Settings

- **Max retry**: 5 attempts
- **Find time**: 10 minutes (window for counting attempts)
- **Ban time**: 1 hour
- **Backend**: polling (compatible mode)

### Customize Settings

Edit `/etc/fail2ban/jail.local`:

```bash
[DEFAULT]
maxretry = 3        # Change to 3 attempts
bantime = 2h        # Change to 2 hours ban
findtime = 5m       # Change to 5 minutes window

[sshd]
enabled = true
maxretry = 5        # Override default for SSH
```

Restart after changes:
```bash
systemctl restart fail2ban
```

### Add More Jails

Use the example config:
```bash
# Copy example config
cp config/jail.local.example /etc/fail2ban/jail.local

# Edit and enable jails you need
nano /etc/fail2ban/jail.local

# Enable nginx protection
[nginx-http-auth]
enabled = true

# Restart
systemctl restart fail2ban
```

### Whitelist IPs

Add trusted IPs to `/etc/fail2ban/jail.local`:

```bash
[DEFAULT]
ignoreip = 127.0.0.1/8 192.168.1.0/24 YOUR_OFFICE_IP
```

## Testing

### Test Ban Mechanism

From another machine:
```bash
# Try 6 failed SSH logins
ssh wronguser@your-server
# (repeat 6 times with wrong password)
```

Check if banned:
```bash
fail2ban-client status sshd
```

### Test Configuration

```bash
# Test config syntax
fail2ban-server -t

# Reload config
fail2ban-client reload
```

## Monitoring Script

Use the included monitoring script:

```bash
bash scripts/monitor.sh
```

Output shows:
- Service status
- Banned IPs count
- Recent bans
- Firewall rules
- Log file size
- Configuration summary

## Troubleshooting

### Service Won't Start

```bash
# Check logs
journalctl -xeu fail2ban
tail -50 /var/log/fail2ban.log

# Test configuration
fail2ban-server -t

# Check permissions
ls -la /var/run/fail2ban
chmod 755 /var/run/fail2ban
```

### Not Banning IPs

```bash
# Check jail is enabled
fail2ban-client status sshd

# Check log path exists
ls -la /var/log/secure

# Check backend
fail2ban-client get sshd backend

# Try changing backend to systemd
[sshd]
backend = systemd
```

### Clear All Bans

```bash
# Unban all IPs
fail2ban-client unban --all

# Or restart service
systemctl restart fail2ban
```

## Uninstallation

```bash
bash scripts/uninstall.sh
```

This will:
- Stop and disable service
- Remove all Fail2Ban files
- Clean firewall rules
- Keep dependencies (git, python3)

## Files

```
fail2ban-opencloudos/
├── SKILL.md                          # This file
├── README.md                         # Quick start guide
├── scripts/
│   ├── install.sh                    # Installation script
│   ├── uninstall.sh                  # Uninstallation script
│   └── monitor.sh                    # Monitoring script
└── config/
    └── jail.local.example            # Example jail config
```

## Requirements

- OpenCloudOS 9 / CentOS 9 / RHEL 9
- Root access or sudo
- Internet connection (for GitHub clone)
- firewalld installed

## Security Best Practices

1. **Whitelist your IPs** - Add your office/home IP to ignoreip
2. **Use SSH keys** - Disable password auth when possible
3. **Change SSH port** - Use non-standard port (e.g., 2222)
4. **Monitor logs** - Check `/var/log/fail2ban.log` regularly
5. **Update regularly** - Keep Fail2Ban updated
6. **Test before production** - Test on staging server first

## Advanced Configuration

### Email Notifications

Edit `/etc/fail2ban/jail.local`:

```bash
[DEFAULT]
destemail = admin@example.com
sendername = Fail2Ban@hostname
action = %(action_mwl)s
```

### Custom Ban Actions

Create custom action in `/etc/fail2ban/action.d/`:

```bash
[Definition]
actionban = <your-custom-command>
actionunban = <your-custom-unban-command>
```

### Integration with Telegram

Use webhook action to send notifications to Telegram when IPs are banned.

## Comparison with Alternatives

| Feature | Fail2Ban | SSHGuard | DenyHosts |
|---------|----------|----------|-----------|
| Multiple Jails | ✅ | ❌ | ❌ |
| Email Alerts | ✅ | ❌ | ✅ |
| Custom Filters | ✅ | ❌ | ❌ |
| Auto-Unban | ✅ | ✅ | ✅ |
| Firewall Integration | ✅ | ✅ | ❌ |
| Installation | Source | Repo | Repo |

## Resources

- Official Docs: https://fail2ban.readthedocs.io/
- GitHub: https://github.com/fail2ban/fail2ban
- Community Forum: https://forum.fail2ban.org/

## Credits

- Tutorial by: OpenClaw Community
- Tested on: OpenCloudOS 9
- Last Updated: 2026-03-15

## Tags

#security #fail2ban #ssh #firewall #opencloudos #centos #rhel #brute-force-protection
