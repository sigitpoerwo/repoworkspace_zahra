# Analisis AutoResearchClaw

**Tanggal Analisis:** 2026-03-22  
**Versi:** v0.3.1  
**Repository:** https://github.com/aiming-lab/AutoResearchClaw.git

---

## 🎯 Executive Summary

**AutoResearchClaw** adalah sistem pipeline riset otomatis yang mengubah ide riset menjadi paper akademik lengkap tanpa intervensi manusia. Sistem ini menggunakan 23 stage dalam 8 fase, dengan integrasi multi-agent, self-learning, dan hardware-aware execution.

### Key Highlights
- **23-stage autonomous pipeline** — dari topic init hingga citation verification
- **Multi-agent architecture** — CodeAgent, BenchmarkAgent, FigureAgent
- **Self-learning via MetaClaw** — cross-run knowledge transfer (+18.3% robustness)
- **Hardware-aware execution** — auto-detect GPU (CUDA/MPS/CPU) dan adaptasi code generation
- **Real literature integration** — OpenAlex, Semantic Scholar, arXiv dengan 4-layer citation verification
- **Conference-ready output** — LaTeX untuk NeurIPS/ICML/ICLR dengan BibTeX terverifikasi
- **OpenClaw compatible** — bisa dijalankan via natural language interface

---

## 🏗️ Arsitektur Sistem

### 1. Pipeline Structure (23 Stages, 8 Phases)

```
Phase A: Research Scoping (Stage 1-2)
├── TOPIC_INIT: Formulate SMART goal + hardware detection
└── PROBLEM_DECOMPOSE: Break into sub-questions

Phase B: Literature Discovery (Stage 3-6)
├── SEARCH_STRATEGY: Plan queries & sources
├── LITERATURE_COLLECT: Real API calls (arXiv → Semantic Scholar)
├── LITERATURE_SCREEN: [GATE] Filter by relevance
└── KNOWLEDGE_EXTRACT: Extract structured knowledge cards

Phase C: Knowledge Synthesis (Stage 7-8)
├── SYNTHESIS: Cluster findings, identify gaps
└── HYPOTHESIS_GEN: Generate falsifiable hypotheses

Phase D: Experiment Design (Stage 9-11)
├── EXPERIMENT_DESIGN: [GATE] Design plan with baselines
├── CODE_GENERATION: Hardware-aware Python code
└── RESOURCE_PLANNING: Estimate GPU/time requirements

Phase E: Experiment Execution (Stage 12-13)
├── EXPERIMENT_RUN: Execute in sandbox/docker
└── ITERATIVE_REFINE: Self-healing code repair (max 10 iterations)

Phase F: Analysis & Decision (Stage 14-15)
├── RESULT_ANALYSIS: Statistical analysis
└── RESEARCH_DECISION: PROCEED/PIVOT/REFINE decision

Phase G: Paper Writing (Stage 16-19)
├── PAPER_OUTLINE: Section-level outline
├── PAPER_DRAFT: 5,000-6,500 words, anti-fabrication guard
├── PEER_REVIEW: Multi-agent review with NeurIPS rubric
└── PAPER_REVISION: Address reviews with length guard

Phase H: Finalization (Stage 20-23)
├── QUALITY_GATE: [GATE] Quality check
├── KNOWLEDGE_ARCHIVE: Save retrospective
├── EXPORT_PUBLISH: Generate LaTeX + charts + code
└── CITATION_VERIFY: 4-layer verification (arXiv/CrossRef/DataCite/LLM)
```

### 2. Multi-Agent Subsystems

#### CodeAgent (`researchclaw/pipeline/code_agent.py`)
- **Fungsi:** Generate & repair experiment code
- **Capabilities:**
  - AST validation & import whitelist
  - Hardware-aware package selection
  - Self-healing repair (max 5 attempts)
  - OpenCode Beast Mode integration (complex multi-file projects)
  - Timeout-aware prompts & NaN/divergence fast-fail

#### BenchmarkAgent (`researchclaw/agents/benchmark_agent/`)
- **Fungsi:** Automated benchmark selection & validation
- **Sub-agents:**
  - **Surveyor:** Identify relevant benchmarks
  - **Acquirer:** Fetch benchmark data/code
  - **Selector:** Choose appropriate benchmarks
  - **Validator:** Verify benchmark integrity
  - **Orchestrator:** Coordinate workflow

