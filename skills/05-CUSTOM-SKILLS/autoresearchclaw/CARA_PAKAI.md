# Cara Menggunakan AutoResearchClaw Skill

**Updated:** 2026-03-23

---

## 🎯 3 Cara Menggunakan Skill Ini

### 1. **Sebagai Reference Architecture** (Paling Umum)
### 2. **Adopt Patterns ke Projects** (Recommended)
### 3. **Run AutoResearchClaw Langsung** (Advanced)

---

## 📚 Cara 1: Sebagai Reference Architecture

**Use Case:** Kamu sedang develop AI agent/bot/system dan butuh reference bagaimana implement fitur tertentu.

### Contoh Skenario

#### A. Butuh Multi-Agent Architecture

**Kamu mau:** Break monolithic bot jadi specialized agents

**Lihat:**
```bash
# Baca dokumentasi multi-agent
skills/05-CUSTOM-SKILLS/autoresearchclaw/SKILL.md
# Scroll ke section "Multi-Agent Subsystems"

# Lihat source code
skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/agents/
├── benchmark_agent/
│   ├── surveyor.py      # Agent 1: Survey benchmarks
│   ├── acquirer.py      # Agent 2: Acquire data
│   ├── selector.py      # Agent 3: Select best
│   ├── validator.py     # Agent 4: Validate
│   └── orchestrator.py  # Coordinator
```

**Apply ke project:**
```python
# Your bot project
bots/telegram-bot/
├── agents/
│   ├── message_handler.py    # Agent 1: Handle messages
│   ├── command_parser.py     # Agent 2: Parse commands
│   ├── response_generator.py # Agent 3: Generate responses
│   ├── db_manager.py         # Agent 4: Database ops
│   └── orchestrator.py       # Coordinator
```

#### B. Butuh Self-Healing Code Execution

**Kamu mau:** Code yang auto-repair kalau error

**Lihat:**
```bash
# Baca pattern
.ai/memory/learnings.md
# Scroll ke "6. Self-Healing Code Execution"

# Lihat implementation
skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/pipeline/executor.py
# Line 1-100: execute_with_repair()
```

**Apply ke project:**
```python
# Your code generator
def generate_and_execute(prompt, max_retries=5):
    for attempt in range(max_retries):
        # Generate code
        code = llm.generate(prompt)
        
        # Validate
        issues = validate_code(code)
        if not issues:
            # Execute
            result = run_sandbox(code)
            if result.success:
                return result
        
        # Repair with LLM
        code = llm.repair(code, issues)
    
    raise MaxRetriesExceeded()
```

#### C. Butuh Hardware-Aware Execution

**Kamu mau:** Code adapt ke GPU/CPU yang available

**Lihat:**
```bash
# Baca pattern
skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/hardware.py

# Lihat usage
skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/pipeline/stage_impls/_code_generation.py
# Line 56-100: Hardware detection + prompt injection
```

**Apply ke project:**
```python
# Your AI agent
import torch

def detect_hardware():
    if torch.cuda.is_available():
        return {"type": "cuda", "tier": "high"}
    elif torch.backends.mps.is_available():
        return {"type": "mps", "tier": "limited"}
    else:
        return {"type": "cpu", "tier": "none"}

# Adapt prompt
hw = detect_hardware()
if hw["tier"] == "high":
    prompt += "\nUse PyTorch with GPU acceleration"
else:
    prompt += "\nUse NumPy/sklearn only (CPU-only)"
```

---

## 🔧 Cara 2: Adopt Patterns ke Projects (Recommended)

**Use Case:** Kamu mau improve existing projects dengan proven patterns dari AutoResearchClaw.

### 6 Core Patterns untuk Adopt

#### Pattern 1: Multi-Agent Architecture

**What:** Break monolithic system jadi specialized agents

**Implementation Steps:**

1. **Identify responsibilities** di current system
2. **Create agent classes** untuk each responsibility
3. **Define interfaces** (input/output contracts)
4. **Build orchestrator** untuk coordinate agents

