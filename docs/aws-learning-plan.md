# 🚀 AWS Learning Plan - Zahra Workspace

**Created:** 2026-03-25
**Repository:** Learn_AWS_from_Scratch (Cloned)
**Location:** `e:/ZAHRA-WORKSPACE/docs/aws-learning/`
**Status:** ✅ Ready to Start

---

## 📚 REPOSITORY STRUCTURE

```
aws-learning/
├── Cloud_Computing_Basics/    # Foundation concepts
├── EC2/                        # Virtual servers (6 lessons)
├── S3/                         # Object storage
├── AWS IAM/                    # Security & access (7 lessons)
├── RDS/                        # Databases
├── VPC/                        # Networking
└── README.md                   # Course overview
```

**Total Modules:** 7 core services
**Video Playlist:** https://youtube.com/playlist?list=PLOa-edppsqFn4MFr5KDqm0Y92d2nGyGgQ

---

## 🎯 21-DAY LEARNING PLAN

### Week 1: AWS Fundamentals (Days 1-7)

#### Day 1: Cloud Computing Basics
**Location:** `Cloud_Computing_Basics/`
**Topics:**
- Introduction to Cloud Computing
- Cloud Service Models (IaaS, PaaS, SaaS)
- Cloud Deployment Models (Public, Private, Hybrid)
- Benefits of Cloud Computing

**Tasks:**
- [ ] Read all 4 lessons
- [ ] Watch intro videos
- [ ] Take notes on key concepts
- [ ] Compare with current hosting (Vercel, Railway)

**Time:** 2 hours

---

#### Day 2-3: EC2 (Elastic Compute Cloud)
**Location:** `EC2/`
**Topics:**
- Introduction to EC2
- Launch an EC2 Instance
- Security Groups
- Elastic IPs
- AMI (Amazon Machine Images)
- Use Cases & Case Studies

**Tasks:**
- [ ] Read all 6 EC2 lessons
- [ ] Create AWS Free Tier account
- [ ] Launch first EC2 instance (t2.micro)
- [ ] Configure security groups
- [ ] SSH into instance
- [ ] Install Node.js on EC2
- [ ] Deploy simple app

**Hands-on Project:** Deploy SmartCS Landing to EC2

**Time:** 4 hours

---

#### Day 4: S3 (Simple Storage Service)
**Location:** `S3/`
**Topics:**
- S3 Buckets & Objects
- Storage Classes
- Versioning
- Static Website Hosting
- Permissions & Policies

**Tasks:**
- [ ] Read S3 documentation
- [ ] Create S3 bucket
- [ ] Upload files
- [ ] Enable static website hosting
- [ ] Configure bucket policies
- [ ] Setup CloudFront CDN

**Hands-on Project:** Host SmartCS Landing on S3 + CloudFront

**Time:** 3 hours

---

#### Day 5-6: IAM (Identity & Access Management)
**Location:** `AWS IAM/`
**Topics:**
- IAM Users
- IAM Groups
- IAM Roles
- IAM Policies
- Best Practices
- Troubleshooting

**Tasks:**
- [ ] Read all 7 IAM lessons
- [ ] Create IAM users
- [ ] Create IAM groups
- [ ] Attach policies
- [ ] Create IAM roles
- [ ] Setup MFA
- [ ] Generate access keys

**Hands-on Project:** Setup proper IAM structure for projects

**Time:** 4 hours

---

#### Day 7: VPC (Virtual Private Cloud)
**Location:** `VPC/`
**Topics:**
- VPC Basics
- Subnets (Public/Private)
- Route Tables
- Internet Gateway
- NAT Gateway
- Security Groups vs NACLs

**Tasks:**
- [ ] Read VPC documentation
- [ ] Create custom VPC
- [ ] Create subnets
- [ ] Configure route tables
- [ ] Setup internet gateway
- [ ] Test connectivity

**Hands-on Project:** Create isolated network for production

**Time:** 3 hours

**Week 1 Total:** 16 hours

---

### Week 2: DevOps Services (Days 8-14)