#### FigureAgent (`researchclaw/agents/figure_agent/`)
- **Fungsi:** Automated figure generation
- **Sub-agents:**
  - **Decision:** Analyze paper → decide figures needed
  - **Planner:** Design figure specifications
  - **CodeGen:** Generate matplotlib/seaborn code
  - **Renderer:** Execute code → produce images
  - **Critic:** Quality check (3 iteration max)
  - **NanoBanana:** Gemini-based image generation
  - **Integrator:** Combine into manifest

### 3. Core Components

#### Configuration System (`researchclaw/config.py`)
```python
@dataclass
class RCConfig:
    project: ProjectConfig
    research: ResearchConfig
    runtime: RuntimeConfig
    llm: LLMConfig
    experiment: ExperimentConfig
    export: ExportConfig
    security: SecurityConfig
    knowledge_base: KnowledgeBaseConfig
    metaclaw_bridge: MetaClawBridgeConfig
    openclaw_bridge: OpenClawBridgeConfig
```

#### Prompt Management (`researchclaw/prompts.py`)
- **Externalized prompts:** Semua prompt LLM dalam YAML
- **Template rendering:** Safe `{variable}` substitution
- **Evolution overlay:** Inject lessons dari run sebelumnya
- **Customizable:** User bisa override via YAML file

#### LLM Client (`researchclaw/llm/client.py`)
- **Multi-provider support:** OpenAI, Azure, DeepSeek, Minimax, OpenRouter
- **ACP integration:** Agent Client Protocol untuk Claude Code, Copilot, Gemini CLI
- **Fallback chain:** Auto-retry dengan model fallback
- **Rate limiting:** Exponential backoff

#### Literature Search (`researchclaw/literature/`)
- **Multi-source:** OpenAlex → Semantic Scholar → arXiv
- **Query expansion:** Broader coverage dengan variant queries
- **Deduplication:** DOI/arXiv ID matching
- **Circuit breaker:** Graceful degradation on API failures
- **Citation verification:** 4-layer check (arXiv ID → CrossRef/DataCite → S2 title → LLM relevance)

---

## 🧠 Fitur Unggulan

### 1. MetaClaw Integration (Cross-Run Learning)

**Konsep:** Pipeline belajar dari setiap run — failures → lessons → skills → injected ke prompt

**Flow:**
```
Run N executes → failures/warnings captured as Lessons
                      ↓
          MetaClaw Lesson → Skill conversion
                      ↓
          arc-* Skill files stored in ~/.metaclaw/skills/
                      ↓
Run N+1 → build_overlay() injects skills into every LLM prompt
                      ↓
          LLM avoids known pitfalls → higher quality
```

**Implementation:** [`researchclaw/metaclaw_bridge/`](AutoResearchClaw/researchclaw/metaclaw_bridge/)
- `lesson_to_skill.py`: Convert lessons → MetaClaw skills
- `prm_gate.py`: Process Reward Model gating
- `skill_feedback.py`: Feedback loop
- `stage_skill_map.py`: Map stages → relevant skills

**Results (Controlled A/B):**
| Metric | Baseline | With MetaClaw | Improvement |
|--------|----------|---------------|-------------|
| Stage retry rate | 10.5% | 7.9% | **-24.8%** |
| Refine cycle count | 2.0 | 1.2 | **-40.0%** |
| Pipeline completion | 18/19 | 19/19 | **+5.3%** |
| Overall robustness | 0.714 | 0.845 | **+18.3%** |

### 2. Hardware-Aware Execution

**Auto-detection:** Stage 1 detects GPU hardware
```python
# researchclaw/hardware.py
def detect_hardware() -> HardwareProfile:
    # NVIDIA CUDA
    if torch.cuda.is_available():
        return {"gpu_type": "cuda", "tier": "high", ...}
    # Apple MPS
    elif torch.backends.mps.is_available():
        return {"gpu_type": "mps", "tier": "limited", ...}
    # CPU-only
    else:
        return {"gpu_type": "cpu", "tier": "none", ...}
```

**Adaptive Code Generation:**
- **High-tier GPU:** Full PyTorch dengan GPU acceleration
- **Limited GPU:** Lightweight experiments (<1M params, <=20 epochs)
- **CPU-only:** NumPy/sklearn only, no deep learning

### 3. OpenCode Beast Mode

**Konsep:** Complex experiments auto-routed ke OpenCode untuk multi-file generation

