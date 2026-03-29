---
name: ai-researcher
description: Automate scientific research from literature review to paper generation. Use when conducting research, teaching methodology, supervising students, or accelerating publication workflows.
---

# AI-Researcher: Autonomous Scientific Research Automation

## When to Use This Skill

**Trigger this skill when:**
- User asks to "conduct literature review" or "analyze research papers"
- User wants to "generate research ideas" or "explore research directions"
- User needs to "implement research algorithm" or "create baseline"
- User asks to "draft academic paper" or "write research paper"
- User mentions "supervise student research" or "help with thesis"
- User needs to "accelerate publication" or "meet conference deadline"
- User asks about "research methodology" or "scientific workflow"

**DO NOT trigger when:**
- Simple code implementation without research context
- General programming questions
- Non-academic writing tasks
- Basic literature search (use web search instead)

## Core Workflow

### Step 1: Identify Research Task Type

Determine which research phase the user needs help with:

1. **Literature Review** → Generate comprehensive paper analysis
2. **Ideation** → Generate novel research directions
3. **Implementation** → Create algorithm and experiments
4. **Experimentation** → Run benchmarks and analyze results
5. **Paper Writing** → Draft academic manuscript
6. **Full Pipeline** → End-to-end research automation

### Step 2: Gather Requirements

Ask user for:
- Research topic or idea description
- OR reference papers for ideation
- Target domain (GNN, diffusion, reasoning, etc.)
- Desired output format
- Timeline and constraints

### Step 3: Execute Research Pipeline

Follow the appropriate workflow based on task type.

## Workflows

### Workflow A: Literature Review

**Input:** Research topic or keywords

**Process:**
1. Search relevant papers (Semantic Scholar, arXiv)
2. Analyze and categorize papers by contribution
3. Identify research gaps and opportunities
4. Synthesize findings into structured review
5. Generate timeline of key developments

**Output:** Comprehensive literature review with:
- Key papers and contributions
- Research evolution timeline
- Identified gaps
- Future directions

**Example:**
```
User: "I need a literature review on graph neural networks for recommendation systems"

Process:
1. Search papers: "graph neural networks recommendation" (2018-2026)
2. Analyze top 20 papers by citations
3. Categorize: collaborative filtering, knowledge graphs, temporal dynamics
4. Identify gap: "Limited work on cold-start with temporal context"
5. Generate 5-page review with 50+ citations

Output: Structured review document ready for thesis chapter
```

### Workflow B: Research Ideation

**Input:** Reference papers or research area

**Process:**
1. Analyze reference papers deeply
2. Extract key methodologies and limitations
3. Identify combination opportunities
4. Generate 3-5 novel research directions
5. Rank by feasibility and impact

**Output:** Research proposal with:
- Novel idea descriptions
- Methodology outlines
- Expected contributions
- Implementation roadmap

**Example:**
```
User: "Generate research ideas combining these papers: [Paper A on GCN], [Paper B on Temporal Networks]"

Process:
1. Extract: GCN uses spatial aggregation, Temporal Networks capture dynamics
2. Identify limitation: GCN lacks temporal modeling
3. Generate idea: "Temporal Graph Convolutional Network with Attention"
4. Outline methodology: Time-aware message passing + attention mechanism
5. Estimate impact: Addresses cold-start + temporal drift

Output: 3 research proposals with implementation plans
```

### Workflow C: Algorithm Implementation

**Input:** Research idea or methodology description

**Process:**
1. Design algorithm architecture
2. Generate PyTorch/TensorFlow implementation
3. Create training and evaluation scripts
4. Setup experiment configurations
5. Add documentation and tests

**Output:** Complete codebase with:
- Model implementation
- Training pipeline
- Evaluation metrics
- Configuration files
- Unit tests

**Example:**
```
User: "Implement a graph attention network for recommendation with temporal features"

Process:
1. Design: GAT layers + temporal encoding + prediction head
2. Implement: model.py (200 lines), train.py (150 lines), eval.py (100 lines)
3. Config: hyperparameters, dataset paths, logging
4. Tests: Unit tests for each component
5. Docs: README with usage instructions

Output: Runnable codebase ready for experiments
```

