# AutoResearchClaw - Autonomous Research Pipeline

**Version:** 0.3.1  
**Category:** Research & Academic Writing  
**Source:** https://github.com/aiming-lab/AutoResearchClaw  
**Installed:** 2026-03-23

---

## 📋 Overview

AutoResearchClaw adalah sistem pipeline riset otomatis yang mengubah ide riset menjadi paper akademik lengkap tanpa intervensi manusia. Sistem ini menggunakan 23 stage dalam 8 fase dengan multi-agent architecture, self-learning, dan hardware-aware execution.

**Key Capabilities:**
- ✅ 23-stage autonomous pipeline (Topic Init → Citation Verify)
- ✅ Multi-agent architecture (CodeAgent, BenchmarkAgent, FigureAgent)
- ✅ Self-learning via MetaClaw (+18.3% robustness)
- ✅ Hardware-aware execution (CUDA/MPS/CPU auto-detect)
- ✅ Real literature integration (OpenAlex, Semantic Scholar, arXiv)
- ✅ Conference-ready LaTeX (NeurIPS/ICML/ICLR)
- ✅ 4-layer citation verification
- ✅ OpenClaw compatible

---

## 🎯 Use Cases

### 1. Academic Research Paper Generation
```bash
# Generate full research paper from topic
researchclaw run --topic "Graph neural networks for drug discovery" --auto-approve
```

### 2. Literature Review Automation
```bash
# Collect and synthesize literature
researchclaw run --from-stage SEARCH_STRATEGY --topic "Transformer attention mechanisms"
```

### 3. Experiment Design & Execution
```bash
# Design and run experiments
researchclaw run --from-stage EXPERIMENT_DESIGN --config config.yaml
```

### 4. Paper Writing & Review
```bash
# Generate paper from existing experiments
researchclaw run --from-stage PAPER_OUTLINE --auto-approve
```

---

## 🏗️ Architecture

### Pipeline Stages (23 Total)

```
Phase A: Research Scoping (1-2)
├── 1. TOPIC_INIT: Formulate SMART goal + hardware detection
└── 2. PROBLEM_DECOMPOSE: Break into sub-questions

Phase B: Literature Discovery (3-6)
├── 3. SEARCH_STRATEGY: Plan queries & sources
├── 4. LITERATURE_COLLECT: Real API calls (arXiv → Semantic Scholar)
├── 5. LITERATURE_SCREEN: [GATE] Filter by relevance
└── 6. KNOWLEDGE_EXTRACT: Extract structured knowledge cards

Phase C: Knowledge Synthesis (7-8)
├── 7. SYNTHESIS: Cluster findings, identify gaps
└── 8. HYPOTHESIS_GEN: Generate falsifiable hypotheses

Phase D: Experiment Design (9-11)
├── 9. EXPERIMENT_DESIGN: [GATE] Design plan with baselines
├── 10. CODE_GENERATION: Hardware-aware Python code
└── 11. RESOURCE_PLANNING: Estimate GPU/time requirements

Phase E: Experiment Execution (12-13)
├── 12. EXPERIMENT_RUN: Execute in sandbox/docker
└── 13. ITERATIVE_REFINE: Self-healing code repair (max 10 iterations)

Phase F: Analysis & Decision (14-15)
├── 14. RESULT_ANALYSIS: Statistical analysis
└── 15. RESEARCH_DECISION: PROCEED/PIVOT/REFINE decision

Phase G: Paper Writing (16-19)
├── 16. PAPER_OUTLINE: Section-level outline
├── 17. PAPER_DRAFT: 5,000-6,500 words, anti-fabrication guard
├── 18. PEER_REVIEW: Multi-agent review with NeurIPS rubric
└── 19. PAPER_REVISION: Address reviews with length guard

Phase H: Finalization (20-23)
├── 20. QUALITY_GATE: [GATE] Quality check
├── 21. KNOWLEDGE_ARCHIVE: Save retrospective
├── 22. EXPORT_PUBLISH: Generate LaTeX + charts + code
└── 23. CITATION_VERIFY: 4-layer verification
```

### Multi-Agent Subsystems

**CodeAgent** (`researchclaw/pipeline/code_agent.py`)
- Generate & repair experiment code
- AST validation & import whitelist
- Hardware-aware package selection
- Self-healing repair (max 5 attempts)
- OpenCode Beast Mode integration