#### Day 8: RDS (Relational Database Service)
**Location:** `RDS/`
**Topics:**
- RDS Introduction
- Database Engines (PostgreSQL, MySQL)
- Instance Types
- Backups & Snapshots
- Read Replicas
- Multi-AZ Deployment

**Tasks:**
- [ ] Read RDS documentation
- [ ] Create PostgreSQL instance
- [ ] Connect from local
- [ ] Setup automated backups
- [ ] Test failover
- [ ] Monitor performance

**Hands-on Project:** Migrate Biosoltamax Bot DB to RDS

**Time:** 3 hours

---

#### Day 9-10: ECS & ECR (Container Services)
**Topics:**
- Docker basics review
- ECS Task Definitions
- ECS Services
- Fargate vs EC2 launch types
- ECR (Container Registry)
- Push/Pull images

**Tasks:**
- [ ] Review Docker fundamentals
- [ ] Create ECR repository
- [ ] Push Docker image to ECR
- [ ] Create ECS cluster
- [ ] Define ECS task
- [ ] Deploy service with Fargate
- [ ] Configure load balancer

**Hands-on Project:** Deploy Biosoltamax Bot to ECS Fargate

**Time:** 5 hours

---

#### Day 11: Lambda (Serverless)
**Topics:**
- Lambda Functions
- Triggers (API Gateway, S3, CloudWatch)
- Environment Variables
- Layers
- Cold Start Optimization

**Tasks:**
- [ ] Create Lambda function
- [ ] Setup API Gateway
- [ ] Test function
- [ ] Add environment variables
- [ ] Monitor with CloudWatch
- [ ] Optimize performance

**Hands-on Project:** Create serverless API for Google Workspace MCP

**Time:** 3 hours

---

#### Day 12: CloudWatch (Monitoring)
**Topics:**
- CloudWatch Metrics
- CloudWatch Logs
- CloudWatch Alarms
- Dashboards
- Log Insights

**Tasks:**
- [ ] Setup CloudWatch for all services
- [ ] Create custom metrics
- [ ] Configure log groups
- [ ] Create alarms (CPU, Memory, Errors)
- [ ] Build dashboard
- [ ] Setup SNS notifications

**Hands-on Project:** Complete monitoring for all 3 projects

**Time:** 3 hours

---

#### Day 13: Load Balancer & Auto Scaling
**Topics:**
- Application Load Balancer (ALB)
- Network Load Balancer (NLB)
- Target Groups
- Health Checks
- Auto Scaling Groups
- Scaling Policies

**Tasks:**
- [ ] Create ALB
- [ ] Configure target groups
- [ ] Setup health checks
- [ ] Create Auto Scaling Group
- [ ] Define scaling policies
- [ ] Test scaling

**Hands-on Project:** Add load balancing to SmartCS Landing

**Time:** 3 hours

---

#### Day 14: Review & Practice
**Tasks:**
- [ ] Review all Week 2 topics
- [ ] Fix any issues
- [ ] Optimize costs
- [ ] Document architecture
- [ ] Create architecture diagrams

**Time:** 3 hours

**Week 2 Total:** 20 hours

---

### Week 3: Advanced Topics (Days 15-21)

#### Day 15-16: CloudFormation (Infrastructure as Code)
**Topics:**
- CloudFormation Templates
- Stacks
- Parameters & Outputs
- Nested Stacks
- Change Sets
- Best Practices

**Tasks:**
- [ ] Learn YAML/JSON syntax
- [ ] Create first template
- [ ] Deploy stack
- [ ] Update stack
- [ ] Delete stack
- [ ] Create reusable templates

**Hands-on Project:** Convert all infrastructure to CloudFormation

**Time:** 5 hours

---

#### Day 17: SQS & SNS (Messaging)
**Topics:**
- SQS Queues (Standard vs FIFO)
- SNS Topics
- Pub/Sub Pattern
- Dead Letter Queues
- Message Filtering

**Tasks:**
- [ ] Create SQS queue
- [ ] Create SNS topic
- [ ] Setup subscriptions
- [ ] Test message flow
- [ ] Implement DLQ
- [ ] Monitor messages

**Hands-on Project:** Add async processing to Biosoltamax Bot

**Time:** 3 hours