### Workflow D: Paper Generation

**Input:** Research results and methodology

**Process:**
1. Structure paper sections (IMRaD format)
2. Generate abstract and introduction
3. Write methodology with algorithms
4. Present results with tables/figures
5. Draft conclusion and future work
6. Format citations and references

**Output:** Full paper draft in LaTeX/Word

**Example:**
```
User: "Draft paper for my GNN recommendation system results"

Input:
- Method: Temporal GAT with contrastive learning
- Results: NDCG@10=0.342, Recall@20=0.456
- Baselines: GCN, LightGCN, NGCF

Process:
1. Abstract: Problem + method + results (150 words)
2. Intro: Motivation + contributions (2 pages)
3. Method: Architecture + training (3 pages)
4. Experiments: Setup + results + analysis (3 pages)
5. Conclusion: Summary + future work (1 page)

Output: 9-page conference paper draft in ACM format
```

## For Lecturers: Teaching Integration

### Use Case 1: Research Methodology Course

**Objective:** Teach students end-to-end research process

**Lesson Plan:**
1. **Week 1-2: Literature Review**
   - Demo: Generate review on sample topic
   - Activity: Students critique AI-generated review
   - Assignment: Manual review vs AI review comparison

2. **Week 3-4: Idea Generation**
   - Demo: Generate ideas from reference papers
   - Activity: Students evaluate feasibility
   - Assignment: Refine AI-generated ideas

3. **Week 5-6: Implementation**
   - Demo: Generate baseline algorithm
   - Activity: Code review and improvement
   - Assignment: Extend baseline with novel feature

4. **Week 7-8: Paper Writing**
   - Demo: Generate paper draft
   - Activity: Identify gaps and improve
   - Assignment: Complete polished paper

**Learning Outcomes:**
- Understand research workflow
- Develop critical evaluation skills
- Learn to collaborate with AI tools
- Maintain academic integrity

### Use Case 2: Student Thesis Supervision

**Scenario:** Student stuck on thesis progress

**Intervention Steps:**
1. **Diagnose bottleneck**
   - Literature review taking too long?
   - Implementation challenges?
   - Writing difficulties?

2. **Apply AI-Researcher**
   - Generate literature review → Student analyzes gaps
   - Generate baseline code → Student adds novelty
   - Draft paper sections → Student refines

3. **Review and validate**
   - Check AI output quality
   - Ensure student understands
   - Verify novel contributions

4. **Guide refinement**
   - Student improves AI baseline
   - Add domain-specific insights
   - Polish for submission

**Success Criteria:**
- Student understands all AI-generated content
- Novel contributions are clearly student's work
- Results are reproducible and validated
- Paper meets publication standards

### Use Case 3: Conference Paper Acceleration

**Scenario:** Tight deadline for conference submission

**Workflow:**
1. **Day 1-2: Literature & Ideation**
   - AI generates literature review
   - You refine and add insights
   - Finalize research gap

2. **Day 3-5: Implementation**
   - AI generates baseline algorithm
   - You add novel components
   - Run initial experiments

3. **Day 6-8: Experimentation**
   - AI runs benchmark suite
   - You analyze results
   - Design additional experiments

4. **Day 9-12: Paper Writing**
   - AI drafts all sections
   - You review and refine
   - Add domain expertise

5. **Day 13-14: Polish & Submit**
   - Final review
   - Format for conference
   - Submit before deadline

**Time Saved:** 4-6 weeks → 2 weeks

## Setup Instructions

### Prerequisites

```bash
# System requirements
- Docker installed
- GPU with 8GB+ VRAM (optional but recommended)
- 16GB+ RAM
- 50GB+ disk space
- Python 3.8+
```

### Installation

```bash
# 1. Clone repository
git clone https://github.com/HKUDS/AI-Researcher.git
cd AI-Researcher

# 2. Setup environment
docker-compose up -d

# 3. Install dependencies
pip install -r requirements.txt

# 4. Configure API keys
cp .env.example .env
nano .env  # Add your API keys

# Required API keys:
# - OPENROUTER_API_KEY (for LLM access)
# OR
# - GITHUB_AI_API_KEY (alternative LLM provider)

# 5. Launch Web GUI
python app.py

# Access at: http://localhost:8000
```

