# Fail2Ban for OpenCloudOS - Quick Start

Protect your Linux server from SSH brute-force attacks with automatic IP banning.

## 🚀 Quick Install

### One-Line Install

```bash
curl -O https://raw.githubusercontent.com/your-repo/fail2ban-opencloudos/main/scripts/install.sh
chmod +x install.sh
sudo ./install.sh
```

### Manual Steps

1. **Copy script to server:**
   ```bash
   scp scripts/install.sh user@your-server:/tmp/
   ```

2. **SSH to server:**
   ```bash
   ssh user@your-server
   ```

3. **Run installation:**
   ```bash
   sudo bash /tmp/install.sh
   ```

## ✅ Verify Installation

```bash
# Check service status
systemctl status fail2ban

# Check Fail2Ban status
fail2ban-client status

# Check SSH protection
fail2ban-client status sshd
```

Expected output:
```
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     0
|  `- File list:        /var/log/secure
`- Actions
   |- Currently banned: 0
   |- Total banned:     0
   `- Banned IP list:
```

## 📊 Monitor Status

Use the monitoring script:

```bash
bash scripts/monitor.sh
```

## 🔧 Common Tasks

### View Banned IPs

```bash
fail2ban-client status sshd
```

### Unban IP

```bash
fail2ban-client set sshd unbanip 1.2.3.4
```

### View Logs

```bash
tail -f /var/log/fail2ban.log
```

### Restart Service

```bash
systemctl restart fail2ban
```

## ⚙️ Configuration

Default settings:
- **Max retry**: 5 attempts
- **Find time**: 10 minutes
- **Ban time**: 1 hour

To customize, edit `/etc/fail2ban/jail.local`:

```bash
sudo nano /etc/fail2ban/jail.local
sudo systemctl restart fail2ban
```

## 🧪 Test Protection

From another machine, try 6 failed SSH logins:

```bash
ssh wronguser@your-server
# (repeat 6 times with wrong password)
```

Check if IP is banned:

```bash
fail2ban-client status sshd
```

## 🛡️ Security Tips

1. **Whitelist your IP:**
   ```bash
   # Add to /etc/fail2ban/jail.local
   [DEFAULT]
   ignoreip = 127.0.0.1/8 YOUR_IP
   ```

2. **Use SSH keys** instead of passwords

3. **Change SSH port** to non-standard (e.g., 2222)

4. **Monitor logs** regularly:
   ```bash
   tail -f /var/log/fail2ban.log
   ```

## 📚 More Info

See `SKILL.md` for complete documentation including:
- Advanced configuration
- Multiple jail setup (Nginx, Apache, WordPress)
- Email notifications
- Troubleshooting guide

## 🗑️ Uninstall

```bash
bash scripts/uninstall.sh
```

## 📋 Files

```
fail2ban-opencloudos/
├── README.md              # This file
├── SKILL.md               # Full documentation
├── scripts/
│   ├── install.sh         # Installation script
│   ├── uninstall.sh       # Uninstallation script
│   └── monitor.sh         # Monitoring script
└── config/
    └── jail.local.example # Example configuration
```

## 🆘 Troubleshooting

**Service won't start?**
```bash
journalctl -xeu fail2ban
fail2ban-server -t
```

**Not banning IPs?**
```bash
fail2ban-client status sshd
ls -la /var/log/secure
```

**Need help?**
- Check logs: `tail -50 /var/log/fail2ban.log`
- Test config: `fail2ban-server -t`
- See full docs: `SKILL.md`

---

**Last Updated:** 2026-03-15  
**Tested On:** OpenCloudOS 9, CentOS 9, RHEL 9
