# TOOLS & CAPABILITIES - ZAHRA AI

**Tanggal:** 5 April 2026, 07:44 WIB  
**Versi:** Zahra AI - Adaptive Research & Creation Hub  
**Total Tools:** 100+ capabilities  
**Total Skills:** 87+ ready skills

---

## 🛠️ MCP SERVERS (8 Active)

### **1. Wikipedia MCP**
**Package:** `@modelcontextprotocol/server-wiki-explorer`  
**Status:** ✅ Active (No API key needed)  
**Capabilities:**
- Quick facts & background information
- Historical context
- General knowledge queries
- Multi-language support

### **2. ArXiv MCP**
**Package:** `@fre4x/arxiv`  
**Status:** ✅ Active (No API key needed)  
**Capabilities:**
- Academic papers search
- Research citations
- Scientific literature
- Pre-print access

### **3. Tavily MCP**
**Package:** `tavily-mcp`  
**Status:** ✅ Active (Configured)  
**API Key:** `YOUR_TAVILY_API_KEY_HERE`  
**Free Tier:** 1000 searches/month  
**Capabilities:**
- Web search & extraction
- Real-time information
- Content aggregation
- News & trends

### **4. Google Sheets MCP**
**Package:** `google-sheets-mcp`  
**Status:** ✅ Active (Configured)  
**Service Account:** `openclaw-sheet@mcpserver-openclaw.iam.gserviceaccount.com`  
**Owner:** `masigit01@gmail.com`  
**Credentials:** `C:\Users\Administrator\.openclaw\google-sheets-credentials.json`  
**Capabilities:**
- Read/write spreadsheets
- Data automation
- Report generation
- Spreadsheet management

### **5. Calculator MCP**
**Package:** `@wrtnlabs/calculator-mcp`  
**Status:** ✅ Active (No API key needed)  
**Capabilities:**
- Basic arithmetic operations
- Advanced calculations
- Math functions
- Formula evaluation

### **6. Time MCP**
**Package:** `time-mcp`  
**Status:** ✅ Active (No API key needed)  
**Capabilities:**
- Timezone conversions
- Time calculations
- Date operations
- Scheduling helpers

### **7. GitHub MCP**
**Package:** `@fre4x/github`  
**Status:** ✅ Active (Configured)  
**Token:** `YOUR_GITHUB_TOKEN_HERE`  
**Rate Limits:**
- REST API: 5,000 requests/hour
- Search API: 30 requests/minute
- GraphQL API: 5,000 points/hour

**Capabilities:**
- Repository management
- Issues & Pull Requests
- Code search
- Branches & commits
- Workflows & releases
- Organization access

### **8. Notion MCP**
**Package:** `@notionhq/notion-mcp-server`  
**Status:** ⚠️ Installed, need API key  
**Capabilities:**
- Notion workspace integration
- Database management
- Page creation/editing
- Content organization

---

## 🌐 WEB TOOLS

### **Web Search (Perplexity)**
- Search the web using Perplexity
- Runtime routing between native Search API and Sonar
- Structured filters available
- Real-time information access

### **Web Fetch**
- Extract readable content from URLs
- HTML → markdown/text conversion
- Lightweight page access
- No browser automation needed

### **Image Analysis**
- Analyze one or more images
- Configure image model (agents.defaults.imageModel)
- Content recognition
- Visual data processing

### **Image Generation**
- Generate new images via OpenAI Images API
- Edit reference images
- Aspect ratios: 1:1, 2:3, 3:2, 3:4, 4:3, 4:5, 5:4, 9:16, 16:9, 21:9
- Resolutions: 1K, 2K, 4K

---

## 📁 FILE OPERATIONS

### **Read Files**
- Read text files and images
- Support for various formats (jpg, png, gif, webp)
- Truncated to 2000 lines or 50KB
- Offset/limit support for large files

### **Write Files**
- Create new files or overwrite existing
- Automatic parent directory creation
- Text content writing