### Configuration

```python
# config.yaml
research:
  literature_review:
    max_papers: 50
    min_citations: 10
    years: [2018, 2026]

  implementation:
    framework: "pytorch"
    device: "cuda"  # or "cpu"
    seed: 42

  paper_generation:
    template: "ACM"  # or "IEEE", "NeurIPS", "ICML"
    max_pages: 10
    include_appendix: true
```

## Detailed Examples

### Example 1: Generate Literature Review for Lecture

**Context:** Preparing lecture on GNN recommendation systems

**Input:**
```python
from ai_researcher import AIResearcher

researcher = AIResearcher()

review = researcher.literature_review(
    topic="Graph Neural Networks for Recommendation Systems",
    num_papers=30,
    years=(2018, 2026),
    include_timeline=True,
    include_gaps=True,
    output_format="markdown"
)
```

**Output:**
```markdown
# Literature Review: GNN for Recommendation Systems

## Timeline of Key Developments

**2018: Foundation**
- GCN-based collaborative filtering (Berg et al.)
- Graph attention for recommendations (Veličković et al.)

**2019-2020: Scaling & Efficiency**
- LightGCN: Simplified GCN (He et al.)
- PinSage: Billion-scale graphs (Ying et al.)

**2021-2022: Advanced Architectures**
- Temporal dynamics (Xu et al.)
- Multi-modal integration (Wei et al.)

**2023-2026: Current Trends**
- Contrastive learning approaches
- Self-supervised pre-training
- Large-scale foundation models

## Research Gaps
1. Limited work on cold-start with temporal context
2. Scalability challenges for real-time systems
3. Interpretability of GNN recommendations

## Future Directions
- Combine temporal GNNs with contrastive learning
- Develop efficient inference for production
- Improve explainability mechanisms
```

**Usage in Lecture:**
- Show students the review
- Discuss each paper's contribution
- Analyze research gaps together
- Assign students to explore one gap

### Example 2: Generate Baseline for Student Thesis

**Context:** Master's student needs baseline implementation

**Input:**
```python
researcher = AIResearcher()

idea = """
Research Idea: Temporal Graph Attention Network for E-commerce Recommendation

Problem: Existing GNN methods don't capture temporal user preferences

Proposed Solution:
- Use graph attention to model user-item interactions
- Add temporal encoding to capture preference drift
- Apply contrastive learning for robust representations

Datasets: Amazon-Electronics, Taobao
Baselines: GCN, LightGCN, NGCF, SASRec
Metrics: NDCG@10, Recall@20, MRR
"""

baseline = researcher.generate_baseline(
    idea=idea,
    framework="pytorch",
    include_tests=True,
    include_docs=True,
    include_visualization=True
)
```

**Output Structure:**
```
temporal_gat_recommendation/
├── models/
│   ├── temporal_gat.py          # Main model
│   ├── attention.py             # Attention mechanism
│   └── temporal_encoder.py      # Temporal encoding
├── data/
│   ├── dataset.py               # Dataset loader
│   └── preprocessing.py         # Data preprocessing
├── train.py                     # Training script
├── evaluate.py                  # Evaluation script
├── config.yaml                  # Hyperparameters
├── requirements.txt             # Dependencies
├── tests/                       # Unit tests
│   ├── test_model.py
│   └── test_data.py
├── notebooks/
│   └── visualization.ipynb      # Result visualization
└── README.md                    # Documentation
```

**Student's Next Steps:**
1. Review and understand baseline code
2. Identify improvement opportunities
3. Implement novel contributions (e.g., better temporal encoding)
4. Run experiments and compare with baseline
5. Write thesis with AI-assisted drafting

### Example 3: Quick Paper Draft for Conference

**Context:** Conference deadline in 2 weeks, need quick draft