**Example:**
```python
# Before (monolithic)
class ResearchBot:
    def do_everything(self, topic):
        papers = self.search_papers(topic)
        summary = self.summarize(papers)
        report = self.write_report(summary)
        return report

# After (multi-agent)
class LiteratureAgent:
    def search(self, topic): ...
    def screen(self, papers): ...

class SummaryAgent:
    def summarize(self, papers): ...

class WritingAgent:
    def write_report(self, summary): ...

class ResearchOrchestrator:
    def __init__(self):
        self.lit_agent = LiteratureAgent()
        self.summary_agent = SummaryAgent()
        self.writing_agent = WritingAgent()
    
    def run(self, topic):
        papers = self.lit_agent.search(topic)
        screened = self.lit_agent.screen(papers)
        summary = self.summary_agent.summarize(screened)
        report = self.writing_agent.write_report(summary)
        return report
```

**Reference:** [`skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/agents/`](skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/agents/)

---

#### Pattern 2: Self-Learning System

**What:** System belajar dari failures → convert to skills → inject ke prompts

**Implementation Steps:**

1. **Create lessons.json** untuk store failures
2. **Extract lessons** after each run
3. **Convert to skills** via LLM
4. **Inject into prompts** (evolution overlay)

**Example:**
```python
# 1. Capture failures
def capture_lesson(error, context):
    lesson = {
        "timestamp": datetime.now().isoformat(),
        "severity": "error",
        "category": "code_generation",
        "description": str(error),
        "context": context
    }
    append_to_file(".ai/memory/lessons.json", lesson)

# 2. Convert to skill
def convert_lessons_to_skills(lessons, llm):
    prompt = f"""
    Convert these failures to reusable skills:
    {format_lessons(lessons)}
    
    Output format:
    - Skill name
    - When to use
    - Steps to avoid the issue
    """
    skills = llm.generate(prompt)
    save_skills(skills)

# 3. Inject into prompts
def build_evolution_overlay(stage):
    lessons = load_lessons()
    relevant = filter_by_stage(lessons, stage)
    
    overlay = "\n\n## Lessons from Previous Runs\n"
    for lesson in relevant:
        overlay += f"- {lesson['description']}\n"
    
    return overlay

# Usage
prompt = base_prompt + build_evolution_overlay("code_generation")
```

**Reference:** [`skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/metaclaw_bridge/`](skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/metaclaw_bridge/)

---

#### Pattern 3: Stage-Based Workflow

**What:** Clear progression dengan rollback capability

**Implementation Steps:**

1. **Define stages** (enum)
2. **Create stage executor** untuk each stage
3. **Implement checkpoint system**
4. **Add rollback logic**

**Example:**
```python
from enum import IntEnum

# 1. Define stages
class Stage(IntEnum):
    REQUIREMENTS = 1
    ARCHITECTURE = 2
    IMPLEMENTATION = 3
    TESTING = 4
    DEPLOYMENT = 5

# 2. Stage executor
def execute_stage(stage, artifacts_dir):
    if stage == Stage.REQUIREMENTS:
        return analyze_requirements(artifacts_dir)
    elif stage == Stage.ARCHITECTURE:
        return design_architecture(artifacts_dir)
    # ... etc

# 3. Checkpoint system
def save_checkpoint(stage, run_id):
    checkpoint = {
        "last_completed_stage": int(stage),
        "run_id": run_id,
        "timestamp": datetime.now().isoformat()
    }
    write_json("checkpoint.json", checkpoint)

# 4. Rollback logic
ROLLBACK_TARGETS = {
    Stage.ARCHITECTURE: Stage.REQUIREMENTS,
    Stage.IMPLEMENTATION: Stage.ARCHITECTURE,
    Stage.TESTING: Stage.IMPLEMENTATION,
}

def rollback(stage):
    target = ROLLBACK_TARGETS.get(stage, stage)
    return target
```

**Reference:** [`skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/pipeline/stages.py`](skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/pipeline/stages.py)

---

#### Pattern 4: Hardware-Aware Execution

**What:** Detect hardware → adapt code generation

**Implementation Steps:**

1. **Detect hardware** (GPU/CPU)
2. **Inject hints** into prompts
3. **Adapt package selection**