**BenchmarkAgent** (`researchclaw/agents/benchmark_agent/`)
- Surveyor: Identify relevant benchmarks
- Acquirer: Fetch benchmark data/code
- Selector: Choose appropriate benchmarks
- Validator: Verify benchmark integrity
- Orchestrator: Coordinate workflow

**FigureAgent** (`researchclaw/agents/figure_agent/`)
- Decision: Analyze paper → decide figures needed
- Planner: Design figure specifications
- CodeGen: Generate matplotlib/seaborn code
- Renderer: Execute code → produce images
- Critic: Quality check (3 iteration max)
- NanoBanana: Gemini-based image generation
- Integrator: Combine into manifest

---

## 🚀 Quick Start

### Installation

```bash
# Clone repository
git clone https://github.com/aiming-lab/AutoResearchClaw.git
cd AutoResearchClaw

# Create virtual environment
python3 -m venv .venv
source .venv/bin/activate  # Linux/Mac
# .venv\Scripts\activate   # Windows

# Install
pip install -e .

# Setup (interactive)
researchclaw setup

# Initialize config
researchclaw init
```

### Basic Configuration

```yaml
# config.arc.yaml (minimum required)
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

# Resume from checkpoint
researchclaw run --config config.arc.yaml --resume --auto-approve

# Start from specific stage
researchclaw run --config config.arc.yaml --from-stage PAPER_OUTLINE --auto-approve
```

---

## 🧠 Key Features

### 1. MetaClaw Integration (Self-Learning)

**Concept:** Pipeline learns from every run — failures → lessons → skills

```yaml
# Enable in config.arc.yaml
metaclaw_bridge:
  enabled: true
  proxy_url: "http://localhost:30000"
  skills_dir: "~/.metaclaw/skills"
  lesson_to_skill:
    enabled: true
    min_severity: "warning"
    max_skills_per_run: 3
```

**Results:**
- Stage retry rate: -24.8%
- Refine cycle count: -40.0%
- Pipeline completion: +5.3%
- Overall robustness: +18.3%

### 2. Hardware-Aware Execution

**Auto-detection:**
```python
# Stage 1 detects GPU hardware
if torch.cuda.is_available():
    tier = "high"  # Full PyTorch with GPU
elif torch.backends.mps.is_available():
    tier = "limited"  # Lightweight experiments
else:
    tier = "none"  # NumPy/sklearn only
```

**Adaptive Code Generation:**
- High-tier GPU: Full PyTorch with GPU acceleration
- Limited GPU: Lightweight (<1M params, <=20 epochs)
- CPU-only: NumPy/sklearn, no deep learning

### 3. OpenCode Beast Mode

**Complex experiments auto-routed to OpenCode:**

```yaml
# config.arc.yaml
experiment:
  opencode:
    enabled: true
    auto: true
    complexity_threshold: 0.2
    timeout_sec: 600
```

**Triggers:**
- Multi-model comparison
- Custom architectures
- Ablation studies
- Large-scale experiments

### 4. Real Literature Integration

**Multi-source search:**
1. arXiv (primary)
2. Semantic Scholar (fallback)
3. OpenAlex (metadata enrichment)

**4-layer citation verification:**
1. arXiv ID check
2. CrossRef/DataCite DOI
3. Semantic Scholar title match
4. LLM relevance scoring

### 5. Self-Healing Execution

**Sandbox safety:**
- AST validation (no eval/exec/subprocess)
- Import whitelist
- Memory limit & timeout
- NaN/Inf fast-fail
- Partial result capture

**Auto-repair:**
```python
for attempt in range(max_retries):
    result = run_experiment(code)
    if result.success:
        return result
    issues = validate_code(code)
    code = llm.repair(code, issues)
```

---

## 📊 Output Artifacts

**Deliverables:** `artifacts/rc-YYYYMMDD-HHMMSS-<hash>/deliverables/`

| File | Description |
|------|-------------|
| `paper.tex` | Conference-ready LaTeX |
| `paper_final.md` | Markdown version |
| `references.bib` | Verified BibTeX |
| `verification_report.json` | Citation fact-check |
| `charts/` | Auto-generated figures |
| `code/experiment.py` | Final experiment code |
| `code/requirements.txt` | Dependencies |
| `code/README.md` | Reproduction guide |

---

## 🔧 Experiment Modes

### 1. Simulated (Default)
```yaml
experiment:
  mode: "simulated"
```
- LLM generates synthetic results
- Fast, no setup required
- Not real experiments