---

#### Day 18: Secrets Manager & CloudTrail
**Topics:**
- Secrets Manager
- Automatic Rotation
- CloudTrail Logging
- Audit & Compliance
- Security Best Practices

**Tasks:**
- [ ] Move secrets to Secrets Manager
- [ ] Setup automatic rotation
- [ ] Enable CloudTrail
- [ ] Review audit logs
- [ ] Create security alerts

**Hands-on Project:** Secure all API keys & credentials

**Time:** 3 hours

---

#### Day 19-20: EKS (Kubernetes)
**Topics:**
- Kubernetes Basics
- EKS Cluster Setup
- Node Groups
- kubectl Commands
- Helm Charts
- Ingress Controllers

**Tasks:**
- [ ] Learn Kubernetes fundamentals
- [ ] Create EKS cluster
- [ ] Deploy sample app
- [ ] Setup kubectl
- [ ] Install Helm
- [ ] Deploy with Helm chart

**Hands-on Project:** Deploy Google Workspace MCP to EKS

**Time:** 5 hours

---

#### Day 21: Final Project & Review
**Tasks:**
- [ ] Deploy all 3 projects to AWS
- [ ] Complete infrastructure with IaC
- [ ] Setup monitoring & alerting
- [ ] Optimize costs
- [ ] Document everything
- [ ] Create architecture diagrams
- [ ] Write deployment guide

**Deliverables:**
1. SmartCS Landing (S3 + CloudFront)
2. Biosoltamax Bot (ECS Fargate + RDS)
3. Google Workspace MCP (Lambda + API Gateway)
4. CloudFormation templates for all
5. Complete monitoring dashboard
6. Documentation

**Time:** 4 hours

**Week 3 Total:** 20 hours

---

## 📊 PROGRESS TRACKING

### Week 1: Fundamentals
- [ ] Day 1: Cloud Computing Basics (0/4 lessons)
- [ ] Day 2-3: EC2 (0/6 lessons)
- [ ] Day 4: S3 (0/5 lessons)
- [ ] Day 5-6: IAM (0/7 lessons)
- [ ] Day 7: VPC (0/5 lessons)

**Progress:** 0/27 lessons (0%)

### Week 2: DevOps Services
- [ ] Day 8: RDS (0/5 lessons)
- [ ] Day 9-10: ECS & ECR (0/6 lessons)
- [ ] Day 11: Lambda (0/4 lessons)
- [ ] Day 12: CloudWatch (0/5 lessons)
- [ ] Day 13: Load Balancer & Auto Scaling (0/4 lessons)
- [ ] Day 14: Review

**Progress:** 0/24 lessons (0%)

### Week 3: Advanced
- [ ] Day 15-16: CloudFormation (0/5 lessons)
- [ ] Day 17: SQS & SNS (0/4 lessons)
- [ ] Day 18: Secrets Manager & CloudTrail (0/4 lessons)
- [ ] Day 19-20: EKS (0/6 lessons)
- [ ] Day 21: Final Project

**Progress:** 0/19 lessons (0%)

**Total Progress:** 0/70 lessons (0%)

---

## 💰 COST ESTIMATE

### AWS Free Tier (12 months)
- ✅ EC2: 750 hours/month (t2.micro)
- ✅ S3: 5GB storage + 20,000 GET requests
- ✅ RDS: 750 hours/month (db.t2.micro, 20GB)
- ✅ Lambda: 1M requests + 400,000 GB-seconds
- ✅ CloudWatch: 10 custom metrics + 5GB logs
- ✅ CloudFront: 50GB data transfer
- ✅ ECS: Free (pay for EC2/Fargate)
- ✅ Fargate: 50GB-hours free trial

**Estimated Monthly Cost:**
- Month 1-12: **$0-5** (within Free Tier)
- After 12 months: **$15-25/month**

**Cost Optimization Tips:**
- Stop EC2 instances when not in use
- Delete unused resources
- Use Fargate Spot for dev/test
- Enable S3 lifecycle policies
- Set billing alarms

---

## 🎯 SUCCESS METRICS

### After 21 Days:

**Knowledge:**
- ✅ Understand 15+ AWS services
- ✅ Can deploy production apps to AWS
- ✅ Can write CloudFormation templates
- ✅ Can setup monitoring & alerting
- ✅ Can optimize costs

**Skills:**
- ✅ AWS Console proficiency
- ✅ AWS CLI usage
- ✅ Infrastructure as Code
- ✅ Container orchestration
- ✅ Serverless architecture

**Projects:**
- ✅ 3 production deployments on AWS
- ✅ Complete IaC templates
- ✅ Monitoring dashboards
- ✅ Architecture documentation

**Skill Score:**
- DevOps: 7/10 → 8.5/10 (+1.5)
- Cloud: 7/10 → 9/10 (+2.0)
- Infrastructure: 6/10 → 8.5/10 (+2.5)

---

## 📚 ADDITIONAL RESOURCES

### Official AWS Resources
- [AWS Documentation](https://docs.aws.amazon.com/)
- [AWS Skill Builder](https://skillbuilder.aws/)
- [AWS Free Tier](https://aws.amazon.com/free/)
- [AWS Architecture Center](https://aws.amazon.com/architecture/)

### Video Tutorials
- [Cloud Champ YouTube](https://www.youtube.com/@cloudchamp)
- [Course Playlist](https://youtube.com/playlist?list=PLOa-edppsqFn4MFr5KDqm0Y92d2nGyGgQ)

### Tools
- AWS CLI
- AWS CloudShell
- Terraform (for IaC alternative)
- kubectl (for EKS)
- Helm (for Kubernetes)

---

## 🚀 GETTING STARTED

### Today (Day 0):
```bash
# 1. Repository already cloned ✅
cd e:/ZAHRA-WORKSPACE/docs/aws-learning

# 2. Read main README
cat README.md

# 3. Start with Cloud Computing Basics
cd Cloud_Computing_Basics
cat README.md

# 4. Create AWS Free Tier account
# Visit: https://aws.amazon.com/free/

# 5. Install AWS CLI
# Windows: https://aws.amazon.com/cli/
# Or use AWS CloudShell (browser-based)
```

### Tomorrow (Day 1):
- [ ] Complete Cloud Computing Basics (4 lessons)
- [ ] Watch intro videos
- [ ] Take notes
- [ ] Prepare for EC2 hands-on

---

## 📝 NOTES & TIPS

### Best Practices:
1. **Always use Free Tier** for learning
2. **Set billing alarms** ($5, $10, $20)
3. **Delete resources** after practice
4. **Tag everything** for cost tracking
5. **Use IAM roles** instead of access keys
6. **Enable MFA** on root account
7. **Document everything** you learn

### Common Pitfalls:
- ❌ Leaving EC2 instances running
- ❌ Not deleting EBS volumes
- ❌ Forgetting to stop RDS instances
- ❌ Using root account for daily tasks
- ❌ Not setting up billing alerts

### Time Management:
- 📅 Dedicate 2-3 hours/day
- 🎯 Focus on hands-on practice
- 📝 Document as you learn
- 🔄 Review previous topics
- 💪 Don't skip exercises

---

## ✅ CHECKLIST

### Pre-requisites:
- [x] Repository cloned
- [ ] AWS Free Tier account created
- [ ] AWS CLI installed
- [ ] Billing alerts configured
- [ ] IAM user created (not root)
- [ ] MFA enabled

### Week 1 Goals:
- [ ] Complete all fundamentals
- [ ] Deploy 1 project to AWS
- [ ] Understand core services
- [ ] Practice with AWS Console

### Week 2 Goals:
- [ ] Master DevOps services
- [ ] Deploy 2 more projects
- [ ] Setup monitoring
- [ ] Implement auto-scaling

### Week 3 Goals:
- [ ] Learn advanced topics
- [ ] Complete IaC templates
- [ ] Optimize all deployments
- [ ] Document everything

---

**Status:** ✅ Ready to Start
**Start Date:** 2026-03-25
**Target Completion:** 2026-04-15 (21 days)
**Time Investment:** 56 hours total
**Expected Outcome:** AWS DevOps proficiency

**Let's build! 🚀**