**Input:**
```python
researcher = AIResearcher()

results = {
    "title": "Temporal Graph Attention for Dynamic Recommendation",
    "method": {
        "name": "TempGAT",
        "architecture": "GAT + Temporal Encoding + Contrastive Loss",
        "novelty": "Time-aware attention mechanism with self-supervised learning"
    },
    "experiments": {
        "datasets": ["Amazon-Electronics", "Taobao"],
        "baselines": ["GCN", "LightGCN", "NGCF", "SASRec"],
        "metrics": {
            "Amazon-Electronics": {
                "NDCG@10": 0.0342,
                "Recall@20": 0.0456,
                "MRR": 0.0289
            },
            "Taobao": {
                "NDCG@10": 0.0398,
                "Recall@20": 0.0512,
                "MRR": 0.0334
            }
        },
        "improvements": {
            "vs_GCN": "+12.3% NDCG@10",
            "vs_LightGCN": "+8.7% NDCG@10",
            "vs_SASRec": "+5.2% NDCG@10"
        }
    },
    "ablation": {
        "w/o_temporal": -0.0045,
        "w/o_attention": -0.0038,
        "w/o_contrastive": -0.0029
    }
}

paper = researcher.generate_paper(
    results=results,
    template="ACM",  # ACM conference format
    target_pages=9,
    include_figures=True,
    include_appendix=True
)
```

**Output:** Full paper draft with:
- Abstract (150 words)
- Introduction (2 pages) - motivation, contributions
- Related Work (1.5 pages) - categorized literature
- Methodology (2.5 pages) - architecture, training, complexity
- Experiments (2.5 pages) - setup, results, ablation, analysis
- Conclusion (0.5 pages) - summary, limitations, future work
- References (50+ citations)
- Appendix (hyperparameters, additional results)

**Your Refinement Tasks:**
1. Review methodology for correctness
2. Add domain-specific insights to introduction
3. Strengthen experimental analysis
4. Polish writing and fix logical gaps
5. Verify all citations are accurate
6. Add author contributions section

**Timeline:**
- Day 1-2: AI generates draft
- Day 3-7: You refine and add insights
- Day 8-10: Co-authors review
- Day 11-13: Final polish
- Day 14: Submit

## Best Practices

### ✅ DO

**1. Always Validate AI Output**
```
Before accepting any AI-generated content:
- Run the code and verify it works
- Check experimental results are reproducible
- Validate paper logic and argument flow
- Verify citations are accurate and relevant
```

**2. Use Iterative Refinement**
```
Don't accept first output:
1. Generate initial version
2. Review and identify issues
3. Regenerate with feedback
4. Repeat until satisfactory
5. Add your domain expertise
```

**3. Maintain Academic Integrity**
```
Transparency checklist:
- Acknowledge AI assistance if journal requires
- Ensure novel contributions are clearly yours
- Don't plagiarize AI-generated text
- Validate all experimental claims
```

**4. Teach Critical Evaluation**
```
When using with students:
- Show how to review AI code
- Discuss algorithm design decisions
- Identify potential improvements
- Emphasize validation importance
```

**5. Combine AI + Human Strengths**
```
AI excels at:
- Rapid literature synthesis
- Boilerplate code generation
- Experiment automation
- Draft structure

You excel at:
- Domain insights
- Novel ideas
- Critical analysis
- Contextual understanding
```

### ❌ DON'T

**1. Submit Without Review**
```
NEVER:
- Submit AI-generated paper directly
- Trust experimental results blindly
- Skip manual validation
- Assume code is bug-free
```

**2. Over-Rely on Automation**
```
AVOID:
- Letting AI replace learning
- Skipping fundamental understanding
- Losing research intuition
- Becoming dependent on automation
```

**3. Ignore Ethical Issues**
```
DON'T:
- Plagiarize AI-generated text
- Fabricate or manipulate results
- Misrepresent contributions
- Skip proper attribution
```

**4. Use for Inappropriate Tasks**
```
NOT SUITABLE FOR:
- Generating fake research data
- Writing papers on unfamiliar topics
- Replacing peer review process
- Bypassing learning requirements
```

## Teaching Integration

### Lecture Module: AI-Assisted Research