**Trigger:** Complexity scoring (0.0-1.0) berdasarkan:
- Multi-model comparison
- Custom architectures
- Ablation studies
- Large-scale experiments

**Flow:**
```python
# researchclaw/pipeline/opencode_bridge.py
if complexity_score > threshold:
    # Route to OpenCode
    result = opencode_generate(
        prompt=enhanced_prompt,
        workspace=temp_workspace,
        model=config.opencode.model,
        timeout=config.opencode.timeout_sec
    )
    # Collect generated files
    files = collect_opencode_output(workspace)
```

**Benefits:**
- Multi-file projects (models/, utils/, train.py, eval.py)
- Custom training loops
- Advanced architectures
- Graceful fallback ke single-file generation

### 4. Self-Healing Experiment Execution

**Sandbox Execution:** [`researchclaw/pipeline/executor.py`](AutoResearchClaw/researchclaw/pipeline/executor.py)
```python
def execute_stage(stage, config, ...):
    for attempt in range(max_retries):
        result = run_experiment(code)
        if result.success:
            return result
        # Self-healing repair
        issues = validate_code(code)
        repaired_code = llm.repair(code, issues)
        code = repaired_code
```

**Safety Features:**
- AST validation (no eval/exec/subprocess)
- Import whitelist
- Memory limit & timeout
- NaN/Inf fast-fail
- Partial result capture on timeout

### 5. Multi-Agent Peer Review

**Stage 18:** Simulated peer review dengan multi-perspective debate

**Rubric:** NeurIPS/ICML scoring (1-10)
- Novelty & originality
- Technical quality
- Clarity & presentation
- Reproducibility
- Significance

**Checks:**
- Baselines included?
- Ablation studies present?
- Claims vs evidence consistency
- Methodology-evidence alignment

### 6. Citation Verification (4-Layer)

**Stage 23:** Fact-check semua references

**Layers:**
1. **arXiv ID check:** Validate arXiv IDs via API
2. **CrossRef/DataCite DOI:** Verify DOIs
3. **Semantic Scholar title match:** Fuzzy title matching
4. **LLM relevance scoring:** Check citation relevance to paper

**Output:** `verification_report.json` + `references_verified.bib` (hallucinated refs removed)

---

## 🔧 Experiment Modes

### 1. Simulated (Default)
- LLM generates synthetic results
- Fast, no setup required
- Not real experiments

### 2. Sandbox
- Real Python execution in subprocess
- AST validation + import whitelist
- Hardware-aware (GPU/MPS/CPU)
- Memory limit & timeout

### 3. Docker
- Isolated container execution
- GPU passthrough (NVIDIA)
- Network policies (none/setup_only/pip_only/full)
- Pre-cached datasets (CIFAR-10/100, MNIST, etc.)
- Three-phase execution:
  - Phase 0: pip install (network enabled)
  - Phase 1: setup.py (network enabled)
  - Phase 2: experiment (network disabled via iptables)

### 4. SSH Remote
- Execute on remote GPU server
- SSH-based file transfer
- Multi-GPU support

---

## 📊 Output Artifacts

**Deliverables Directory:** `artifacts/rc-YYYYMMDD-HHMMSS-<hash>/deliverables/`

| File | Description |
|------|-------------|
| `paper.tex` | Conference-ready LaTeX |
| `paper_final.md` | Markdown version |
| `references.bib` | Verified BibTeX |
| `references_verified.bib` | Post-verification BibTeX |
| `verification_report.json` | Citation fact-check results |
| `charts/` | Auto-generated figures |
| `code/` | Experiment code package |
| `code/experiment.py` | Final experiment code |
| `code/requirements.txt` | Dependencies |
| `code/README.md` | Reproduction guide |

---

## 🎨 Conference Templates

**Supported:**
- `neurips_2024`
- `neurips_2025`
- `iclr_2025`
- `iclr_2026`
- `icml_2025`
- `icml_2026`

**Template System:** [`researchclaw/templates/`](AutoResearchClaw/researchclaw/templates/)
- `converter.py`: Markdown → LaTeX conversion
- `compiler.py`: LaTeX compilation (pdflatex/tectonic)
- `conference.py`: Conference-specific formatting
- `styles/`: Conference style files (.sty, .bst)

---

## 🔌 Integration Points

### 1. OpenClaw Integration