### **Edit Files**
- Precise text replacement
- Targeted edits without changing unchanged regions
- Non-overlapping edit support

### **Directory Management**
- Create, list, move directories
- File organization
- Bulk operations support

---

## 💻 DEVELOPMENT TOOLS

### **Shell Execution**
- Execute shell commands
- Background continuation support
- TTY-required command support (pty=true)
- Elevated permissions (when allowed)

### **Process Management**
- List, poll, log running processes
- Write input to processes
- Send keys, paste text
- Kill processes when needed

### **Git Operations**
- Clone, pull, push repositories
- Branch management
- Commit operations
- Remote operations

---

## 🤖 SKILLS FRAMEWORK

### **Skill Categories:**

#### **1. AI Agent Builder (8 divisions)**
- 🌐 Web Development (Next.js, React, TypeScript)
- 📱 App Development (Mobile & Desktop)
- 🤖 AI Agent Builder (LangChain, CrewAI, MCP servers)
- 🔧 Bot Builder (Telegram, Discord, WhatsApp)
- 🎬 Content Creation (TikTok, Threads, Instagram)
- 📈 Digital Marketing (SEO, Ads, Growth)
- 🔬 Research (Sinta 2/3, Scopus journals)
- 💡 Business Ideas (Validation, MVP, Launch)

#### **2. Core Development Skills**
- **Frontend:** expert-frontend, expert-nextjs
- **Backend:** backend, core-tdd, core-review
- **AI/ML:** ai-agent, langchain-expert
- **Testing:** code-review, core-tdd

#### **3. Specialized Skills**
- **Research:** academic-research-assistant, autoresearchclaw
- **Automation:** auto-create-ai-team, tinyfish
- **Business:** content-marketer, business-validator
- **Security:** security-auditor, healthcheck

---

## 🎯 CUSTOM SKILLS (7)

### **1. Academic Research Assistant**
- Automated research workflows
- Paper discovery & analysis
- Citation management
- Literature review assistance

### **2. AI Researcher Skill**
- Research automation
- Data collection & analysis
- Insight generation
- Report creation

### **3. Auto Create AI Team**
- Team composition optimization
- Role assignment
- Skill matching
- Workflow coordination

### **4. AutoResearchClaw**
- Academic paper generation
- Sinta/Scopus compliant
- Automated research pipeline
- Citation management

### **5. Google Workspace CLI Skill**
- Google Sheets automation
- Gmail integration
- Calendar management
- Drive operations

### **6. TinyFish Skill**
- Web scraping automation
- Data extraction
- Competitor analysis
- Lead generation

### **7. TinyFish OpenClaw Skill**
- MCP server integration
- OpenClaw-specific workflows
- Research data collection
- Market intelligence

---

## 🧮 CALCULATOR TOOLS

- **Add:** Add two numbers
- **Subtract:** Subtract two numbers
- **Multiply:** Multiply two numbers
- **Divide:** Divide two numbers
- **Modulo:** Mod two numbers
- **Square Root:** Square root of a number

---

## 🕐 TIME TOOLS

- **Current Time:** Get current date and time
- **Relative Time:** Calculate relative time from now
- **Days in Month:** Get number of days in a month
- **Timestamp:** Convert time to timestamp
- **Timezone Conversion:** Convert time between timezones
- **Week Year:** Get week and ISO week of the year

---

## 📚 MEMORY SYSTEM

