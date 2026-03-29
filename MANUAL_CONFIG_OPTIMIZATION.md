# Manual OpenClaw Config Optimization Guide
# Untuk: Joni AWS - Responsive, Cerdas, Memori Kuat, Gercep
# Date: 2026-03-29

## Langkah 1: Backup Config

```bash
cd ~/.openclaw
cp openclaw.json openclaw.json.backup.$(date +%Y%m%d-%H%M%S)
```

## Langkah 2: Cek Config Sekarang

```bash
cat ~/.openclaw/openclaw.json | jq
```

## Langkah 3: Edit Config

```bash
nano ~/.openclaw/openclaw.json
```

## Optimasi yang Perlu Ditambahkan/Diubah

### 1. Gateway (Agar Telegram Bot Bisa Akses)

Cari bagian `"gateway"` dan pastikan seperti ini:

```json
"gateway": {
  "mode": "local",
  "port": 18789,
  "bind": "lan"
}
```

**Penting:** `"bind": "lan"` atau `"bind": "0.0.0.0"` (bukan "loopback")

### 2. Agents (Agar Lebih Cerdas & Responsive)

Cari bagian `"agents"` dan tambahkan/ubah:

```json
"agents": {
  "main": {
    "model": "JANGAN_GANTI_MODEL_YANG_ADA",
    "thinking": "high",
    "temperature": 0.7,
    "maxTokens": 8192
  }
}
```

**Catatan:** Jangan ganti model, pakai yang sudah ada. Hanya ubah:
- `"thinking": "high"` - Lebih cerdas
- `"maxTokens": 8192` - Response lebih panjang

### 3. Memory (Agar Ingat Conversation)

Tambahkan bagian ini (kalau belum ada):

```json
"memory": {
  "enabled": true,
  "type": "file",
  "maxSize": 10000,
  "ttl": 86400
}
```

### 4. Performance (Agar Gercep)

Tambahkan bagian ini (kalau belum ada):

```json
"performance": {
  "caching": true,
  "compression": true,
  "maxConcurrentRequests": 10
}
```

### 5. Skills (Auto Load)

Tambahkan bagian ini (kalau belum ada):

```json
"skills": {
  "autoLoad": true,
  "paths": [
    "~/.openclaw/workspace/skills"
  ]
}
```

### 6. Workspace & Projects (Terpisah & Terorganisir)

Tambahkan bagian ini untuk memisahkan workspace dan projects:

```json
"workspace": {
  "path": "~/.openclaw/workspace",
  "autoSync": true
},
"projects": {
  "path": "~/.openclaw/projects",
  "autoCreate": true,
  "templates": true
}
```

**Struktur Folder:**
- `~/.openclaw/workspace/` - Skills, identity, memory (sistem)
- `~/.openclaw/projects/` - Project-project user (terpisah)

### 7. Logging (Untuk Monitoring)

```json
"logging": {
  "level": "info",
  "file": true,
  "console": true
}
```

## Contoh Config Lengkap (Template)

```json
{
  "agents": {
    "main": {
      "model": "YOUR_CURRENT_MODEL",
      "thinking": "high",
      "temperature": 0.7,
      "maxTokens": 8192
    }
  },
  "providers": {
    "anthropic": {
      "apiKey": "YOUR_API_KEY"
    }
  },
  "gateway": {
    "mode": "local",
    "port": 18789,
    "bind": "lan"
  },
  "messaging": {
    "telegram": {
      "enabled": true,
      "token": "YOUR_BOT_TOKEN",
      "allowedUsers": [YOUR_USER_ID],
      "polling": true,
      "pollingInterval": 1000
    }
  },
  "memory": {
    "enabled": true,
    "type": "file",
    "maxSize": 10000,
    "ttl": 86400
  },
  "logging": {
    "level": "info",
    "file": true,
    "console": true
  },
  "skills": {
    "autoLoad": true,
    "paths": [
      "~/.openclaw/workspace/skills"
    ]
  },
  "workspace": {
    "path": "~/.openclaw/workspace",
    "autoSync": true
  },
  "projects": {
    "path": "~/.openclaw/projects",
    "autoCreate": true,
    "templates": true
  },
  "performance": {
    "caching": true,
    "compression": true,
    "maxConcurrentRequests": 10
  }
}
```

## Langkah 4: Validasi Config

Setelah edit, cek apakah JSON valid:

```bash
cat ~/.openclaw/openclaw.json | jq
```

Kalau ada error, berarti ada typo (koma, kurung, dll).

## Langkah 5: Restart Gateway

```bash
openclaw gateway restart
```

## Langkah 6: Verify

```bash
openclaw gateway status
```

Pastikan:
- ✓ Runtime: running
- ✓ Listening: *:18789 (bukan 127.0.0.1:18789)

## Langkah 7: Test Telegram Bot

Kirim pesan ke @joniaws_bot - harusnya lebih responsive dan cerdas!

## Troubleshooting

### Gateway tidak start setelah edit config

```bash
# Cek logs
openclaw logs | tail -50

# Restore backup
cp ~/.openclaw/openclaw.json.backup.TIMESTAMP ~/.openclaw/openclaw.json
openclaw gateway restart
```

### Telegram bot tidak respond

```bash
# Cek apakah listening di 0.0.0.0
openclaw gateway status | grep Listening

# Harusnya: Listening: *:18789
# Bukan: Listening: 127.0.0.1:18789
```

## Yang JANGAN Diubah

❌ Jangan ganti model (pakai yang sudah ada)
❌ Jangan hapus API keys
❌ Jangan hapus Telegram token
❌ Jangan ubah port (tetap 18789)

## Yang HARUS Diubah

✅ `gateway.bind` → "lan" atau "0.0.0.0"
✅ `agents.main.thinking` → "high"
✅ Tambahkan `memory.enabled` → true
✅ Tambahkan `performance.caching` → true

## Hasil yang Diharapkan

Setelah optimasi, Joni akan:
- 🚀 Response lebih cepat (caching)
- 🧠 Lebih cerdas (thinking: high)
- 💾 Ingat conversation (memory enabled)
- 📱 Telegram bot accessible
- ⚡ Auto-load skills
- 📊 Better logging

---

**Backup selalu sebelum edit!**
**Test setelah setiap perubahan!**