**Natural Language Interface:**
```
User: "Research graph neural networks for drug discovery"
OpenClaw: [reads RESEARCHCLAW_AGENTS.md]
         → clones repo
         → pip install -e .
         → creates config.yaml
         → researchclaw run --topic "..." --auto-approve
         → returns paper + experiments + citations
```

**Bridge Adapters:** [`researchclaw/adapters.py`](AutoResearchClaw/researchclaw/adapters.py)
- `use_cron`: Scheduled research runs
- `use_message`: Progress notifications (Discord/Slack/Telegram)
- `use_memory`: Cross-session knowledge persistence
- `use_sessions_spawn`: Parallel sub-sessions
- `use_web_fetch`: Live web search
- `use_browser`: Browser-based paper collection

### 2. ACP (Agent Client Protocol)

**Supported Agents:**
- Claude Code (`claude`)
- Codex CLI (`codex`)
- Copilot CLI (`gh`)
- Gemini CLI (`gemini`)
- OpenCode (`opencode`)
- Kimi CLI (`kimi`)

**Config:**
```yaml
llm:
  provider: "acp"
  acp:
    agent: "claude"
    cwd: "."
```

### 3. Python API

```python
from researchclaw.pipeline import Runner
from researchclaw.config import RCConfig

config = RCConfig.from_yaml("config.yaml")
runner = Runner(config)
result = runner.run()
```

---

## 🧪 Testing & Quality

**Test Coverage:** 1,634 tests passed

**Test Categories:**
- Unit tests: Core components
- Integration tests: Multi-stage flows
- E2E tests: Full pipeline runs
- Regression tests: Known issues
- Domain-specific tests: ML/NLP/RL/Vision

**Quality Gates:**
- Stage 5: Literature screening
- Stage 9: Experiment design
- Stage 20: Paper quality

**Sentinel Watchdog:** [`sentinel.sh`](AutoResearchClaw/sentinel.sh)
- Background quality monitor
- NaN/Inf detection
- Paper-evidence consistency
- Citation relevance scoring
- Anti-fabrication guard

---

## 💡 Lessons Learned (dari Codebase)

### 1. Prompt Engineering Best Practices

**Dari `researchclaw/prompts.py`:**
- Externalize prompts ke YAML (user customization)
- Safe template rendering (preserve JSON schemas)
- Evolution overlay (inject lessons dari run sebelumnya)
- Reusable blocks (topic_constraint, pkg_hint, etc.)

### 2. Multi-Agent Orchestration

**Dari `researchclaw/agents/`:**
- Clear agent boundaries (single responsibility)
- Typed interfaces (contracts)
- Retry logic dengan max iterations
- Graceful degradation (fallback strategies)
- Structured output (JSON schemas)

### 3. Hardware-Aware Code Generation

**Dari `researchclaw/hardware.py` + `_code_generation.py`:**
- Auto-detect hardware capabilities
- Adapt package selection (torch vs numpy)
- Inject device hints ke prompt
- Scale experiments based on GPU tier
- Fallback ke CPU-only mode

### 4. Self-Healing Execution

**Dari `researchclaw/pipeline/executor.py`:**
- AST validation before execution
- Capture validation errors
- LLM-based repair dengan error context
- Max retry limit (prevent infinite loops)
- Partial result capture on timeout

### 5. Citation Verification

**Dari `researchclaw/literature/verify.py`:**
- Multi-layer verification (arXiv → DOI → title → LLM)
- Graceful degradation (API failures)
- Hallucination detection
- Auto-prune fake references
- Relevance scoring

---

## 🚀 Aplikasi ke Zahra Workspace

### 1. Adopt Multi-Agent Architecture

**Current:** Monolithic skills  
**Improvement:** Break into specialized agents

```
Research Agent (AutoResearchClaw-inspired)
├── Literature Agent: Search + screen papers
├── Experiment Agent: Design + execute + analyze
├── Writing Agent: Outline + draft + revise
└── Review Agent: Quality check + citation verify
```

### 2. Implement Self-Learning System

**Adopt MetaClaw pattern:**
```
.ai/memory/lessons.json → extract failures
                       ↓
          LLM converts → skills/arc-*/SKILL.md
                       ↓
          Next run → inject skills into prompts
```

**Benefits:**
- Workspace learns from mistakes
- No repeated errors
- Continuous improvement

### 3. Hardware-Aware Execution