**Learning Objectives:**
- Understand AI research automation capabilities
- Develop critical evaluation skills
- Learn to collaborate with AI tools
- Maintain research integrity

**Module Structure (4 weeks):**

**Week 1: Literature Review Automation**
```
Lecture (2 hours):
- Traditional vs AI-assisted literature review
- Demo: Generate review on sample topic
- Discussion: Quality assessment

Lab (2 hours):
- Students use AI-Researcher for assigned topic
- Compare with manual review
- Identify AI strengths and limitations

Assignment:
- Generate literature review using AI
- Write 2-page critique of AI output
- Manually add 5 papers AI missed
```

**Week 2: Algorithm Design & Implementation**
```
Lecture (2 hours):
- From idea to implementation
- Demo: Generate baseline algorithm
- Code review best practices

Lab (2 hours):
- Students generate baseline for project idea
- Analyze code quality and correctness
- Identify bugs and improvements

Assignment:
- Generate baseline implementation
- Fix bugs and add improvements
- Document changes and rationale
```

**Week 3: Experimentation & Validation**
```
Lecture (2 hours):
- Experimental design principles
- Reproducibility and validation
- Demo: Run AI-generated experiments

Lab (2 hours):
- Students run baseline experiments
- Validate results
- Design additional experiments

Assignment:
- Reproduce AI-generated results
- Run ablation studies
- Analyze and interpret findings
```

**Week 4: Academic Writing**
```
Lecture (2 hours):
- Paper structure and conventions
- Demo: Generate paper draft
- Writing quality assessment

Lab (2 hours):
- Students generate paper draft
- Peer review AI-generated papers
- Refine and improve drafts

Assignment:
- Generate complete paper draft
- Refine with domain insights
- Submit for peer review
```

### Student Project Framework

**Project: AI-Assisted Research Paper**

**Phase 1: Proposal (Week 1-2)**
- Student submits research idea
- AI generates literature review
- Student refines and identifies gap
- Deliverable: 3-page proposal

**Phase 2: Implementation (Week 3-6)**
- AI generates baseline code
- Student analyzes and improves
- Student adds novel contributions
- Deliverable: Working implementation

**Phase 3: Experimentation (Week 7-10)**
- AI runs baseline experiments
- Student validates results
- Student designs additional experiments
- Deliverable: Experimental results

**Phase 4: Paper Writing (Week 11-14)**
- AI drafts paper sections
- Student refines and polishes
- Peer review and revision
- Deliverable: Conference-ready paper

**Grading Rubric:**
- Literature Review Quality (15%)
- Baseline Understanding (15%)
- Novel Contributions (30%)
- Experimental Rigor (20%)
- Paper Quality (15%)
- Presentation (5%)

## Troubleshooting

### Issue: Generated Code Doesn't Run

**Symptoms:**
- Import errors
- Runtime exceptions
- Incorrect outputs

**Diagnosis:**
1. Check Python version compatibility
2. Verify all dependencies installed
3. Review error traceback
4. Check data paths and formats

**Solution:**
```bash
# Check dependencies
pip list | grep -E "torch|numpy|pandas"

# Reinstall if needed
pip install -r requirements.txt --upgrade

# Debug step-by-step
python -c "import torch; print(torch.__version__)"
python -c "from models.temporal_gat import TemporalGAT"
```

### Issue: Results Don't Match Expectations

**Symptoms:**
- Metrics lower than reported
- Training doesn't converge
- Inconsistent results across runs

**Diagnosis:**
1. Check random seeds are set
2. Verify dataset preprocessing
3. Review hyperparameters
4. Compare with reference implementation

**Solution:**
```python
# Set all random seeds
import torch
import numpy as np
import random

def set_seed(seed=42):
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    np.random.seed(seed)
    random.seed(seed)
    torch.backends.cudnn.deterministic = True

# Verify data preprocessing
print(f"Train samples: {len(train_data)}")
print(f"Test samples: {len(test_data)}")
print(f"Feature shape: {train_data[0].shape}")

# Log hyperparameters
print(f"Learning rate: {config.lr}")
print(f"Batch size: {config.batch_size}")
print(f"Epochs: {config.epochs}")
```