### 2. Sandbox
```yaml
experiment:
  mode: "sandbox"
  sandbox:
    python_path: ".venv/bin/python"
    gpu_required: false
    max_memory_mb: 4096
```
- Real Python execution
- Hardware-aware (GPU/MPS/CPU)
- AST validation + import whitelist

### 3. Docker
```yaml
experiment:
  mode: "docker"
  docker:
    image: "researchclaw/experiment:latest"
    gpu_enabled: true
    network_policy: "setup_only"
```
- Isolated container execution
- GPU passthrough (NVIDIA)
- Network policies (none/setup_only/pip_only/full)
- Pre-cached datasets

### 4. SSH Remote
```yaml
experiment:
  mode: "ssh_remote"
  ssh_remote:
    host: "gpu-server.example.com"
    gpu_ids: [0, 1]
```
- Execute on remote GPU server
- Multi-GPU support

---

## 🎨 Conference Templates

**Supported:**
- `neurips_2024`, `neurips_2025`
- `iclr_2025`, `iclr_2026`
- `icml_2025`, `icml_2026`

```yaml
export:
  target_conference: "neurips_2025"
  authors: "Anonymous"
  bib_file: "references"
```

---

## 🔌 Integration

### OpenClaw Integration

**Natural language interface:**
```
User: "Research graph neural networks for drug discovery"
OpenClaw: → clones repo → installs → runs pipeline → returns paper
```

**Bridge adapters:**
```yaml
openclaw_bridge:
  use_cron: true              # Scheduled runs
  use_message: true           # Progress notifications
  use_memory: true            # Cross-session persistence
  use_sessions_spawn: true    # Parallel sub-sessions
  use_web_fetch: true         # Live web search
```

### ACP (Agent Client Protocol)

**Supported agents:**
- Claude Code (`claude`)
- Codex CLI (`codex`)
- Copilot CLI (`gh`)
- Gemini CLI (`gemini`)
- OpenCode (`opencode`)

```yaml
llm:
  provider: "acp"
  acp:
    agent: "claude"
    cwd: "."
```

### Python API

```python
from researchclaw.pipeline import Runner
from researchclaw.config import RCConfig

config = RCConfig.from_yaml("config.yaml")
runner = Runner(config)
result = runner.run()
```

---

## 💡 Adoption Patterns for Zahra Workspace

### 1. Multi-Agent Architecture

**Break monolithic skills into specialized agents:**

```
Research Agent (AutoResearchClaw-inspired)
├── Literature Agent: Search + screen papers
├── Experiment Agent: Design + execute + analyze
├── Writing Agent: Outline + draft + revise
└── Review Agent: Quality check + citation verify
```

### 2. Self-Learning System

**Implement MetaClaw pattern:**

```
.ai/memory/lessons.json → extract failures
                       ↓
          LLM converts → skills/arc-*/SKILL.md
                       ↓
          Next run → inject skills into prompts
```

### 3. Stage-Based Workflow

**Clear progression with rollback:**

```python
# Define stages
stages = [
    Stage.REQUIREMENTS,
    Stage.ARCHITECTURE,
    Stage.IMPLEMENTATION,
    Stage.TESTING,
    Stage.DEPLOYMENT,
]

# Each stage has:
# - Clear input/output artifacts
# - Validation gates
# - Rollback targets
# - Evolution overlay
```

### 4. Hardware-Aware Execution

**Adapt to available resources:**

```python
hw = detect_hardware()

if hw.has_gpu:
    prompt += "Use PyTorch with GPU acceleration"
else:
    prompt += "Use NumPy/sklearn only (CPU-only)"
```

### 5. Quality Gates & Checkpoints

**HITL gates for critical decisions:**

```yaml
security:
  hitl_required_stages: [3, 5, 6]  # Architecture, Testing, Deployment
  allow_publish_without_approval: false
```

### 6. Prompt Externalization

**Move prompts to YAML:**

```yaml
# .ai/prompts.yaml
stages:
  architecture_design:
    system: "You are a senior software architect..."
    user: "Design architecture for: {requirements}"
    json_mode: true
    max_tokens: 4000
```

---

## 📚 Key Files & Modules