**For AI Agent & Bot projects:**
```python
# Detect hardware
hw = detect_hardware()

# Adapt code generation
if hw.has_gpu:
    prompt += "Use PyTorch with GPU acceleration"
else:
    prompt += "Use NumPy/sklearn only (CPU-only)"
```

### 4. Structured Pipeline Stages

**Adopt stage-based workflow:**
```
Stage 1: Requirements Analysis
Stage 2: Architecture Design
Stage 3: Implementation
Stage 4: Testing
Stage 5: Deployment
Stage 6: Monitoring

Each stage:
- Clear input/output artifacts
- Validation gates
- Rollback targets
- Evolution overlay
```

### 5. Quality Gates & Checkpoints

**Implement HITL gates:**
```yaml
security:
  hitl_required_stages: [3, 5, 6]  # Architecture, Testing, Deployment
  allow_publish_without_approval: false
```

**Checkpoint system:**
```json
{
  "last_completed_stage": 3,
  "run_id": "proj-20260322-161500",
  "timestamp": "2026-03-22T16:15:00Z"
}
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

**Benefits:**
- Easy customization
- Version control
- A/B testing
- Domain-specific variants

---

## 📈 Metrics & Performance

**From README:**
- **1,634 tests passed**
- **8 papers generated** (math, stats, bio, computing, NLP, RL, vision, robustness)
- **Zero human intervention** (full autonomous)
- **MetaClaw improvement:** +18.3% robustness

**Pipeline Execution Time (typical):**
- Phase A-B (Scoping + Literature): 10-15 min
- Phase C-D (Synthesis + Design): 5-10 min
- Phase E (Execution): 5-30 min (depends on experiments)
- Phase F-G (Analysis + Writing): 15-20 min
- Phase H (Finalization): 5-10 min
- **Total:** 40-85 min per paper

---

## 🎯 Key Takeaways

### Strengths
1. **Fully autonomous** — end-to-end tanpa human intervention
2. **Self-learning** — MetaClaw integration untuk continuous improvement
3. **Hardware-aware** — adaptasi otomatis ke GPU/MPS/CPU
4. **Real literature** — bukan hallucination, verified citations
5. **Multi-agent** — specialized agents untuk complex tasks
6. **Production-grade** — 1,634 tests, error handling, rollback logic
7. **Extensible** — plugin architecture, custom prompts, domain adapters

### Weaknesses
1. **LLM dependency** — heavy reliance on LLM quality
2. **Cost** — banyak LLM calls (23 stages × multiple calls per stage)
3. **Execution time** — 40-85 min per paper (not instant)
4. **Complexity** — steep learning curve untuk customization
5. **Domain limitations** — best for ML/AI research, less tested for other domains

### Lessons for Zahra Workspace
1. **Stage-based workflow** → clear progression, rollback capability
2. **Multi-agent architecture** → specialized agents, better than monolithic
3. **Self-learning system** → MetaClaw pattern untuk continuous improvement
4. **Hardware-aware execution** → adapt to available resources
5. **Quality gates** → HITL checkpoints untuk critical decisions
6. **Prompt externalization** → YAML-based, easy customization
7. **Structured artifacts** → JSON/YAML/Markdown, machine-readable
8. **Citation verification** → multi-layer fact-checking
9. **Graceful degradation** → fallback strategies, circuit breakers
10. **Evolution overlay** → inject lessons into prompts

---

## 🔗 Resources

- **Repository:** https://github.com/aiming-lab/AutoResearchClaw
- **Documentation:** [`docs/integration-guide.md`](AutoResearchClaw/docs/integration-guide.md)
- **Paper Showcase:** [`docs/showcase/SHOWCASE.md`](AutoResearchClaw/docs/showcase/SHOWCASE.md)
- **Discord:** https://discord.gg/u4ksqW5P

---

## 📝 Next Steps

1. **Study MetaClaw integration** → implement similar pattern di Zahra Workspace
2. **Adopt multi-agent architecture** → break monolithic skills into specialized agents
3. **Implement stage-based workflow** → clear progression + rollback
4. **Add quality gates** → HITL checkpoints untuk critical stages
5. **Externalize prompts** → move to `.ai/prompts.yaml`
6. **Hardware detection** → adapt code generation based on available resources
7. **Self-learning system** → lessons → skills → prompt injection

---

**Analyzed by:** Zahra Maurita  
**Date:** 2026-03-22  
**Status:** ✅ Complete