**Example:**
```python
import torch

# 1. Detect hardware
def detect_hardware():
    profile = {
        "has_gpu": False,
        "gpu_type": "cpu",
        "tier": "none"
    }
    
    if torch.cuda.is_available():
        profile["has_gpu"] = True
        profile["gpu_type"] = "cuda"
        profile["tier"] = "high"
    elif torch.backends.mps.is_available():
        profile["has_gpu"] = True
        profile["gpu_type"] = "mps"
        profile["tier"] = "limited"
    
    return profile

# 2. Inject hints
def build_hardware_hint(hw_profile):
    if hw_profile["tier"] == "high":
        return """
        GPU: Available (CUDA)
        - Use PyTorch with GPU acceleration
        - device = torch.device('cuda')
        """
    elif hw_profile["tier"] == "limited":
        return """
        GPU: Limited (MPS or low VRAM)
        - Use lightweight models (<1M params)
        - Small batch sizes
        - device = torch.device('mps')
        """
    else:
        return """
        GPU: Not available
        - Use NumPy/sklearn only
        - No deep learning frameworks
        """

# Usage
hw = detect_hardware()
prompt = base_prompt + build_hardware_hint(hw)
```

**Reference:** [`skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/hardware.py`](skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/hardware.py)

---

#### Pattern 5: Prompt Externalization

**What:** Move prompts dari code ke YAML files

**Implementation Steps:**

1. **Create prompts.yaml**
2. **Define prompt templates**
3. **Build prompt manager**
4. **Use in code**

**Example:**

**File: `.ai/prompts.yaml`**
```yaml
stages:
  code_generation:
    system: "You are an expert Python developer..."
    user: |
      Generate code for: {task}
      
      Requirements:
      - {requirements}
      
      Hardware: {hardware}
      Available packages: {packages}
    json_mode: false
    max_tokens: 4000
  
  code_repair:
    system: "You are a debugging expert..."
    user: |
      Fix this code:
      ```python
      {code}
      ```
      
      Issues found:
      {issues}
      
      Error log:
      {error_log}
    json_mode: false
    max_tokens: 2000
```

**File: `prompt_manager.py`**
```python
import yaml

class PromptManager:
    def __init__(self, yaml_path=".ai/prompts.yaml"):
        with open(yaml_path) as f:
            self.prompts = yaml.safe_load(f)
    
    def get(self, stage, **kwargs):
        template = self.prompts["stages"][stage]
        
        # Render template
        system = template["system"]
        user = template["user"].format(**kwargs)
        
        return {
            "system": system,
            "user": user,
            "json_mode": template.get("json_mode", False),
            "max_tokens": template.get("max_tokens")
        }

# Usage
pm = PromptManager()
prompt = pm.get(
    "code_generation",
    task="Build a web scraper",
    requirements="Use requests and BeautifulSoup",
    hardware="CPU-only",
    packages="requests, bs4, pandas"
)
```

**Reference:** [`skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/prompts.py`](skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/prompts.py)

---

#### Pattern 6: Structured Artifacts

**What:** Consistent output format (JSON/YAML/Markdown)

**Implementation Steps:**

1. **Define artifact schemas**
2. **Create artifact writers**
3. **Use consistent naming**

**Example:**
```python
from pathlib import Path
import json
from datetime import datetime

# 1. Define schemas
ARTIFACT_SCHEMAS = {
    "requirements": {
        "functional": [],
        "non_functional": [],
        "constraints": []
    },
    "architecture": {
        "components": [],
        "interfaces": [],
        "data_flow": []
    }
}

# 2. Artifact writer
class ArtifactWriter:
    def __init__(self, run_dir):
        self.run_dir = Path(run_dir)
        self.run_dir.mkdir(parents=True, exist_ok=True)
    
    def write_json(self, stage, name, data):
        stage_dir = self.run_dir / f"stage-{stage}"
        stage_dir.mkdir(exist_ok=True)
        
        path = stage_dir / f"{name}.json"
        with open(path, "w") as f:
            json.dump(data, f, indent=2)
    
    def write_markdown(self, stage, name, content):
        stage_dir = self.run_dir / f"stage-{stage}"
        stage_dir.mkdir(exist_ok=True)
        
        path = stage_dir / f"{name}.md"
        path.write_text(content)

# Usage
writer = ArtifactWriter("artifacts/run-20260323-062700")
writer.write_json(1, "requirements", {
    "functional": ["User login", "Data export"],
    "non_functional": ["Response time < 200ms"],
    "constraints": ["Budget: $5000"]
})
```

**Reference:** [`skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/pipeline/_helpers.py`](skills/05-CUSTOM-SKILLS/autoresearchclaw/researchclaw/pipeline/_helpers.py)

---

## 🚀 Cara 3: Run AutoResearchClaw Langsung (Advanced)

**Use Case:** Kamu mau generate research paper secara autonomous.

### Prerequisites

1. **Python 3.11+**
2. **OpenAI API key** (atau compatible endpoint)
3. **Virtual environment**