### **Memory Search**
- Semantic search in MEMORY.md + memory/*.md
- Session transcript search
- Top snippets with path + lines
- Context recall before answering

### **Memory Get**
- Safe snippet read from memory files
- Optional line ranges
- Context preservation

---

## 📤 COMMUNICATION TOOLS

### **Sessions Management**
- List active sessions
- History access
- Message sending between sessions
- Sub-agent orchestration
- Session spawning

### **Subagents**
- List, kill, or steer spawned sub-agents
- Background task management
- Parallel processing

---

## 📰 ARXIV TOOLS

- **Search Papers:** Search arXiv for academic papers
- **Get Paper:** Retrieve full details for arXiv papers
- **Search by Author:** Search papers by specific author
- **Search by Category:** Browse papers within arXiv categories
- **List Categories:** View arXiv subject categories

---

## 🔍 TAVILY TOOLS

- **Search:** Web search for current information
- **Extract:** Content extraction from URLs
- **Crawl:** Website crawling with configurable depth
- **Map:** Website structure mapping
- **Research:** Comprehensive research on topics

---

## 📝 NOTION TOOLS

- **User Management:** Get users, retrieve user info
- **Page Operations:** Create, retrieve, update pages
- **Block Management:** Get block children, update blocks
- **Database Operations:** Query, retrieve databases
- **Comment Management:** Create, retrieve comments

---

## 🚀 DEPLOYMENT & CLOUD

### **Supported Platforms**
- **AWS EC2:** Full deployment support
- **Vercel:** Frontend hosting
- **Railway:** Backend deployment
- **Render:** Container deployment
- **Fly.io:** Global deployment

### **Deployment Tools**
- **Docker:** Container management
- **Git:** Version control
- **CI/CD:** Automated workflows
- **Monitoring:** Health checks

---

## 🛡️ SECURITY FEATURES

- **API Key Management:** Secure storage
- **Rate Limiting:** API protection
- **Input Validation:** Sanitization
- **Output Filtering:** Safe responses
- **Credential Isolation:** Environment separation

---

## 📊 ANALYTICS & MONITORING

- **Usage Tracking:** Tool utilization
- **Performance Metrics:** Response times
- **Error Logging:** Issue tracking
- **Session Monitoring:** Activity logs

---

## 🎨 CREATIVE TOOLS

- **Content Creation:** Article, blog, social media
- **Design Assistance:** UI/UX guidance
- **Marketing Copy:** Campaign materials
- **Business Plans:** Strategic documents

---

## 📈 BUSINESS INTELLIGENCE

- **Market Research:** Competitive analysis
- **Trend Analysis:** Industry insights
- **Customer Analytics:** Behavior patterns
- **Financial Modeling:** Projections & forecasting

---

## 🧠 RESEARCH CAPABILITIES

### **Academic Research**
- Literature review automation
- Citation management
- Paper generation
- Peer review assistance

### **Market Research**
- Competitor analysis
- Consumer behavior
- Trend identification
- Opportunity assessment

### **Technical Research**
- Code analysis
- Architecture review
- Performance optimization
- Security assessment

---

## 🌍 MULTI-LANGUAGE SUPPORT

- **Primary:** Bahasa Indonesia
- **Secondary:** English
- **Code:** English (variables, functions)
- **Documentation:** Multi-language

---

## 💡 INTELLIGENCE LEVELS

- **Strategic:** Big picture thinking
- **Execution:** Bias toward action
- **Detail-oriented:** Production-grade output
- **Communicative:** Explain reasoning, provide options
- **Data-driven:** Evidence-based decisions
- **Adaptive:** Adjust per domain

---

## 🎯 ANTI-MEDIOCRITY PRINCIPLES

1. ❌ No empty templates → ✅ Actual content
2. ❌ Generic responses → ✅ Specific to context
3. ❌ Half-done work → ✅ Complete solutions
4. ❌ Verbose summaries → ✅ Concise and actionable
5. ❌ Placeholders → ✅ Ready-to-use implementation

---

**Total Capabilities:** 100+ tools and functions  
**Ready Skills:** 87+ specialized skills  
**Active MCP Servers:** 8 servers  
**Free Tier Services:** All MCP servers on free tier ($0/month)

---

**Created:** 2026-04-05 07:44 WIB  
**Location:** E:\bahan repo joniaws\tools\capabilities.md