### Issue: Paper Draft Has Logical Gaps

**Symptoms:**
- Methodology unclear
- Results not well explained
- Weak argumentation

**Diagnosis:**
1. Check if all experimental details provided
2. Review methodology description
3. Verify result interpretation

**Solution:**
```
Manual refinement needed:
1. Add missing experimental details
2. Strengthen methodology explanation
3. Improve result analysis with insights
4. Add domain-specific context
5. Clarify contributions
```

## Advanced Usage

### Custom Research Pipeline

```python
from ai_researcher import AIResearcher, Pipeline

# Create custom pipeline
pipeline = Pipeline([
    ("literature", researcher.literature_review),
    ("ideation", researcher.generate_ideas),
    ("implementation", researcher.implement_algorithm),
    ("experiments", researcher.run_experiments),
    ("analysis", researcher.analyze_results),
    ("writing", researcher.generate_paper)
])

# Run full pipeline
results = pipeline.run(
    input_topic="Temporal GNN for Recommendation",
    config={
        "literature": {"max_papers": 50},
        "implementation": {"framework": "pytorch"},
        "experiments": {"datasets": ["MovieLens", "Amazon"]},
        "writing": {"template": "ACM"}
    }
)

# Output: Complete research package
# - literature_review.pdf
# - code/ (implementation)
# - results/ (experimental data)
# - paper_draft.tex
```

### Integration with Existing Tools

```python
# Combine with Weights & Biases for tracking
import wandb

wandb.init(project="ai-researcher-experiments")

# Run experiments with tracking
results = researcher.run_experiments(
    model=model,
    datasets=datasets,
    log_to_wandb=True
)

# Generate paper with W&B figures
paper = researcher.generate_paper(
    results=results,
    include_wandb_plots=True
)
```

## Ethical Guidelines

### For Lecturers

**Teaching Responsibilities:**
1. Educate students on proper AI use
2. Set clear guidelines for AI assistance
3. Teach critical evaluation skills
4. Emphasize academic integrity

**Assessment Considerations:**
- Require students to document AI usage
- Grade based on understanding, not just output
- Test comprehension through oral defense
- Evaluate novel contributions separately

### For Researchers

**Publication Ethics:**
1. Review journal policies on AI assistance
2. Acknowledge AI tools if required
3. Ensure all claims are validated
4. Maintain transparency in methods

**Collaboration Guidelines:**
- Discuss AI usage with co-authors
- Agree on contribution attribution
- Document AI-assisted sections
- Ensure all authors review AI output

## Resources

### Official Documentation
- Repository: https://github.com/HKUDS/AI-Researcher
- Issues: https://github.com/HKUDS/AI-Researcher/issues
- Wiki: https://github.com/HKUDS/AI-Researcher/wiki

### Related Tools
- **Semantic Scholar**: Literature search API
- **Papers with Code**: Benchmark datasets and leaderboards
- **Overleaf**: Collaborative LaTeX editing
- **Weights & Biases**: Experiment tracking and visualization
- **Zotero**: Reference management

### Learning Resources
- Research methodology courses
- Academic writing guides
- Machine learning tutorials
- Graph neural network papers

## Success Metrics

### For Teaching
- Student understanding of research process
- Quality of student-generated papers
- Novel contributions beyond AI baseline
- Student feedback on learning experience

### For Research
- Time saved in research pipeline
- Number of papers published
- Quality of AI-generated baselines
- Reproducibility of results

## Conclusion

AI-Researcher transforms the research process by automating routine tasks while preserving the need for human expertise, critical thinking, and domain knowledge. When used responsibly, it accelerates research and enhances teaching effectiveness.

**Remember:** AI-Researcher is a powerful assistant that amplifies your capabilities. Use it to handle routine tasks so you can focus on creative thinking, novel insights, and meaningful contributions.

---

**Skill Version:** 1.0
**Last Updated:** 2026-03-22
**Repository:** https://github.com/HKUDS/AI-Researcher
**Maintained by:** Zahra Maurita