### Installation Steps

```bash
# 1. Navigate to skill directory
cd skills/05-CUSTOM-SKILLS/autoresearchclaw/

# 2. Create virtual environment
python3 -m venv .venv
source .venv/bin/activate  # Linux/Mac
# .venv\Scripts\activate   # Windows

# 3. Install
pip install -e .

# 4. Setup (interactive)
researchclaw setup

# 5. Initialize config
researchclaw init
```

### Configuration

**File: `config.arc.yaml`**
```yaml
project:
  name: "my-research"

research:
  topic: "Your research topic here"

llm:
  base_url: "https://api.openai.com/v1"
  api_key_env: "OPENAI_API_KEY"
  primary_model: "gpt-4o"
  fallback_models: ["gpt-4o-mini"]

experiment:
  mode: "sandbox"
  sandbox:
    python_path: ".venv/bin/python"
```

### Run Pipeline

```bash
# Set API key
export OPENAI_API_KEY="sk-..."

# Run full pipeline
researchclaw run --config config.arc.yaml --topic "Your research idea" --auto-approve

# Output: artifacts/rc-YYYYMMDD-HHMMSS-<hash>/deliverables/
# - paper.tex (LaTeX)
# - paper_final.md (Markdown)
# - references.bib (BibTeX)
# - charts/ (Figures)
# - code/ (Experiment code)
```

**Reference:** [`skills/05-CUSTOM-SKILLS/autoresearchclaw/README.md`](skills/05-CUSTOM-SKILLS/autoresearchclaw/README.md)

---

## 📖 Quick Reference

### Documentation Files

| File | Purpose |
|------|---------|
| [`SKILL.md`](SKILL.md) | Main documentation (use cases, architecture, quick start) |
| [`ANALISIS_AUTORESEARCHCLAW.md`](../../AutoResearchClaw/ANALISIS_AUTORESEARCHCLAW.md) | Deep analysis (Bahasa Indonesia) |
| [`README.md`](README.md) | Original AutoResearchClaw README |
| [`CARA_PAKAI.md`](CARA_PAKAI.md) | This file (usage guide) |

### Memory Files

| File | Purpose |
|------|---------|
| [`.ai/memory/progress.md`](../../.ai/memory/progress.md) | Activity log |
| [`.ai/memory/decisions.md`](../../.ai/memory/decisions.md) | Adoption strategy |
| [`.ai/memory/learnings.md`](../../.ai/memory/learnings.md) | Key learnings + best practices |
| [`.ai/memory/backlog.md`](../../.ai/memory/backlog.md) | Adoption tasks |

### Source Code Reference

| Path | What's Inside |
|------|---------------|
| `researchclaw/pipeline/` | Pipeline core (runner, stages, executor) |
| `researchclaw/agents/` | Multi-agent systems |
| `researchclaw/metaclaw_bridge/` | Self-learning integration |
| `researchclaw/hardware.py` | Hardware detection |
| `researchclaw/prompts.py` | Prompt management |
| `researchclaw/literature/` | Literature search + verification |

---

## 💡 Tips

### 1. Start Small
Jangan adopt semua patterns sekaligus. Mulai dari 1 pattern yang paling relevan.

### 2. Read the Source
Source code AutoResearchClaw adalah reference terbaik. Baca implementation-nya.

### 3. Test Incrementally
Setiap adopt pattern, test dulu sebelum lanjut ke pattern berikutnya.

### 4. Document Your Learnings
Update `.ai/memory/learnings.md` dengan insight baru yang kamu dapat.

### 5. Use Memory System
Manfaatkan memory system (progress, decisions, learnings) untuk track adoption progress.

---

## 🆘 Troubleshooting

### Q: Bingung mau mulai dari mana?
**A:** Mulai dari Pattern 5 (Prompt Externalization) - paling simple dan immediate impact.

### Q: Pattern mana yang paling penting?
**A:** Pattern 2 (Self-Learning) - ini yang bikin system improve over time.

### Q: Butuh berapa lama untuk adopt semua patterns?
**A:** 8 weeks (lihat implementation plan di [`.ai/memory/decisions.md`](../../.ai/memory/decisions.md))

### Q: Bisa adopt partial aja?
**A:** Bisa! Pilih pattern yang paling relevan untuk project kamu.

---

**Last Updated:** 2026-03-23  
**Status:** ✅ Ready to Use
