# Skales Patterns - Safe Dependencies untuk Zahra Workspace

## ✅ Dependencies yang AMAN di-install per-project

### 📄 Document Processing
```bash
# PDF manipulation & extraction
npm install pdf-lib pdf-parse

# Word document generation
npm install docx

# Excel manipulation
npm install xlsx
```

**Use cases:**
- PDF form filling, merging, splitting
- Word document generation dari templates
- Excel report generation & parsing

**Projects:** `E:\PROJECTS\agents\document-processor\`

---

### 🤖 AI & LLM
```bash
# Google AI SDK
npm install @google/genai

# OpenAI (jika belum ada)
npm install openai

# Anthropic Claude (jika belum ada)
npm install @anthropic-ai/sdk
```

**Use cases:**
- Multi-provider LLM integration
- Vision & multimodal AI
- Embeddings & vector search

**Projects:** `E:\PROJECTS\agents\*\`, `E:\PROJECTS\bots\*\`

---

### 📧 Email Integration
```bash
# Email sending
npm install nodemailer

# Email reading (IMAP)
npm install imap-simple

# Email parsing
npm install mailparser
```

**Use cases:**
- Automated email responses
- Email monitoring & alerts
- Newsletter automation

**Projects:** `E:\PROJECTS\bots\email-assistant\`

---

### 🐦 Social Media
```bash
# Twitter/X API v2
npm install twitter-api-v2

# Telegram Bot (lightweight)
npm install node-telegram-bot-api

# (Avoid: discord.js, whatsapp-web.js - too heavy)
```

**Use cases:**
- Twitter automation
- Telegram bot untuk remote control
- Social media monitoring

**Projects:** `E:\PROJECTS\bots\social-media-bot\`

---

### 🔧 Utilities
```bash
# QR code generation
npm install qrcode

# Archive creation (ZIP)
npm install archiver

# Archive extraction
npm install extract-zip

# Markdown rendering
npm install react-markdown remark-gfm rehype-highlight
```

**Use cases:**
- QR code untuk authentication
- Backup & export features
- Content rendering

**Projects:** Any project yang butuh utilities ini

---

## ❌ Dependencies yang TIDAK AMAN (Avoid)

### 🚫 Electron-specific (Desktop only)
```bash
# JANGAN install ini di web projects
electron
electron-builder
electron-updater
electron-store
```

**Reason:** Hanya untuk desktop apps, conflict dengan web projects

---

### 🚫 Heavy Bot Frameworks
```bash
# JANGAN install kecuali benar-benar butuh
discord.js              # 50MB+, heavy
whatsapp-web.js         # Requires Chromium, 200MB+
```

**Reason:** Terlalu berat, butuh browser automation

**Alternative:** Gunakan API langsung atau lightweight wrappers

---

### 🚫 Browser Automation (Heavy)
```bash
# JANGAN install kecuali project khusus automation
playwright              # 200MB+ (Chromium, Firefox, WebKit)
puppeteer              # 300MB+ (Chromium)
```

**Reason:** Sangat berat, hanya untuk browser automation projects

**Alternative:** Gunakan API endpoints atau lightweight scraping

---

## 📦 Installation Strategy

### Per-Project Installation
```bash
# JANGAN install di root workspace
# SELALU install di project-specific folder

# ✅ BENAR
cd E:\PROJECTS\agents\pdf-processor
npm init -y
npm install pdf-lib pdf-parse

# ❌ SALAH
cd E:\ZAHRA-WORKSPACE
npm install pdf-lib  # Pollutes workspace
```

### Package.json Template
```json
{
  "name": "project-name",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "pdf-lib": "^1.17.1",
    "pdf-parse": "^1.1.1"
  },
  "devDependencies": {
    "@types/node": "^20",
    "typescript": "^5"
  }
}
```

---

## 🎯 Recommended Project Structure

```
E:\PROJECTS\
├── agents\
│   ├── skales-patterns\          # Extracted patterns (no deps)
│   │   ├── autonomous-runner.ts
│   │   ├── file-guard.ts
│   │   ├── memory-system.ts
│   │   └── package.json          # Minimal deps only
│   │
│   ├── document-processor\       # PDF/Word/Excel
│   │   ├── package.json          # pdf-lib, docx, xlsx
│   │   └── src\
│   │
│   └── email-assistant\          # Email automation
│       ├── package.json          # nodemailer, imap-simple
│       └── src\
│
├── bots\
│   ├── telegram-bot\             # Telegram only
│   │   ├── package.json          # node-telegram-bot-api
│   │   └── src\
│   │
│   └── twitter-bot\              # Twitter only
│       ├── package.json          # twitter-api-v2
│       └── src\
│
└── web\
    └── nextjs-app\               # Web app
        ├── package.json          # next, react, etc
        └── src\
```

---

## 🔍 Dependency Audit Checklist

Before installing any dependency:

- [ ] Apakah benar-benar diperlukan untuk project ini?
- [ ] Berapa size package + dependencies? (check bundlephobia.com)
- [ ] Apakah ada alternative yang lebih lightweight?
- [ ] Apakah compatible dengan existing stack?
- [ ] Apakah actively maintained? (check npm, GitHub)
- [ ] Apakah ada security issues? (npm audit)

---

## 📊 Size Reference

| Package | Size (unpacked) | Use Case |
|---------|----------------|----------|
| `pdf-lib` | ~2MB | PDF manipulation |
| `pdf-parse` | ~500KB | PDF text extraction |
| `docx` | ~1MB | Word generation |
| `xlsx` | ~5MB | Excel manipulation |
| `qrcode` | ~200KB | QR generation |
| `archiver` | ~500KB | ZIP creation |
| `nodemailer` | ~2MB | Email sending |
| `twitter-api-v2` | ~1MB | Twitter API |
| `node-telegram-bot-api` | ~500KB | Telegram bot |
| **HEAVY** | | |
| `discord.js` | ~50MB | Discord bot |
| `whatsapp-web.js` | ~200MB+ | WhatsApp (needs Chromium) |
| `playwright` | ~200MB+ | Browser automation |
| `electron` | ~100MB+ | Desktop apps |

---

## 🚀 Quick Start Examples

### Example 1: PDF Processor
```bash
mkdir -p E:\PROJECTS\agents\pdf-processor
cd E:\PROJECTS\agents\pdf-processor
npm init -y
npm install pdf-lib pdf-parse
npm install -D @types/node typescript
```

### Example 2: Email Bot
```bash
mkdir -p E:\PROJECTS\bots\email-assistant
cd E:\PROJECTS\bots\email-assistant
npm init -y
npm install nodemailer imap-simple
npm install -D @types/node typescript
```

### Example 3: Twitter Bot
```bash
mkdir -p E:\PROJECTS\bots\twitter-bot
cd E:\PROJECTS\bots\twitter-bot
npm init -y
npm install twitter-api-v2
npm install -D @types/node typescript
```

---

**Last Updated:** 2026-03-23
**Status:** Production Ready
**Maintenance:** Update as needed per project requirements