### Core Pipeline
- [`researchclaw/pipeline/runner.py`](researchclaw/pipeline/runner.py) - Main pipeline orchestrator
- [`researchclaw/pipeline/stages.py`](researchclaw/pipeline/stages.py) - Stage definitions & state machine
- [`researchclaw/pipeline/executor.py`](researchclaw/pipeline/executor.py) - Stage execution logic

### Multi-Agent Systems
- [`researchclaw/pipeline/code_agent.py`](researchclaw/pipeline/code_agent.py) - Code generation & repair
- [`researchclaw/agents/benchmark_agent/`](researchclaw/agents/benchmark_agent/) - Benchmark selection
- [`researchclaw/agents/figure_agent/`](researchclaw/agents/figure_agent/) - Figure generation

### MetaClaw Integration
- [`researchclaw/metaclaw_bridge/lesson_to_skill.py`](researchclaw/metaclaw_bridge/lesson_to_skill.py) - Lesson → Skill conversion
- [`researchclaw/metaclaw_bridge/stage_skill_map.py`](researchclaw/metaclaw_bridge/stage_skill_map.py) - Stage → Skill mapping
- [`researchclaw/evolution.py`](researchclaw/evolution.py) - Evolution store & lesson extraction

### Literature & Citation
- [`researchclaw/literature/search.py`](researchclaw/literature/search.py) - Multi-source literature search
- [`researchclaw/literature/verify.py`](researchclaw/literature/verify.py) - 4-layer citation verification
- [`researchclaw/literature/arxiv_client.py`](researchclaw/literature/arxiv_client.py) - arXiv API client
- [`researchclaw/literature/semantic_scholar.py`](researchclaw/literature/semantic_scholar.py) - Semantic Scholar client

### Configuration & Prompts
- [`researchclaw/config.py`](researchclaw/config.py) - Configuration system
- [`researchclaw/prompts.py`](researchclaw/prompts.py) - Prompt management & rendering
- [`prompts.default.yaml`](prompts.default.yaml) - Default prompts (customizable)

### Hardware & Execution
- [`researchclaw/hardware.py`](researchclaw/hardware.py) - Hardware detection (CUDA/MPS/CPU)
- [`researchclaw/experiment/sandbox.py`](researchclaw/experiment/sandbox.py) - Sandbox execution
- [`researchclaw/experiment/docker_sandbox.py`](researchclaw/experiment/docker_sandbox.py) - Docker execution

---

## 🧪 Testing

**Test coverage:** 1,634 tests passed

```bash
# Run all tests
pytest tests/

# Run specific test suite
pytest tests/test_rc_executor.py
pytest tests/test_metaclaw_bridge/

# Run E2E tests
pytest tests/e2e_real_llm.py
```

---

## 📖 Documentation

- **Main README:** [`README.md`](README.md)
- **Integration Guide:** [`docs/integration-guide.md`](docs/integration-guide.md)
- **Paper Showcase:** [`docs/showcase/SHOWCASE.md`](docs/showcase/SHOWCASE.md)
- **Tester Guide:** [`docs/TESTER_GUIDE.md`](docs/TESTER_GUIDE.md)
- **Bug Tracker:** [`docs/BUG_TRACKER.md`](docs/BUG_TRACKER.md)
- **Analysis (Bahasa):** [`ANALISIS_AUTORESEARCHCLAW.md`](ANALISIS_AUTORESEARCHCLAW.md)

---

## 🔗 Resources

- **Repository:** https://github.com/aiming-lab/AutoResearchClaw
- **Discord:** https://discord.gg/u4ksqW5P
- **License:** MIT

---

## ⚠️ Notes

1. **LLM Dependency:** Requires OpenAI-compatible API (OpenAI, Azure, local proxy)
2. **Cost:** Heavy LLM usage (23 stages × multiple calls per stage)
3. **Execution Time:** 40-85 minutes per paper (typical)
4. **Best For:** ML/AI research (less tested for other domains)
5. **Python Version:** Requires Python 3.11+

---

## 🎯 Quick Commands

```bash
# Validate config
researchclaw validate --config config.yaml

# Check environment
researchclaw doctor --config config.yaml

# Generate report
researchclaw report --run-dir artifacts/rc-20260322-161500-abc123/

# Resume from checkpoint
researchclaw run --resume --auto-approve

# Start from specific stage
researchclaw run --from-stage PAPER_OUTLINE --auto-approve
```

---

**Installed:** 2026-03-23  
**Version:** 0.3.1  
**Status:** ✅ Production Ready
